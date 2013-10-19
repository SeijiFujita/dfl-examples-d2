// Written by Christopher E. Miller
// This code is public domain.

// To compile:
// 	dfl rps -gui


private import std.socket, std.string, std.conv;

private import dfl.all;


const ushort DEFAULT_PORT = 8383;
const int PADDING = 6;


class GameForm: Form
{
	bool connected = false;
	TextBox serverBox;
	Button mainBtn;
	Label status;
	Timer ctimer;
	Socket mysock;
	Button rockBtn, paperBtn, scissorsBtn;
	bool gameover = false;
	
	
	this()
	{
		text = "DFL Rock Paper Scissors";
		formBorderStyle = FormBorderStyle.FIXED_DIALOG;
		maximizeBox = false;
		clientSize = Size(260, 132);
		startPosition = FormStartPosition.CENTER_SCREEN;
		
		Label label;
		with(label = new Label)
		{
			label.text = "Server:";
			bounds = Rect(PADDING, PADDING + 3, 70 - PADDING, 14);
			parent = this;
		}
		
		with(serverBox = new TextBox)
		{
			text = "localhost";
			bounds = Rect(70, PADDING, this.clientSize.width - 70 - PADDING, height);
			parent = this;
		}
		
		with(mainBtn = new Button)
		{
			text = "Play";
			click ~= &mainBtnClick;
			bounds = Rect(this.clientSize.width - 100 - PADDING, 28 + PADDING, 100, height);
			parent = this;
		}
		this.acceptButton = mainBtn;
		
		int squareWidth = (this.clientSize.width - PADDING * 4) / 3;
		
		with(rockBtn = new Button)
		{
			text = "&Rock";
			bounds = Rect(PADDING, 72, squareWidth, 30);
			enabled = false;
			parent = this;
			click ~= &rockClick;
		}
		
		with(paperBtn = new Button)
		{
			text = "&Paper";
			bounds = Rect(PADDING + squareWidth + PADDING, 72, squareWidth, 30);
			enabled = false;
			parent = this;
			click ~= &paperClick;
		}
		
		with(scissorsBtn = new Button)
		{
			text = "&Scissors";
			bounds = Rect(PADDING + squareWidth + PADDING + squareWidth + PADDING, 72, squareWidth, 30);
			enabled = false;
			parent = this;
			click ~= &scissorsClick;
		}
		
		with(status = new Label)
		{
			useMnemonic = false;
			status.text = "Press play to begin.";
			bounds = Rect(PADDING, rockBtn.bottom + PADDING + 3, this.clientSize.width, 14);
			parent = this;
		}
		
		ctimer = new Timer;
		ctimer.tick ~= &connTimeout;
		ctimer.interval = 30_000;
	}
	
	
	void rockClick(Object sender, EventArgs ea)
	{
		mysock.send("r");
		disableGame();
		status.text("Rock.");
	}
	
	
	void paperClick(Object sender, EventArgs ea)
	{
		mysock.send("p");
		disableGame();
		status.text("Paper.");
	}
	
	
	void scissorsClick(Object sender, EventArgs ea)
	{
		mysock.send("s");
		disableGame();
		status.text("Scissors.");
	}
	
	
	void enableActions()
	{
		this.acceptButton = mainBtn;
		
		mainBtn.text = "Play";
		mainBtn.enabled = true;
		serverBox.enabled = true;
	}
	
	
	void disableGame()
	{
		rockBtn.enabled = false;
		paperBtn.enabled = false;
		scissorsBtn.enabled = false;
	}
	
	
	void enableGame()
	{
		rockBtn.enabled = true;
		paperBtn.enabled = true;
		scissorsBtn.enabled = true;
	}
	
	
	void killConnectedSocket()
	{
		connected = false;
		if(mysock)
		{
			mysock.close();
			dfl.socket.unregisterEvent(mysock);
			mysock = null;
		}
		
		disableGame();
		enableActions();
	}
	
	
	void connTimeout(Object sender, EventArgs ea)
	{
		ctimer.stop();
		
		status.text = "Connection timeout.";
		killConnectedSocket();
	}
	
	
	void mainBtnClick(Object sender, EventArgs ea)
	{
		if(connected)
		{
			// Disconnect...
			connected = false;
			killConnectedSocket();
			status.text = "Game aborted.";
		}
		else
		{
			// Connect...
			
			string servaddr;
			ushort servport;
			int i;
			
			servaddr = serverBox.text;
			servport = DEFAULT_PORT;
			i = std.string.indexOf(servaddr, ':');
			if(i != -1)
			{
				servport = std.conv.to!ushort(servaddr[i + 1 .. servaddr.length]);
				servaddr = servaddr[0 .. i];
			}
			
			this.acceptButton = null;
			
			mainBtn.enabled = false;
			serverBox.enabled = false;
			
			status.text = "Preparing game...";
			gameover = false;
			ctimer.start();
			
			try
			{
				mysock = new TcpSocket;
				dfl.socket.registerEvent(mysock, // Socket to get events for.
					EventType.CONNECT | EventType.CLOSE | EventType.READ, // Which events I want.
					&netEvent); // Callback delegates that receives the events.
				mysock.connect(new InternetAddress(servaddr, servport));
			}
			catch
			{
				status.text = "Connection error.";
				ctimer.stop();
				enableActions();
			}
		}
	}
	
	
	void netEvent(Socket sock, EventType type, int err)
	{
		switch(type)
		{
			case EventType.CONNECT:
				ctimer.stop();
				
				if(err)
				{
					status.text = "Unable to connect. Error #" ~ std.conv.to!string(err) ~ ".";
					sock.close();
					mysock = null;
					
					enableActions();
				}
				else
				{
					connected = true;
					// Other events could fire before this one.
					//status.text = "Waiting for opponent...";
					
					mainBtn.text = "&Abort";
					mainBtn.enabled = true;
				}
				break;
			
			case EventType.CLOSE:
				if(!gameover) // Didn't get a response.
					status.text = "Game aborted.";
				
				killConnectedSocket();
				break;
			
			case EventType.READ:
				char[1] data;
				if(sock.receive(data) != 1)
				{
					status.text = "Read error.";
					
					killConnectedSocket();
				}
				else
				{
					switch(data[0])
					{
						case 'g':
							if(gameover)
								status.text = status.text ~ " Make your next move!";
							else
								status.text = "Make your move!";
							gameover = false;
							enableGame();
							break;
						
						case 'd':
							gameover = true;
							status.text = "Opponent forfeits the game.";
							disableGame();
							break;
						
						case 'w':
							gameover = true;
							status.text = "You win!";
							disableGame();
							break;
						
						case 'l':
							gameover = true;
							status.text = "You lose!";
							disableGame();
							break;
						
						case 't':
							gameover = true;
							status.text = "Tie game!";
							disableGame();
							break;
					}
				}
				break;
			
			default: ;
		}
	}
}


int main()
{
	Application.run(new GameForm);
	return 0;
}

