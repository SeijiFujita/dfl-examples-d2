// To compile:
// 	dfl shortcut -gui


private import dfl.all;


class ShortcutKeys: Form
{
	this()
	{
		formBorderStyle = FormBorderStyle.FIXED_DIALOG;
		maximizeBox = false;
		startPosition = FormStartPosition.CENTER_SCREEN;
		text = "Shortcut Keys";
		clientSize = Size(280, 120);
		font = new Font("Fixedsys", 10);
		backColor = Color(180, 40, 20);
		foreColor = Color.fromRgb(cast(int)0);
		
		paint ~= &form_paint;
		
		addShortcut(Keys.ALT | Keys.F1, &shortcut_altF1);
		addShortcut(Keys.ALT | Keys.D1, &shortcut_alt1);
		addShortcut(Keys.CONTROL | Keys.N, &shortcut_ctrlN);
		addShortcut(Keys.CONTROL | Keys.M, &shortcut_ctrlM);
		addShortcut(Keys.CONTROL | Keys.SHIFT | Keys.Q, &shortcut_ctrlShiftQ);
	}
	
	
	private void form_paint(Object sender, PaintEventArgs ea)
	{
		ea.graphics.drawText("Shortcut keys are:\r\n"
			"\r\n   Alt+F1          Minimize"
			"\r\n   Alt+1           Top left"
			"\r\n   Ctrl+N          75% opacity"
			"\r\n   Ctrl+M          100% opacity"
			"\r\n   Ctrl+Shift+Q    Quit"
			, font, foreColor, Rect(4, 4, 300, 300));
	}
	
	
	private void shortcut_altF1(Object sender, FormShortcutEventArgs ea)
	{
		windowState = FormWindowState.MINIMIZED;
	}
	
	
	private void shortcut_alt1(Object sender, FormShortcutEventArgs ea)
	{
		location = Point(0, 0);
	}
	
	
	private void shortcut_ctrlN(Object sender, FormShortcutEventArgs ea)
	{
		opacity = 0.75;
	}
	
	
	private void shortcut_ctrlM(Object sender, FormShortcutEventArgs ea)
	{
		opacity = 1.0;
	}
	
	
	private void shortcut_ctrlShiftQ(Object sender, FormShortcutEventArgs ea)
	{
		Application.exitThread();
	}
}


int main()
{
	int result = 0;
	
	try
	{
		// Application initialization code here.
		
		Application.run(new ShortcutKeys);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

