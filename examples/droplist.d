// Written by Christopher E. Miller
// This code is public domain.

// To compile:
// 	dfl droplist -gui


// Note: you can even open two instances and drop items between them.


private import dfl.all;


class DropListBox: ListBox
{
	this()
	{
		allowDrop = true;
		drawMode = DrawMode.OWNER_DRAW_FIXED;
		itemHeight = 22;
		
		itemTextFormat = new TextFormat(TextFormatFlags.NO_PREFIX | TextFormatFlags.SINGLE_LINE);
		itemTextFormat.alignment = TextAlignment.LEFT | TextAlignment.MIDDLE;
	}
	
	
	protected override void onMouseDown(MouseEventArgs ea)
	{
		super.onMouseDown(ea);
		
		if(ea.button & MouseButtons.LEFT)
		{
			// See if the list item under the cursor is selected.
			int selindex;
			selindex = indexFromPoint(ea.x, ea.y);
			if(-1 != selindex && getSelected(selindex))
			{
				// Make a DataObject and add the selected item's text.
				DataObject dobj;
				dobj = new DataObject;
				dobj.setData(DataFormats.utf8, Data(items[selindex].toString()));
				
				// Now start the drag operation!
				// Using the move effect to indicate the list item will be moved instead of just copied.
				// Also using the copy affect so that if the target is only using the text, the list item will remain.
				DragDropEffects dropresult = DragDropEffects.NONE;
				try
				{
					this.movedIndex = int.max; // Reset.
					dropresult = doDragDrop(dobj, DragDropEffects.MOVE | DragDropEffects.COPY);
				}
				catch
				{
					// Wordpad pretends it can handle this format then reports an error.. ignore it.
				}
				
				// If the drop operation successfully moved, then remove that
				// item from the list box so that it's only in the new spot.
				if(DragDropEffects.MOVE & dropresult)
				{
					if(movedIndex <= selindex)
						selindex++; // Adjust index of moved item due to inserted item.
					
					items.removeAt(selindex);
				}
			}
		}
	}
	
	
	// -pt- is in client coordinates.
	// Returned index may be 1 beyond last index if inserting at end.
	private int getInsertionIndexFromPoint(Point pt)
	{
		int i;
		i = indexFromPoint(pt);
		if(-1 == i)
		{
			i = items.length; // End.
		}
		else
		{
			// Not past end so see if mouse is above or below the half way line
			// of the item to determine if it should be inserted above or below.
			Rect itrect;
			itrect = getItemRectangle(i);
			if(pt.y > itrect.y + itrect.height / 2)
				i++;
		}
		return i;
	}
	
	
	protected override void onDragOver(DragEventArgs ea)
	{
		super.onDragOver(ea);
		
		// Check if the currently dragging data supports utf8.
		if(ea.data.getDataPresent(DataFormats.utf8))
		{
			// Find the item under the cursor or assume the end if there's no item under it.
			// Need pointToClient() for ea.x and ea.y because they are screen coordinates.
			int i;
			i = getInsertionIndexFromPoint(pointToClient(Point(ea.x, ea.y)));
			if(i != dragOverIndex)
			{
				// If the insertion point changed, update the insertion marker.
				dragOverIndex = i;
				invalidate();
			}
			//else
			dragOverIndex = i;
			
			// Set the drag effect to move if it's allowed.
			// This will remove the NO cursor and indicate you can drop.
			ea.effect = ea.allowedEffect & DragDropEffects.MOVE;
		}
	}
	
	
	protected override void onDragLeave(EventArgs ea)
	{
		super.onDragLeave(ea);
		
		// Remove the insertion marker.
		dragOverIndex = int.max; // None.
		invalidate();
	}
	
	
	protected override void onDragDrop(DragEventArgs ea)
	{
		super.onDragDrop(ea);
		
		// Remove the insertion marker.
		dragOverIndex = int.max; // None.
		invalidate();
		
		// Check if the currently dropped data supports utf8.
		if(ea.data.getDataPresent(DataFormats.utf8))
		{
			string liststring;
			liststring = ea.data.getData(DataFormats.utf8).getString(); // Get the dropped data.
			
			// Find the item under the cursor or assume the end if there's no item under it.
			// Need pointToClient() for ea.x and ea.y because they are screen coordinates.
			int i;
			i = getInsertionIndexFromPoint(pointToClient(Point(ea.x, ea.y)));
			
			items.insert(i, liststring); // Insert it!
			selectedIndex = i; // Select this inserted item.
			movedIndex = i;
			
			ea.effect = ea.allowedEffect & DragDropEffects.MOVE; // Report to caller that it's moved.
		}
	}
	
	
	protected override void onDrawItem(DrawItemEventArgs ea)
	{
		ea.drawBackground();
		
		ea.graphics.drawText(items[ea.index].toString(), ea.font, ea.foreColor,
			Rect(ea.bounds.x + 4, ea.bounds.y, ea.bounds.width, ea.bounds.height), itemTextFormat);
		
		//ea.drawFocusRectangle();
		
		super.onDrawItem(ea);
	}
	
	
	// The insertion line will always be 4 px tall.
	final void drawInsertionLine(Graphics g, int x, int y, int width)
	{
		g.fillRectangle(SystemColors.control, x + 4, y, width - 4 - 4, 4);
	}
	
	
	protected override void onPaint(PaintEventArgs ea)
	{
		super.onPaint(ea);
		
		// Paint the insertion marker over top of the items.
		if(dragOverIndex == items.length)
		{
			// Inserting at end.
			if(items.length)
			{
				Rect lrect; // Bounding rect of last item.
				lrect = getItemRectangle(items.length - 1);
				drawInsertionLine(ea.graphics, 0, lrect.bottom - 2, clientSize.width);
			}
			else
			{
				// No items to account for, so just draw the insertion line at the top.
				drawInsertionLine(ea.graphics, 0, 0, clientSize.width);
			}
		}
		else if(dragOverIndex < items.length)
		{
			assert(dragOverIndex >= 0);
			// Inserting above dragOverIndex.
			
			Rect insrect; // Bounding rect of item.
			insrect = getItemRectangle(dragOverIndex);
			drawInsertionLine(ea.graphics, 0, insrect.y - 2, clientSize.width);
		}
	}
	
	
	private:
	
	// Insertion index if this is the target of a drop operation.
	// This is so that if the inserted item changes the index of the moved item, the new index can be calculated.
	int movedIndex;
	
	// Index the mouse is currently dragging to. Keeps track of the insertion marker.
	// Set to int.max if not dragging.
	// Note: this can be set to 1 past the last index.
	int dragOverIndex = int.max;
	
	TextFormat itemTextFormat;
}


class MainForm: Form
{
	DropListBox lbox;
	
	
	this()
	{
		initializeMainForm();
		
		with(lbox = new DropListBox)
		{
			integralHeight = false;
			dock = DockStyle.LEFT;
			width = 220;
			
			items.add("Bashful");
			items.add("Doc");
			items.add("Dopey");
			items.add("Grumpy");
			items.add("Happy");
			items.add("Sleepy");
			items.add("Sneezy");
			
			parent = this;
		}
	}
	
	
	private void initializeMainForm()
	{
		// Do not manually edit this block of code.
		//~DFL Designer 0.4 code begins here.
		
		//~DFL MainForm
		startPosition = FormStartPosition.CENTER_SCREEN;
		text = "Drop List";
		clientSize = dfl.drawing.Size(292, 273);
		
		//~DFL Designer 0.4 code ends here.
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

