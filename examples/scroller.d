private import dfl.all;


class DflScroller: dfl.form.Form
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	dfl.label.Label topLabel;
	dfl.label.Label bottomLabel;
	//~Entice Designer variables end here.
	
	
	this()
	{
		initializeDflScroller();
		
		scrollSize = Size(bottomLabel.right, bottomLabel.bottom);
		vScroll = true;
		hScroll = true;
	}
	
	
	private void initializeDflScroller()
	{
		// Do not manually edit this block of code.
		//~Entice Designer 0.8.1 code begins here.
		//~DFL Form
		text = "DFL Scroller";
		clientSize = dfl.drawing.Size(292, 266);
		//~DFL dfl.label.Label=topLabel
		topLabel = new dfl.label.Label();
		topLabel.name = "topLabel";
		topLabel.backColor = dfl.drawing.Color(0, 193, 97);
		topLabel.font = new dfl.drawing.Font("Courier New", 14f, dfl.drawing.FontStyle.BOLD);
		topLabel.foreColor = dfl.drawing.Color(0, 0, 0);
		topLabel.text = "Top";
		topLabel.bounds = dfl.drawing.Rect(8, 8, 124, 71);
		topLabel.parent = this;
		//~DFL dfl.label.Label=bottomLabel
		bottomLabel = new dfl.label.Label();
		bottomLabel.name = "bottomLabel";
		bottomLabel.backColor = dfl.drawing.Color(23, 138, 232);
		bottomLabel.font = new dfl.drawing.Font("Tahoma", 14f, dfl.drawing.FontStyle.BOLD);
		bottomLabel.foreColor = dfl.drawing.Color(255, 255, 255);
		bottomLabel.text = "Bottom";
		bottomLabel.textAlign = dfl.base.ContentAlignment.BOTTOM_RIGHT;
		bottomLabel.bounds = dfl.drawing.Rect(8, 352, 220, 31);
		bottomLabel.parent = this;
		//~Entice Designer 0.8.1 code ends here.
	}
}


int main()
{
	int result = 0;
	
	try
	{
		// Application initialization code here.
		
		Application.run(new DflScroller());
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

