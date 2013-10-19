private import dfl.all;

import std.file;


class DirList: dfl.form.Form
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	dfl.label.Label dirName;
	dfl.treeview.TreeView dirView;
	//~Entice Designer variables end here.
	
	
	this()
	{
		initializeDirList();
		
		dirName.click ~= &dirName_click;
	}
	
	
	private void dirName_click(Object sender, EventArgs ea)
	{
		auto fbd = new FolderBrowserDialog;
		fbd.description = "Select a directory to list";
		string s = dirName.text;
		if(s.length && s[0] != '<')
			fbd.selectedPath = s;
		if(DialogResult.OK == fbd.showDialog(this))
		{
			dirName.text = "Loading...";
			dirName.enabled = false; // Disable changing the dir while it's loading one.
			dirView.beginUpdate();
			scope(exit)
			{
				dirName.enabled = true;
				dirView.endUpdate();
			}
			s = fbd.selectedPath;
			dirView.nodes.clear();
			int i = 0;
			listdir(s,
				(string fn)
				{
					if(++i == 10)
					{
						i = 0;
						Application.doEvents(); // Don't lock up the window.
					}
					dirView.nodes.add(fn);
					return true; // continue
				});
			dirName.text = s; // Note: the label might cut off some of the path.
		}
	}
	
	
	private void initializeDirList()
	{
		// Do not manually edit this block of code.
		//~Entice Designer 0.8 code begins here.
		//~DFL Form
		text = "Dir List";
		clientSize = dfl.drawing.Size(492, 466);
		//~DFL dfl.label.Label=dirName
		dirName = new dfl.label.Label();
		dirName.name = "dirName";
		dirName.dock = dfl.control.DockStyle.TOP;
		dirName.font = new dfl.drawing.Font("Courier New", 9f, dfl.drawing.FontStyle.REGULAR);
		dirName.text = "<Click here>";
		dirName.borderStyle = dfl.base.BorderStyle.FIXED_3D;
		dirName.textAlign = dfl.base.ContentAlignment.MIDDLE_LEFT;
		dirName.bounds = dfl.drawing.Rect(0, 0, 492, 23);
		dirName.parent = this;
		//~DFL dfl.treeview.TreeView=dirView
		dirView = new dfl.treeview.TreeView();
		dirView.name = "dirView";
		dirView.backColor = dfl.drawing.SystemColors.control;
		dirView.dock = dfl.control.DockStyle.FILL;
		dirView.borderStyle = dfl.base.BorderStyle.NONE;
		dirView.bounds = dfl.drawing.Rect(0, 23, 492, 443);
		dirView.parent = this;
		//~Entice Designer 0.8 code ends here.
	}
}


int main()
{
	int result = 0;
	
	try
	{
		Application.enableVisualStyles();
		
		Application.run(new DirList());
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

