// Written by Christopher E. Miller
// This code is public domain.

// To compile:
// 	dfl dfltest


// Note: DFL code should not be written this way. This is only a test. See other examples for better guidelines.

import std.datetime;
import std.stdio;

import dfl.all;

int main()
{
	writeln("Exe = ", Application.executablePath);
	writeln("Dir = ", Application.startupPath);
	writeln("Operating system = ", Environment.osVersion.toString());
	writeln("Command line = ", Environment.commandLine);
	writeln("Current directory = ", Environment.currentDirectory);
	writeln("System directory = ", Environment.systemDirectory);
	writeln("User name = ", Environment.userName);
	writeln("Tick count = ", Environment.tickCount);
	writeln(Environment.expandEnvironmentVariables("WINDIR environment variable = %WINDIR%"));
	writeln("PATH environment variable = ", Environment.getEnvironmentVariable("PATH"));
	
	string[] drives = Environment.getLogicalDrives();
	writeln(drives.length, "logical drives:");
	foreach(string s; drives)
	{
		writeln("   ", s);
	}
	
	// Registry.
	RegistryKey rkey;
	
	writeln(r"Creating key HKCU\Software\DFL Test...");
	rkey = Registry.currentUser.createSubKey(`software\DFL Test`);
	
	writeln("Key created; creating values...");
	rkey.setValue("str", "Hello, world");
	rkey.setValue("num", 0xADEADF00);
	rkey.setValue("dyn", 0x8A3);
	rkey.setValue("DYn", 0x3AAA3);
	rkey.setValue("zip", 0);
	
	writeln("Closing and reopening key...");
	rkey.close();
	rkey = Registry.currentUser.openSubKey(`software\dfl test`);
	
	writeln("Values are:");
	foreach(string name; rkey.getValueNames())
	{
		string val;
		val = rkey.getValue(name).toString();
		writeln("\t", name, " = (len=", val.length, ") ", val);
	}
	rkey.close();
	
	writeln("Deleting key...");
	Registry.currentUser.deleteSubKey(`software\dfl test`);
	
	// Clipboard.
	IDataObject dobj;
	dobj = Clipboard.getDataObject();
	if(dobj.getDataPresent(DataFormats.text))
	{
		writeln("Text on the clipboard: '", dobj.getData(DataFormats.text).getText(), "'");
	}
	else
	{
		writeln("No text on the clipboard.");
	}
	Clipboard.setDataObject(Data(cast(ubyte[])("Now: " ~ Clock.currTime().toSimpleString())));

	dobj = Clipboard.getDataObject();
	assert(dobj !is null);
	if(dobj.getDataPresent(DataFormats.text))
	{
		writeln("Text on the clipboard: '", dobj.getData(DataFormats.text).getText(), "'");
	}
	else
	{
		writeln("No text on the clipboard.");
	}
	
	// Now try setting an entire data object on the clipboard.
	DataObject d;
	d = new DataObject;
	d.setData(Data(cast(ubyte[])"Yeehaw!"));
	d.setData(Data("Yeehaw!"));
	Clipboard.setDataObject(Data(d), true);
	
	writeln("Done.");
	
	try
	{
		Form f = new Form;
		assert(f.findForm() is f);
		string ftext = "DFL";
		//f.windowState = FormWindowState.MAXIMIZED;
		//f.startPosition = FormStartPosition.CENTER_PARENT;
		f.dockPadding.all = 16;
		//f.opacity = 0.7;
		//f.showInTaskbar = false;
		f.text = ftext;
		f.backColor = Color(22, 66, 202);
		f.visibleChanged ~= delegate(Object sender, EventArgs ea)
		{
			writeln("f.visibleChanged; visible = ", f.visible ? "true" : "false");
		};
		f.enabledChanged ~= delegate(Object sender, EventArgs ea)
		{
			if(f.enabled)
				f.text = ftext;
			else
				f.text = ftext ~ " [disabled]";
			
			writeln("f.enabledChanged; enabled = ", f.enabled ? "true" : "false");
		};
		
		
		void shortcut_ctrlT(Object sender, FormShortcutEventArgs ea)
		{
			msgBox("Shortcut Ctrl+T pressed.");
		}
		
		f.addShortcut(Keys.CONTROL | Keys.T, &shortcut_ctrlT);
		
		Label ctrl = new Label;
		assert(ctrl.findForm() is null);
		ctrl.size = Size(90, 16);
		ctrl.location = Point(20, 20);
		ctrl.backColor = Color(0xFF, 0, 0);
		ctrl.parent = f;
		assert(ctrl.findForm() is f);
		//ctrl.anchor = AnchorStyles.RIGHT | AnchorStyles.LEFT;
		ctrl.dock = DockStyle.RIGHT;
		ctrl.click ~= delegate(Object sender, EventArgs ea)
			{
				switch(ctrl.borderStyle())
				{
					case BorderStyle.NONE:
						ctrl.borderStyle = BorderStyle.FIXED_3D;
						break;
					
					case BorderStyle.FIXED_3D:
						ctrl.borderStyle = BorderStyle.FIXED_SINGLE;
						break;
					
					case BorderStyle.FIXED_SINGLE:
						ctrl.borderStyle = BorderStyle.NONE;
						break;
				// add default
					default:
						assert(0);
						break;
				}
			};
		
		Label cfoo;
		with(cfoo = new Label)
		{
			parent = f;
			cfoo.text = "&Label!";
			size = Size(32, 32);
			location = Point(100, 200);
			backColor = Color(0xB, 0xFF, 0x55);
			foreColor = Color(0, 0, 0xFF);
			dock = DockStyle.BOTTOM;
			click ~= delegate(Object sender, EventArgs ea) { useMnemonic = !useMnemonic; };
		}
		
		with(new Control)
		{
			dock = DockStyle.FILL;
			parent = f;
			//click ~= delegate(Object sender, EventArgs ea) { hide(); };
		}
		
		f.click ~= delegate(Object sender, EventArgs ea) { writeln(" --> Form Click!\n"); };
		
		void reshow(Object sender, EventArgs ea)
		{
			(cast(Timer)sender).stop();
			f.show();
		}
		
		void reenable(Object sender, EventArgs ea)
		{
			(cast(Timer)sender).stop();
			f.enabled = true;
		}
		
		void key(Object sender, KeyEventArgs kea)
		{
			Control ctrl = cast(Control)sender;
			switch(cast(char)kea.keyCode())
			{
				case 189: // -
					f.dockPadding.all = f.dockPadding.all - 4;
					break;
				
				case 187: // +
					f.dockPadding.all = f.dockPadding.all + 4;
					break;
				
				case 'B':
					{
						Form ownf;
						with(ownf = new Form)
						{
							text = "Owned";
							ownf.backColor = Color(250, 250, 0);
							size = Size(150, 150);
							formBorderStyle = FormBorderStyle.FIXED_DIALOG;
							maximizeBox = false;
							//location = f.location + Size(75, 75);
							startPosition = FormStartPosition.CENTER_PARENT;
							dockPadding.all = 10;
							
							with(new Panel)
							{
								dock = DockStyle.FILL;
								borderStyle = BorderStyle.FIXED_SINGLE;
								backColor = Color(0xFF, 0xFF, 0xFF);
								//click ~= &panelClick;
								
								parent = ownf;
							}
							
							//owner = f;
							showDialog(f);
							assert(isHandleCreated);
							dispose();
							assert(!isHandleCreated);
						}
					}
					break;
				
				case 'C':
					throw new Exception("Test exception.");
					break;
				
				case 'N':
					f.opacity = f.opacity - 0.1;
					break;
				
				case 'M':
					f.opacity = f.opacity + 0.1;
					break;
				
				case 'K':
					if(f.transparencyKey == Color.empty)
						f.transparencyKey = f.backColor;
					else
						f.transparencyKey = Color.empty;
					break;
				
				case 'W':
					f.controlBox = !f.controlBox;
					break;
				
				case 'O':
					f.minimizeBox = !f.minimizeBox;
					break;
				
				case 'P':
					f.maximizeBox = !f.maximizeBox;
					break;
				
				case 'A':
					ctrl.left = ctrl.left - 8;
					break;
				
				case 'S':
					ctrl.left = ctrl.left + 8;
					break;
				
				case 'D':
					ctrl.width = ctrl.width - 4;
					break;
				
				case 'F':
					ctrl.width = ctrl.width + 4;
					break;
				
				case 'G':
					delete cfoo;
					break;
				
				/+
				case 'H':
					foreach(Control cc; f.controls)
					{
						cc.hide();
					}
					Application.doEvents();
					
					// Reuse ctrl.
					with(ctrl = new Control)
					{
						backColor = Color(79, 120, 170);
						size = Size(6, 6);
						dock = DockStyle.TOP;
						parent = f;
					}
					break;
				+/
				
				case 'V':
					f.hide();
					with(new Timer)
					{
						interval = 2000;
						tick ~= &reshow;
						start();
					}
					break;
				
				case 'E':
					f.enabled = false;
					with(new Timer)
					{
						interval = 2000;
						tick ~= &reenable;
						start();
					}
					break;
				
				case 'Q':
					//f.showInTaskbar = !f.showInTaskbar;
					break;
				
				case '1':
					f.formBorderStyle = FormBorderStyle.NONE;
					assert(f.formBorderStyle == FormBorderStyle.NONE);
					break;
				
				case '2':
					f.formBorderStyle = FormBorderStyle.FIXED_3D;
					assert(f.formBorderStyle == FormBorderStyle.FIXED_3D);
					break;
				
				case '3':
					f.formBorderStyle = FormBorderStyle.FIXED_DIALOG;
					assert(f.formBorderStyle == FormBorderStyle.FIXED_DIALOG);
					break;
				
				case '4':
					f.formBorderStyle = FormBorderStyle.FIXED_SINGLE;
					assert(f.formBorderStyle == FormBorderStyle.FIXED_SINGLE);
					break;
				
				case '5':
					f.formBorderStyle = FormBorderStyle.FIXED_TOOLWINDOW;
					assert(f.formBorderStyle == FormBorderStyle.FIXED_TOOLWINDOW);
					break;
				
				case '6':
					f.formBorderStyle = FormBorderStyle.SIZABLE;
					assert(f.formBorderStyle == FormBorderStyle.SIZABLE);
					break;
				
				case '7':
					f.formBorderStyle = FormBorderStyle.SIZABLE_TOOLWINDOW;
					assert(f.formBorderStyle == FormBorderStyle.SIZABLE_TOOLWINDOW);
					break;
				
				case '8':
					f.windowState = FormWindowState.NORMAL;
					break;
				
				case '9':
					f.windowState = FormWindowState.MAXIMIZED;
					break;
				
				case '0':
					f.windowState = FormWindowState.MINIMIZED;
					break;
				
				default: ;
			}
		}
		f.keyPress ~= &key;
		ctrl.keyPress ~= &key;
		
		Application.run(f);
	}
	catch(DflThrowable o)
	{
		writeln("Caught error: ", o.toString());
	}
	
	writeln("Bye!\n");
	
	return 0;
}

