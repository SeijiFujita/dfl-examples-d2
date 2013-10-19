// To compile:
// 	dfl tray tray.res -gui

private import dfl.all;

//private import dfl.internal.winapi;


//const char* IDI_ICON1 = cast(char*)101;
const int ID_ICON = 101;


class TrayForm: Form
{
	NotifyIcon ni;
	
	
	this()
	{
		text = "DFL tray icon test.";
		//icon = new Icon(LoadIconA(GetModuleHandleA(null), IDI_ICON1));
		icon = Application.resources.getIcon(ID_ICON);
		
		with(new Button)
		{
			text = "&Hide";
			bounds = Rect(8, 8, 74, 54);
			parent = this;
			
			click ~= &hideBtn_click;
		}
		
		ContextMenu cm;
		MenuItem mpop, mi;
		
		cm = new ContextMenu;
		
		with(mpop = new MenuItem)
		{
			text = "&Action";
		}
		cm.menuItems.add(mpop);
		
		with(mi = new MenuItem)
		{
			text = "&Show Form";
			defaultItem = true;
			click ~= &actionShowFormMenu_click;
		}
		mpop.menuItems.add(mi);
		
		with(mi = new MenuItem)
		{
			text = "&Hide Icon";
			mi.click ~= &actionHideIconMenu_click;
		}
		mpop.menuItems.add(mi);
		
		with(mi = new MenuItem)
		{
			text = "-"; // Separator.
		}
		cm.menuItems.add(mi);
		
		with(mi = new MenuItem)
		{
			text = "E&xit";
			click ~= &exitMenu_click;
		}
		cm.menuItems.add(mi);
		
		with(ni = new NotifyIcon)
		{
			text = this.text;
			icon = this.icon;
			contextMenu = cm;
			visible = true;
			doubleClick ~= &actionShowFormMenu_click;
		}
		
		closed ~= &form_closed;
	}
	
	
	private void form_closed(Object sender, EventArgs ea)
	{
		// Need to explicitly exit since I didn't specify a form in Application.run().
		Application.exitThread();
	}
	
	
	private void hideBtn_click(Object sender, EventArgs ea)
	{
		// Fun.
		//(cast(Button)sender).image = this.icon;
		with((cast(Button)sender))
		{
			text = null;
			image = this.icon;
		}
		
		//this.hide();
		ni.minimize(this);
		ni.visible = true;
	}
	
	
	private void actionShowFormMenu_click(Object sender, EventArgs ea)
	{
		//this.show();
		ni.restore(this);
	}
	
	
	private void actionHideIconMenu_click(Object sender, EventArgs ea)
	{
		this.show();
		ni.visible = false;
	}
	
	
	private void exitMenu_click(Object sender, EventArgs ea)
	{
		Application.exitThread();
	}
}


int main()
{
	int result;
	
	try
	{
		(new TrayForm).createControl(); // But don't show.
		Application.run(); // Not using Application.run(form) because it will show the form. See form_closed above.
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

