// Written by Christopher E. Miller
// This code is public domain.

// To compile:
// 	dfl drop -gui


private import dfl.all, dfl.internal.utf;


class MainForm: Form
{
	this()
	{
		text = "Dragon Drop!";
		
		Label label;
		with(label = new Label)
		{
			height = 60;
			dock = DockStyle.TOP;
			useMnemonic = false;
			borderStyle = BorderStyle.FIXED_3D;
			label.text = "Drag this text and drop it onto the text box below."
				"\r\n\r\nYou can also drag the text back!";
			
			allowDrop = true; // Enable stuff to be dropped on the label.
			
			parent = this;
			
			mouseDown ~= &label_mouseDown; // Prepares text to be dropped on a drop target.
			
			dragOver ~= &label_dragOver; // Checks if the data can be dropped on the label.
			dragDrop ~= &label_dragDrop; // Handles when the data is dropped.
		}
		
		with(new RichTextBox)
		{
			dock = DockStyle.FILL;
			
			parent = this;
		}
	}
	
	
	private void label_mouseDown(Object sender, MouseEventArgs ea)
	{
		// Start the drag procedure.
		// Cast the string to ubyte[] so that it is treated as ANSI instead of UTF-8.
		// If the text was not all ASCII you could use cast(ubyte[])dfl.internal.utf.toAnsi(foo).
		// Future versions of DFL will do automatic conversions.
		this.doDragDrop(Data(cast(ubyte[])"hello world!"), DragDropEffects.COPY);
	}
	
	
	private void label_dragOver(Object sender, DragEventArgs ea)
	{
		// Check if the currently dragging data supports text.
		if(ea.data.getDataPresent(DataFormats.text))
		{
			// Set the drag effect to copy if it's allowed.
			// This will remove the NO cursor and indicate you can drop.
			ea.effect = ea.allowedEffect & DragDropEffects.COPY;
		}
	}
	
	
	private void label_dragDrop(Object sender, DragEventArgs ea)
	{
		// Check if the currently dropped data supports text.
		if(ea.data.getDataPresent(DataFormats.text))
		{
			ubyte[] text;
			text = ea.data.getData(DataFormats.text).getText(); // Get the data as text.
			
			// The text is ANSI so make sure it's all ASCII before treating
			// it as UTF-8, or use fromAnsi() from dfl.internal.utf.
			// Future versions of DFL will do automatic conversions.
			string str;
			str = fromAnsi(cast(char*)text, text.length);
			
			(cast(Label)(sender)).text = str;
		}
	}
}


int main()
{
	int result = 0;
	
	try
	{
		Application.autoCollect = false;
		
		Application.run(new MainForm);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

