// To compile:
// 	dfl charformat -gui


private import dfl.all;


class MainForm: Form
{
	RichTextBox rtb;
	
	
	this()
	{
		text = "DFL charformat";
		size = Size(600, 400);
		windowState = FormWindowState.MAXIMIZED;
		
		with(rtb = new RichTextBox)
		{
			parent = this;
			font = new Font("Courier New", 10f); // Default font.
			rtb.backColor = Color(0xFF, 0xFF, 0xFF);
			rtb.foreColor = Color.fromRgb(0);
			dock = DockStyle.FILL;
			scrollBars = RichTextBoxScrollBars.VERTICAL;
			
			gotFocus ~= &rtb_gotFocus;
		}
		
		load ~= &form_load;
	}
	
	
	private void form_load(Object sender, EventArgs ea)
	{
		// Stream in formatted text by setting the selection formatting and then
		// setting the selected text.
		
		// If you want to apply formatting to existing text you would have to
		// select the text first using selectionStart and selectionLength.
		
		with(rtb)
		{
			rtb.selectionColor = Color.fromRgb(0);
			rtb.selectedText = "Then the developers said, ";
			
			rtb.selectionColor = Color(0xFF, 0, 0);
			rtb.selectionFont = new Font("Arial", 12f);
			rtb.selectedText = "\"DFL is wonderful\"";
			rtb.selectionFont = font; // Set the font back to the default rtb.font.
			
			rtb.selectionColor = Color.fromRgb(0);
			rtb.selectedText = " and proceeded to ";
			
			rtb.selectionFont = new Font("Courier New", 10f, FontStyle.ITALIC);
			rtb.selectedText = "astonish the ";
			rtb.selectionFont = new Font("Courier New", 10f, cast(FontStyle)(FontStyle.ITALIC | FontStyle.BOLD));
			rtb.selectedText = "world ";
			
			rtb.selectionFont = font; // Set the font back to the default rtb.font.
			rtb.selectedText = "with the app they developed.";
			
			rtb.selectionColor = Color.fromRgb(0);
			rtb.selectedText = "\r\n\r\nH";
			rtb.selectionSubscript = true;
			assert(selectionSubscript);
			rtb.selectedText = "2";
			rtb.selectionSubscript = false;
			assert(!selectionSubscript);
			rtb.selectedText = "0";
			
			rtb.selectedText = "\r\n\r\nx";
			rtb.selectionSuperscript = true;
			assert(selectionSuperscript);
			rtb.selectedText = "3";
			rtb.selectionSuperscript = false;
			assert(!selectionSuperscript);
			rtb.selectedText = " + 1";
		}
	}
	
	
	private void rtb_gotFocus(Object sender, EventArgs ea)
	{
		// Prevent the text from initially being highlighted when the form opens.
		rtb.selectionLength = 0;
		
		// Unregister this delegate from being called on focus events in the future.
		rtb.gotFocus.removeHandler(&rtb_gotFocus);
	}
}


int main()
{
	int result = 0;
	
	try
	{
		Application.run(new MainForm);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;

}

