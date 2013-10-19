// To compile:
// 	dfl tip -gui


private import dfl.all;


class TipForm: Form
{
	TextBox upbox;
	Button gobtn;
	
	
	this()
	{
		text = "Tip";
		
		upbox = new TextBox;
		upbox.parent = this;
		upbox.text = "Text here.";
		upbox.width = 180;
		
		gobtn = new Button;
		gobtn.parent = this;
		gobtn.text = "&Go!";
		gobtn.left = 184;
		gobtn.click ~= &defClick;
		
		Label label;
		label = new Label;
		label.parent = this;
		label.text = "Hover mouse over controls.";
		label.bounds = Rect(15, 80, 160, 13);
		
		// Set default button.
		acceptButton = gobtn;
		
		// Set tooltips.
		ToolTip tt;
		tt = new ToolTip;
		tt.setToolTip(this, "Keep going...");
		tt.setToolTip(upbox, "Enter some text here.");
		tt.setToolTip(gobtn, "Go here.");
		tt.setToolTip(label, "No.. Not this one!  OH NO!!");
	}
	
	
	private void defClick(Object sender, EventArgs ea)
	{
		msgBox("Gone!");
	}
}


int main()
{
	int result = 0;
	
	try
	{
		Application.enableVisualStyles();
		Application.run(new TipForm);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

