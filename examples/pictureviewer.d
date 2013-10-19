// To compile:
// 	dfl pictureviewer -gui


// Note: see http://wiki.dprogramming.com/DflDoc/PictureFormats for supported image formats.


private import core.memory;

private import dfl.all;


class PictureForm: Form
{
	PictureBox pic;
	
	this()
	{
		startPosition = FormStartPosition.WINDOWS_DEFAULT_BOUNDS;
		text = "DFL Picture Viewer";
		backColor = SystemColors.appWorkspace;
		
		with(pic = new PictureBox)
		{
			sizeMode = PictureBoxSizeMode.AUTO_SIZE;
			parent = this;
		}
		
		menu = new MainMenu;
		MenuItem mpop, mi;
		
		with(mpop = new MenuItem)
		{
			text = "&File";
			index = 0;
			menu.menuItems.add(mpop);
		}
		
		with(mi = new MenuItem)
		{
			text = "&Open...\tCtrl+O";
			index = 0;
			mpop.menuItems.add(mi);
			
			click ~= &file_open_click;
		}
		addShortcut(Keys.CONTROL | Keys.O, &shortcut_open);
		
		with(mi = new MenuItem)
		{
			text = "-";
			index = 1;
			mpop.menuItems.add(mi);
		}
		
		with(mi = new MenuItem)
		{
			text = "E&xit";
			index = 2;
			mpop.menuItems.add(mi);
			
			click ~= &file_exit_click;
		}
	}
	
	
	final void doOpen()
	{
		OpenFileDialog ofd;
		ofd = new typeof(ofd);
		ofd.title = "Open Image";
		//ofd.filter = "Bitmap Files (*.bmp)|*.bmp|All Files|*.*";
		ofd.filter = "All Image Files|*.bmp;*.ico;*.gif;*.jpg;*.jpeg|Bitmap Files|*.bmp|Icon Files|*.ico|JPEG Files|*.jpg;*.jpeg|All Files|*.*";
		
		if(DialogResult.OK == ofd.showDialog())
		{
			//pic.image = new Bitmap(ofd.fileName);
			pic.image = new Picture(ofd.fileName);
			
			GC.collect(); // Clean up old resources.
		}
	}
	
	
	private void file_open_click(Object sender, EventArgs ea)
	{
		doOpen();
	}
	
	
	private void shortcut_open(Object sender, FormShortcutEventArgs ea)
	{
		doOpen();
	}
	
	
	private void file_exit_click(Object sender, EventArgs ea)
	{
		Application.exitThread();
	}
}


int main()
{
	int result = 0;
	
	try
	{
		// Application initialization code here.
		
		Application.run(new PictureForm);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

