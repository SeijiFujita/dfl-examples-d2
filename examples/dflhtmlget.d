/*
	DFL HTMLget written by Christopher E. Miller
	This code is public domain.
	You may use it for any purpose.
	This code has no warranties and is provided 'as-is'.
*/

// To compile:
// 	dfl dflhtmlget -gui

private import std.string, std.socket, std.uri;

private import dfl.all;


class MainForm: Form
{
	RichTextBox disp; // HTML display.
	TextBox urlBox;
	Button okb;
	
	string url;
	string domain;
	uint addr;
	ushort port;
	
	
	this()
	{
		text = "DFL HTMLget";
		
		Label label;
		with(label = new Label)
		{
			label.text = "&Address:";
			bounds = Rect(4, 3, 50, 14);
			parent = this;
		}
		
		with(urlBox = new TextBox)
		{
			text = "http://www.digitalmars.com/d/";
			maxLength = 1000;
			left = 58;
			// width set in layout event.
			parent = this;
		}
		
		with(okb = new Button)
		{
			text = "Go";
			width = 35;
			// left set in layout event.
			parent = this;
			
			click ~= &okb_click; // Register click handler.
		}
		acceptButton = okb; // Set this button as the accept (default) button.
		
		with(disp = new RichTextBox)
		{
			font = new Font("Courier New", 10f);
			disp.maxLength = int.max;
			detectUrls = false; // Note: may want to detect and handle them later.
			location = Point(0, okb.bottom);
			// size set in layout event.
			parent = this;
		}
		
		layout ~= &form_layout; // Register layout handler to move and resize controls.
		
		size = Size(600, 400);
	}
	
	
	// Layout handler.
	private void form_layout(Object sender, LayoutEventArgs ea)
	{
		urlBox.width = this.clientSize.width - urlBox.left - okb.width;
		okb.left = urlBox.right;
		disp.size = Size(this.clientSize.width, this.clientSize.height - disp.top);
	}
	
	
	// Click handler for OK button.
	private void okb_click(Object sender, EventArgs ea)
	{
		try
		{
			// Disable controls that may interfere.
			okb.enabled = false;
			disp.enabled = false;
			
			disp.text = null; // Empty HTML display.
			
			// Get typed URL.
			url = urlBox.text;
			url = std.string.strip(url);
			url = std.uri.encode(url);
			
			// Parse the URL...
			int i;
			
			i = std.string.indexOf(url, "://");
			if(i != -1)
			{
				if(icmp(url[0 .. i], "http"))
					throw new Exception("http:// expected");
				url = url[i + 3 .. url.length]; // Strip off protocol.
			}
			
			i = std.string.indexOf(url, '#');
			if(i != -1) // Remove anchor ref.
				url = url[0 .. i];
			
			i = std.string.indexOf(url, '/');
			if(i == -1)
			{
				domain = url;
				url = "/";
			}
			else
			{
				domain = url[0 .. i];
				url = url[i .. url.length];
			}
			// -url- is now the server virtual URI.
			assert(url[0] == '/');
			
			i = std.string.indexOf(domain, ':');
			if(i == -1)
			{
				port = 80; // Default HTTP port.
			}
			else
			{
				port = std.conv.to!ushort(domain[i + 1 .. domain.length]);
				domain = domain[0 .. i];
			}
			
			disp.selectedText = "Connecting to " ~ domain ~ " on port " ~ std.conv.to!string(port) ~ "...\r\n";
			
			// See if it's an IP address.
			addr = InternetAddress.parse(domain);
			if(InternetAddress.ADDR_NONE == addr)
			{
				// It is not an IP address, so resolve as hostname.
				// Resolve it asynchronously so that we don't block the GUI...
				// Choose what to use as a callback delegate.
				asyncGetHostByName(domain, &gettingHostCallback);
			}
			else
			{
				// It is an IP address, so connect to it!
				doConnect();
			}
		}
		catch(DflThrowable e)
		{
			disp.selectedText = "Error: " ~ e.toString() ~ "\r\n";
			reEnable();
		}
	}
	
	
	void reEnable()
	{
		// Re-enable disabled controls.
		okb.enabled = true;
		disp.selectionStart = 0;
		disp.enabled = true;
	}
	
	
	void gettingHostCallback(InternetHost inetHost, int err)
	{
		if(err)
		{
			// Oops, failed to lookup the hostname.
			disp.selectedText = "Unable to resolve " ~ domain ~ "\r\n";
			
			// Go back and let the user try another.
			reEnable();
		}
		else
		{
			// Resolved, connect to it!
			addr = inetHost.addrList[0];
			doConnect();
		}
	}
	
	
	void doConnect()
	{
		// Reset state variable.
		gotHeader = false;
		
		// Setup an acynchronous socket.
		AsyncTcpSocket sock;
		sock = new AsyncTcpSocket;
		
		// Setup a read/write queue for the socket.
		// -queue- is declared as private below.
		queue = new SocketQueue(sock);
		
		// Choose which events I want and what to use as a callback delegate.
		sock.event(EventType.CONNECT | EventType.READ | EventType.WRITE | EventType.CLOSE, &onSocketEvent);
		
		// Finally, initiate connection!
		sock.connect(new InternetAddress(addr, port));
	}
	
	
	void onSocketEvent(Socket sock, EventType type, int err)
	{
		if(!queue)
			return; // In case the connection closed while a socket event was waiting.
		
		switch(type)
		{
			case EventType.READ: // Time to receive.
				// Let the queue read the data first.
				queue.readEvent();
				
				// Check the queue.
				onRead();
				if(!queue)
					return;
				
				// Make sure there's not too much data in the queue.
				if(queue.receiveBytes() > 0x4000)
				{
					// If too much data received, abort the connection.
					// Don't want to consume too much memory.
					onClose();
					
					// Report what happened...
					msgBox(this, "Too much data");
				}
				break;
			
			case EventType.WRITE: // Able to send more data; this event is not re-sent unless you send something.
				// Let the queue handle writing data I've added to it.
				queue.writeEvent();
				break;
			
			case EventType.CONNECT:
				onConnect();
				break;
			
			case EventType.CLOSE:
				// Can be more to read upon remote disconnection.
				queue.readEvent();
				onRead();
				if(!queue)
					return;
				
				onClose();
				
				// Report what happened if connection closed too early.
				if(!gotHeader)
					msgBox(this, "Connection closed");
				break;
			
			default: ;
		}
	}
	
	
	void onConnect()
	{
		// Note: may want to add a timer to make sure we get data in a timely manner.
		
		// Queue up the HTTP request.
		sendRequest();
	}
	
	
	void sendRequest()
	{
		// Send the HTTP request via the queue.
		
		disp.selectedText = "Connected!\r\nRequesting URL \"" ~ url ~ "\"...\r\n";
		
		char[] request;
		
		request ~= "GET " ~ url ~ " HTTP/1.0\r\n"
			"Accept-Charset: utf-8\r\n"
			"Host: " ~ domain;
		if(port != 80)
			request ~= ":" ~ std.conv.to!string(port);
		request ~= "\r\n\r\n";
		
		//msgBox(request);
		
		// Finally, add it to the queue to be sent!
		queue.send(request);
	}
	
	
	// Note: if non UTF-8 is received, it will result in an exception;
	// better handling should be added, but this is just an example.
	
	void onRead()
	{
		// Time to check the queue.
		
		int i;
		string s;
		
		again:
		if(!gotHeader)
		{
			// Not removing from the queue if there's not an entire line yet.
			// Just peek at it for now.
			s = cast(string)queue.peek();
			
			const string HTTP_EOL = "\r\n";
			
			i = std.string.indexOf(s, HTTP_EOL);
			if(-1 != i)
			{
				// Found HTTP_EOL.
				string line;
				line = s[0 .. i];
				
				// Remove the line from the queue first.
				queue.receive(i + HTTP_EOL.length); // Removes -i- bytes plus the HTTP_EOL.
				
				if(!line.length)
				{
					// If the line is empty, it's the end of the header.
					gotHeader = true;
					
					// Reset display to prepare for HTML.
					disp.text = null;
				}
				
				// Process the line.
				const string CONTENT_TYPE_NAME = "Content-Type: ";
				if(line.length > CONTENT_TYPE_NAME.length &&
					!icmp(CONTENT_TYPE_NAME, line[0 .. CONTENT_TYPE_NAME.length]))
				{
					string type;
					type = line[CONTENT_TYPE_NAME.length .. line.length];
					if(type.length <= 5 || icmp("text/", type[0 .. 5]))
					{
						// URL is not text.
						// Close the connection early.
						onClose();
						
						// Report what happened...
						msgBox(this, "URL is not text");
						
						return;
					}
				}
				
				// Read some more.
				//if(queue.peek().length)
					goto again;
			}
		}
		else // gotHeader == true
		{
			// Not removing from the queue if there's not an entire tag yet.
			// Just peek at it for now.
			s = cast(string)queue.peek();
			
			/+
			disp.selectedText = s;
			queue.receive();
			return;
			+/
			
			//if(s.length)
			{
				size_t startiw = size_t.max, iw;
				new_tag:
				for(iw = 0; iw != s.length; iw++)
				{
					switch(s[iw])
					{
						case '<':
							if(startiw == size_t.max)
								startiw = iw;
							break;
						
						case '>':
							if(startiw != size_t.max)
							{
								if(iw - startiw >= 4 && // See if it's a comment.
									s[startiw + 1] == '!' && s[startiw + 2] == '-' && s[startiw + 3] == '-')
								{
									// It's a comment..
									if(s[iw - 1] == '-' && s[iw - 2] == '-')
									{
										if(startiw)
											disp.selectedText = s[0 .. startiw];
										
										disp.selectionColor = Color(0x7F, 0x7F, 0x7F);
										disp.selectedText = s[startiw .. iw + 1];
									}
									else
									{
										// Need to keep looking for the end.
										continue;
									}
								}
								else
								{
									if(startiw)
										disp.selectedText = s[0 .. startiw];
									
									disp.selectionColor = Color(0xBB, 0, 0);
									disp.selectedText = s[startiw .. iw + 1];
								}
								disp.selectionColor = disp.foreColor;
								
								// Start looking for another tag.
								startiw = size_t.max;
								queue.receive(iw + 1); // Remove these bytes from the queue.
								s = s[iw + 1 .. s.length];
								goto new_tag;
							}
							break;
						
						default: ;
					}
				}
			}
		}
	}
	
	
	void onClose()
	{
		if(gotHeader)
		{
			// Need to empty the queue of received data in case onRead()
			// left some there due to an incomplete tag.
			if(queue.receiveBytes())
				disp.selectedText = cast(string)queue.receive();
		}
		
		// Re-enable disabled controls.
		reEnable();
		
		// Clean up.
		queue.socket.close();
		queue = null;
	}
	
	
	private:
	SocketQueue queue; // Only valid while connected.
	bool gotHeader;
}


int main()
{
	int result = 0;
	
	try
	{
		Application.enableVisualStyles();
		
		Application.run(new MainForm);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

