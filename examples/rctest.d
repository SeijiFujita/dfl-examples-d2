// To compile:
// 	dfl rctest rctest.res -gui


import dfl.all;


class ResourceTest: dfl.form.Form
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	dfl.picturebox.PictureBox pictureBox1;
	dfl.picturebox.PictureBox pictureBox2;
	dfl.label.Label label1;
	//~Entice Designer variables end here.
	
	
	this()
	{
		initializeResourceTest();
		
		pictureBox1.image = Application.resources.getIcon(101);
		pictureBox2.image = Application.resources.getBitmap("mspaint");
		label1.text = Application.resources.getString(3001);
	}
	
	
	private void initializeResourceTest()
	{
		// Do not manually edit this block of code.
		//~Entice Designer 0.7.2 code begins here.
		//~DFL Form
		text = "Resource Test";
		clientSize = dfl.drawing.Size(296, 452);
		//~DFL dfl.picturebox.PictureBox=pictureBox1
		pictureBox1 = new dfl.picturebox.PictureBox();
		pictureBox1.name = "pictureBox1";
		pictureBox1.bounds = dfl.drawing.Rect(24, 16, 256, 128);
		pictureBox1.parent = this;
		//~DFL dfl.picturebox.PictureBox=pictureBox2
		pictureBox2 = new dfl.picturebox.PictureBox();
		pictureBox2.name = "pictureBox2";
		pictureBox2.bounds = dfl.drawing.Rect(24, 168, 256, 128);
		pictureBox2.parent = this;
		//~DFL dfl.label.Label=label1
		label1 = new dfl.label.Label();
		label1.name = "label1";
		label1.bounds = dfl.drawing.Rect(16, 312, 260, 128);
		label1.parent = this;
		//~Entice Designer 0.7.2 code ends here.
	}
}


int main()
{
	int result = 0;
	
	try
	{
		// Application initialization code here.
		
		Application.run(new ResourceTest());
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

