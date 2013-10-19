// To compile:
// 	dfl -gui dirlistview


import dfl.all;

import dfl.internal.winapi;
import dfl.internal.utf;

version(Tango)
{
	private import tango.io.FilePath, tango.io.FileSystem;
}
else
{
	import std.file, std.path, std.string;
}


class FileItem: ListViewItem
{
	string fullPath;
}


class DirListViewForm: dfl.form.Form
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	dfl.listview.ListView dirview;
	//~Entice Designer variables end here.
	
	
	this()
	{
		initializeDirListViewForm();
		
		//@  Other DirListViewForm initialization code here.
		
		dirview.sorting = SortOrder.ASCENDING;
		
		load ~= &form_load;
		
		dirview.doubleClick ~= &dirview_doubleClick;
	}
	
	
	private void dirview_doubleClick(Object sender, EventArgs ea)
	{
		if(dirview.selectedItems.length)
		{
			auto fitem = cast(FileItem)dirview.selectedItems[0];
			if(fitem)
			{
				//msgBox(fitem.fullPath, fitem.text);
				ShellExecuteA(handle, "open",
					toAnsiz(`"` ~ fitem.fullPath ~ `"`), null,
					null, SW_SHOWNORMAL); // Note: not Unicode-safe.
			}
		}
	}
	
	
	private void form_load(Object sender, EventArgs ea)
	{
		auto il = new ImageList();
		il.imageSize = Size(32, 32);
		il.colorDepth = ColorDepth.DEPTH_32BIT;
		
		auto ires = new Resources("shell32.dll");
		
		il.images.add(ires.getIcon(3)); // exe
		il.images.add(ires.getIcon(1)); //152; // any
		il.images.add(ires.getIcon(154)); // system
		il.images.add(ires.getIcon(4)); // dir
		
		dirview.largeImageList = il;
		
		
		void addFile(string name, string fullPath, bool isdir)
		{
			auto lvi = new FileItem();
			lvi.fullPath = fullPath;
			lvi.text = name;
			if(isdir)
			{
				lvi.imageIndex = 3;
			}
			else
			{
				string ext;
				version(Tango)
				{
					scope fp = new FilePath(fullPath);
					ext = fp.ext;
				}
				else
				{
					ext = getExt(name);
				}
				switch(ext)
				{
					case "exe":
					case "bat":
						lvi.imageIndex = 0;
						break;
						
					case "dll":
					case "ini":
						lvi.imageIndex = 2;
						break;
					
					default:
						lvi.imageIndex = 1;
				}
			}
			dirview.items.add(lvi);
		}
		
		
		version(Tango)
		{
			scope fp = new FilePath(FileSystem.getDirectory());
			fp.toList(
				(FilePath fp, bool dir)
				{
					addFile(fp.file, fp.toString(), dir);
					return true; // Continue.
				});
		}
		else
		{
			listdir(getcwd(),
				(DirEntry* de)
				{
					addFile(getBaseName(de.name), de.name, de.isdir() != 0);
					return true; // Continue.
				});
		}
	}
	
	
	private void initializeDirListViewForm()
	{
		// Do not manually modify this function.
		//~Entice Designer 0.8.5pre2 code begins here.
		//~DFL Form
		startPosition = dfl.all.FormStartPosition.WINDOWS_DEFAULT_BOUNDS;
		text = "Dir List View Form";
		clientSize = dfl.all.Size(292, 266);
		//~DFL dfl.listview.ListView=dirview
		dirview = new dfl.listview.ListView();
		dirview.name = "dirview";
		dirview.dock = dfl.all.DockStyle.FILL;
		dirview.multiSelect = false;
		dirview.bounds = dfl.all.Rect(0, 0, 292, 266);
		dirview.parent = this;
		//~Entice Designer 0.8.5pre2 code ends here.
	}
}


int main()
{
	int result = 0;
	
	try
	{
		Application.enableVisualStyles();
		
		//@  Other application initialization code here.
		
		Application.run(new DirListViewForm());
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

