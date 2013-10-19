// To compile:
// 	dfl rich -gui


// Note: DFL code should not be written this way. This is only a test. See other examples for better guidelines.


private import dfl.all, dfl.internal.winapi;


int main()
{
	Form f;
	RichTextBox rtb;
	
	with(f = new Form)
	{
		text = "RichTextBox";
	}
	
	with(rtb = new RichTextBox)
	{
		text = "Hello, RichTextBox.\r\n\r\nSelect some text to make it blue.\r\nGo ahead, try it.";
		dock = DockStyle.FILL;
		font = new Font("Tahoma", cast(float)12, FontStyle.BOLD);
		rtb.backColor = Color(0xD3, 0xDB, 0xD3);
		rtb.foreColor = Color(0, 0, 0);
		
		mouseUp ~= delegate(Object sender, MouseEventArgs ea)
		{
			//if(selectionLength)
			//	msgBox(selectedRtf, "Selected RTF");
			
			if(Control.modifierKeys & Keys.CONTROL)
			{
				// If ctrl is down set the background instead.
				if(selectionLength)
				{
					selectionBackColor = Color(0xFF, 0xFF, 0xFF);
				}
				else
				{
					selectionStart = 0;
					selectionLength = textLength;
					rtb.selectionBackColor = rtb.backColor; // Reset.
				}
			}
			else
			{
				if(selectionLength)
				{
					selectionColor = Color(0, 0, 0xFF);
				}
				else
				{
					rtb.foreColor = rtb.foreColor; // Reset.
				}
			}
			
			selectionLength = 0; // Remove selection.
		};
		
		linkClicked ~= delegate(Object sender, LinkClickedEventArgs ea)
		{
			msgBox(ea.linkText, "Link:");
		};
		
		gotFocus ~= delegate(Object sender, EventArgs ea)
		{
			selectionLength = 0;
			selectionStart = textLength;
		};
	}
	rtb.parent = f;
	
	Application.run(f);
	return 0;
}

