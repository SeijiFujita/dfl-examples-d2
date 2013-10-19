// To compile:
// 	dfl listbox -gui


// Note: DFL code should not be written this way. This is only a test. See other examples for better guidelines.


private import dfl.all, dfl.internal.winapi;


int main()
{
	Form f;
	
	with(f = new Form)
	{
		text = "DFL List Box Example";
		f.backColor = Color(0x22, 0x55, 0xBB);
	}
	
	ListBox lbox;
	with(lbox = new ListBox)
	{
		itemHeight = 36;
		font = new Font("Arial", cast(float)9, FontStyle.ITALIC);
		drawMode = DrawMode.OWNER_DRAW_FIXED;
		drawItem ~= delegate(Object sender, DrawItemEventArgs ea)
		{
			ea.drawBackground();
			ea.graphics.drawIcon(f.icon, ea.bounds.x + 2, ea.bounds.y + 2);
			ea.graphics.drawText(items[ea.index].toString(), ea.font, ea.foreColor,
				Rect(ea.bounds.x + 36, ea.bounds.y + 10, ea.bounds.width - 36, 13));
			ea.drawFocusRectangle();
		};
		
		//text = "bar";
		width = 160;
		dock = DockStyle.LEFT;
		parent = f;
		lbox.backColor = Color(0x60, 0x40, 0x88);
		lbox.foreColor = Color(0xFF, 0xFF, 0xFF);
		integralHeight = false;
		//scrollAlwaysVisible = true;
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
		//selectionMode = SelectionMode.MULTI_SIMPLE;
		assert(useTabStops);
		
		selectedValueChanged ~= delegate(Object sender, EventArgs ea)
		{
			switch(selectedValue.toString())
			{
				case "+":
					f.opacity = f.opacity + 0.1;
					break;
				
				case "-":
					f.opacity = f.opacity - 0.1;
					if(f.opacity < 0.1)
						f.opacity = 1;
					break;
				
				default: ;
			}
		};
	}
	
	with(new ListBox)
	{
		integralHeight = false;
		dock = DockStyle.RIGHT;
		
		items.add("One");
		items.add("Two");
		items.add("Three");
		
		parent = f;
	}
	
	Application.run(f);
	return 0;
}

