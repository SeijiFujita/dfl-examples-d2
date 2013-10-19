// Written by Christopher E. Miller
// This code is public domain.

// To compile:
// 	dfl tiplist -gui


private import dfl.all;


class MainForm: Form
{
	ToolTip ttip;
	ListBox lbox;
	int lastLboxTipIndex = -1;
	
	
	this()
	{
		startPosition = FormStartPosition.CENTER_SCREEN;
		text = "tiplist";
		
		ttip = new ToolTip;
		
		with(lbox = new ListBox)
		{
			integralHeight = false;
			width = 120;
			dock = DockStyle.LEFT;
			
			sorted = true;
			items.add("zero");
			items.add("3");
			items.add("1");
			items.add("fast!");
			items.add("furious");
			items.add("2");
			items.add("+");
			items.add("-");
			items.add("last");
			
			parent = this;
			
			mouseMove ~= &lbox_mouseMove;
		}
	}
	
	
	private void lbox_mouseMove(Object sender, MouseEventArgs ea)
	{
		int li;
		li = lbox.indexFromPoint(ea.x, ea.y);
		if(li != lastLboxTipIndex)
		{
			if(li == -1)
			{
				lastLboxTipIndex = -1;
				ttip.setToolTip(lbox, null);
			}
			else 
			{
				lastLboxTipIndex = li;
				ttip.setToolTip(lbox, lbox.items[li].toString());
			}
		}
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

