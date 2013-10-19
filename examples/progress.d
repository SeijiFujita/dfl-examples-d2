// To compile:
// 	dfl progress -gui


import dfl.all;


class MainForm: Form
{
	Button btn;
	ProgressBar pbar;
	Timer tmr;
	
	
	this()
	{
		text = "DFL Progress Bar Example";
		
		with(pbar = new ProgressBar)
		{
			//value = 0;
			location = Point(8, 8);
			step = 4;
			parent = this;
		}
		
		with(btn = new Button)
		{
			location = Point(8, 100);
			text = "Start";
			click ~= &btn_click;
			parent = this;
		}
	}
	
	
	private void btn_click(Object sender, EventArgs ea)
	{
		if(tmr)
		{
			tmr.stop();
			tmr = null;
			if(pbar.value == pbar.maximum)
				pbar.value = pbar.minimum;
			btn.text = "Start";
		}
		else
		{
			tmr = new Timer;
			tmr.interval = 200;
			tmr.tick ~= &tmr_tick;
			tmr.start();
			btn.text = "Stop";
		}
	}
	
	
	private void tmr_tick(Object sender, EventArgs ea)
	{
		pbar.performStep();
		if(pbar.value == pbar.maximum)
		{
			tmr.stop();
			btn.text = "Done";
		}
	}
}


int main()
{
	int result = 0;
	
	try
	{
		Application.enableVisualStyles();
		
		Application.run(new MainForm);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

