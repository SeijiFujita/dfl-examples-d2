// To compile:
// 	dfl -gui toolbar toolbar.res

import dfl.all;


class ToolBarForm: dfl.form.Form
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	ToolBar toolbar;
	//~Entice Designer variables end here.
	
	
	this()
	{
		initializeToolBarForm();
		
		//@  Other ToolBarForm initialization code here.
		
		auto tblist = new ImageList();
		tblist.imageSize = Size(16, 15);
		tblist.transparentColor = Color(0xFF, 0, 0xFF);
		auto bmp = Application.resources.getBitmap("toolbar");
		if(bmp)
			tblist.images.addStrip(bmp);
		else
			msgBox("Unable to load bitmap resource");
		
		toolbar.imageList = tblist;
		
		// Add a ToolBarButton for each of the tool icons added from the above strip.
		foreach(idx, img; tblist.images)
		{
			auto tbb = new ToolBarButton();
			tbb.imageIndex = idx;
			toolbar.buttons.add(tbb);
		}
		
		toolbar.buttonClick ~= &toolbar_buttonClick;
	}
	
	
	private void toolbar_buttonClick(Object sender, ToolBarButtonClickEventArgs ea)
	{
		msgBox("ToolBar button clicked!");
	}
	
	
	private void initializeToolBarForm()
	{
		// Do not manually modify this function.
		//~Entice Designer 0.8.5.02 code begins here.
		//~DFL Form
		text = "Tool Bar Form";
		clientSize = dfl.all.Size(292, 266);
		//~DFL ToolBar:dfl.label.Label=toolbar
		toolbar = new ToolBar();
		toolbar.name = "toolbar";
		toolbar.dock = dfl.all.DockStyle.TOP;
		toolbar.bounds = dfl.all.Rect(0, 0, 292, 26);
		toolbar.parent = this;
		//~Entice Designer 0.8.5.02 code ends here.
	}
}


int main()
{
	int result = 0;
	
	try
	{
		Application.enableVisualStyles();
		
		//@  Other application initialization code here.
		
		Application.run(new ToolBarForm());
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

