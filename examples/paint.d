// Written by Christopher E. Miller
// This code is public domain.

// To compile:
// 	dfl paint -gui


private import dfl.all;


class PaintForm: Form
{
	ColorDialog cd;
	
	
	void doPaint(Object sender, PaintEventArgs ea)
	{
		ea.graphics.drawIcon(icon, 25, 25);
	}
	
	
	this()
	{
		cd = new ColorDialog;
		
		Label ctrl;
		with(ctrl = new Label)
		{
			ctrl.text = "Paint!";
			size = Size(100, 100);
			
			backColor = Color(0xAF, 0, 0);
			foreColor = Color(0xB7, 0xC7, 0xDF);
			
			ctrl.paint ~= &doPaint; // Attach my paint handler.
			
			parent = this;
		}
		
		click ~= &form_click;
	}
	
	
	private void form_click(Object sender, EventArgs ea)
	{
		if(DialogResult.OK == cd.showDialog(this))
			this.backColor = cd.color;
	}
}


int main()
{
	int result = 0;
	
	try
	{
		Application.run(new PaintForm);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

