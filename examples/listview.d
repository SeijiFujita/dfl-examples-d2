// Written by Christopher E. Miller
// This code is public domain.

// To compile:
// 	dfl listview -gui


private import std.string, std.conv;

private import dfl.all;


class MainForm: Form
{
	ListView lview;
	
	
	this()
	{
		text = "DFL ListView";
		dockPadding.all = 20;
		
		with(lview = new ListView)
		{
			dock = DockStyle.FILL;
			font = new Font("Courier New", 10f);
			backColor = Color(0xD1, 0xD1, 0xD1);
			foreColor = Color.fromRgb(cast(int)0);
			sorting = SortOrder.ASCENDING;
			view = View.DETAILS;
			fullRowSelect = true;
			gridLines = true;
			
			items.add("foo");
			items[0].subItems.add("subfoo");
			items[0].subItems.add("lastfoo");
			items.add("bar");
			items.add("cool");
			
			
			ColumnHeader col;
			
			with(col = new ColumnHeader)
			{
				col.text = "One";
				width = 50;
			}
			columns.add(col);
			
			with(col = new ColumnHeader)
			{
				col.text = "Next  :\u00FE";
				width = 180;
			}
			columns.add(col);
			
			static string[] FFFF = ["fe", "fi", "fo", "fum"];
			addRow(FFFF);
			
			parent = this;
			
			labelEdit = true;
			afterLabelEdit ~= &lview_afterLabelEdit;
		}
		
		click ~= &form_click;
	}
	
	
	private void lview_afterLabelEdit(Object sender, LabelEditEventArgs ea)
	{
		if(DialogResult.YES != msgBox(this, `"` ~ ea.label ~ `"?`, "Edit label?", MsgBoxButtons.YES_NO, MsgBoxIcon.QUESTION))
			ea.cancelEdit = true;
	}
	
	
	private void form_click(Object sender, EventArgs ea)
	{
		msgBox("There are " ~ std.conv.to!string(lview.selectedItems.length) ~ " selected items."
			"\r\nThere are " ~ std.conv.to!string(lview.selectedIndices.length) ~ " selected indices."
			"\r\nFocused index: " ~ std.conv.to!string(lview.focusedIndex) ~ ".",
			text, MsgBoxButtons.OK, MsgBoxIcon.INFORMATION);
	}
}


int main()
{
	int result = 0;
	
	try
	{
		// Application initialization code here.
		
		Application.run(new MainForm);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

