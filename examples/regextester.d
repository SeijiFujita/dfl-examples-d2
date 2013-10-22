// Donated to DFL by lsina/ideage 2007-03-14

/*
	RegexTester  by ideage lsina@126.com 2007
*/

private import dfl.all;
//import std.regexp;
import std.regex;
import std.string;
//import std.math;
import std.format;

class RegexTester: dfl.form.Form
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	dfl.textbox.TextBox txRegex;
	dfl.textbox.TextBox txReplace;
	dfl.label.Label label1;
	dfl.label.Label label2;
	dfl.textbox.TextBox txSource;
	dfl.textbox.TextBox txMatches;
	dfl.label.Label label3;
	dfl.label.Label label4;
	dfl.button.Button btisMatch;
	dfl.button.Button btClear;
	dfl.button.Button btReplace;
	dfl.button.Button btSplit;
	dfl.button.Button btMatches;
	dfl.button.Button btGroup;
	dfl.button.CheckBox cbIC;
	dfl.button.CheckBox cbSL;
	dfl.button.CheckBox cbGM;
	dfl.button.Button button1;
	//~Entice Designer variables end here.
//	std.regexp.RegExp mregexp;

	this()
	{
		initializeRegexTester();

		// Other RegexTester initialization code here.
	}

	private void initializeRegexTester()
	{
		// Do not manually edit this block of code.
		//~Entice Designer 0.8.1 code begins here.
		//~DFL Form
		text = "D Language Phobos.std.regex Tester";
		clientSize = dfl.drawing.Size(632, 462);
		//~DFL dfl.textbox.TextBox=txRegex
		txRegex = new dfl.textbox.TextBox();
		txRegex.name = "txRegex";
		txRegex.multiline = true;
		txRegex.bounds = dfl.drawing.Rect(8, 16, 616, 64);
		txRegex.parent = this;
		//~DFL dfl.textbox.TextBox=txReplace
		txReplace = new dfl.textbox.TextBox();
		txReplace.name = "txReplace";
		txReplace.multiline = true;
		txReplace.bounds = dfl.drawing.Rect(8, 224, 616, 56);
		txReplace.parent = this;
		//~DFL dfl.label.Label=label1
		label1 = new dfl.label.Label();
		label1.name = "label1";
		label1.text = "Replace";
		label1.bounds = dfl.drawing.Rect(10, 208, 120, 16);
		label1.parent = this;
		//~DFL dfl.label.Label=label2
		label2 = new dfl.label.Label();
		label2.name = "label2";
		label2.text = "Regex";
		label2.bounds = dfl.drawing.Rect(9, 0, 120, 16);
		label2.parent = this;
		//~DFL dfl.textbox.TextBox=txSource
		txSource = new dfl.textbox.TextBox();
		txSource.name = "txSource";
		txSource.multiline = true;
		txSource.bounds = dfl.drawing.Rect(8, 136, 616, 64);
		txSource.parent = this;
		//~DFL dfl.textbox.TextBox=txMatches
		txMatches = new dfl.textbox.TextBox();
		txMatches.name = "txMatches";
		txMatches.multiline = true;
		txMatches.bounds = dfl.drawing.Rect(8, 306, 616, 112);
		txMatches.parent = this;
		//~DFL dfl.label.Label=label3
		label3 = new dfl.label.Label();
		label3.name = "label3";
		label3.text = "Source";
		label3.bounds = dfl.drawing.Rect(10, 118, 88, 16);
		label3.parent = this;
		//~DFL dfl.label.Label=label4
		label4 = new dfl.label.Label();
		label4.name = "label4";
		label4.text = "Matches";
		label4.bounds = dfl.drawing.Rect(8, 285, 96, 24);
		label4.parent = this;
		//~DFL dfl.button.Button=btisMatch
		btisMatch = new dfl.button.Button();
		btisMatch.name = "btisMatch";
		btisMatch.text = "isMatch";
		btisMatch.bounds = dfl.drawing.Rect(8, 424, 88, 24);
		btisMatch.parent = this;
		//~DFL dfl.button.Button=btClear
		btClear = new dfl.button.Button();
		btClear.name = "btClear";
		btClear.text = "Clear";
		btClear.bounds = dfl.drawing.Rect(448, 424, 88, 24);
		btClear.parent = this;
		//~DFL dfl.button.Button=btReplace
		btReplace = new dfl.button.Button();
		btReplace.name = "btReplace";
		btReplace.text = "Replace";
		btReplace.bounds = dfl.drawing.Rect(96, 424, 88, 24);
		btReplace.parent = this;
		//~DFL dfl.button.Button=btSplit
		btSplit = new dfl.button.Button();
		btSplit.name = "btSplit";
		btSplit.text = "Split";
		btSplit.bounds = dfl.drawing.Rect(184, 424, 88, 24);
		btSplit.parent = this;
		//~DFL dfl.button.Button=btMatches
		btMatches = new dfl.button.Button();
		btMatches.name = "btMatches";
		btMatches.text = "Matches";
		btMatches.bounds = dfl.drawing.Rect(272, 424, 88, 24);
		btMatches.parent = this;
		//~DFL dfl.button.Button=btGroup
//		btGroup = new dfl.button.Button();
//		btGroup.name = "btGroup";
//		btGroup.text = "Groups";
//		btGroup.bounds = dfl.drawing.Rect(360, 424, 88, 24);
//		btGroup.parent = this;
		//~DFL dfl.button.CheckBox=cbIC
		cbIC = new dfl.button.CheckBox();
		cbIC.name = "cbIC";
		cbIC.text = "IgnoreCase";
		cbIC.bounds = dfl.drawing.Rect(16, 88, 104, 16);
		cbIC.parent = this;
		//~DFL dfl.button.CheckBox=cbSL
		cbSL = new dfl.button.CheckBox();
		cbSL.name = "cbSL";
		cbSL.text = "SingleLine";
		cbSL.bounds = dfl.drawing.Rect(128, 88, 72, 16);
		cbSL.parent = this;
		//~DFL dfl.button.CheckBox=cbGM
		cbGM = new dfl.button.CheckBox();
		cbGM.name = "cbGM";
		cbGM.text = "Global Match";
		cbGM.bounds = dfl.drawing.Rect(224, 88, 96, 16);
		cbGM.parent = this;
		//~DFL dfl.button.Button=button1
		button1 = new dfl.button.Button();
		button1.name = "button1";
		button1.text = "Close";
		button1.bounds = dfl.drawing.Rect(536, 424, 88, 24);
		button1.parent = this;
		//~Entice Designer 0.8.1 code ends here.
		btisMatch.click ~= &btisMatch_click ;
		btClear.click ~= &btClear_click ;
		btReplace.click ~= &btReplace_click ;
		btSplit.click ~= &btSplit_click ;
		btMatches.click ~= &btMatches_click ;
		button1.click ~= &button1_click;
		cbSL.checked = true;
	}

	string regAttribute()
	{
		char[] attrib = null;
		if(cbGM.checked) attrib ~="g";
		if(cbSL.checked) attrib ~="m";
		if(cbIC.checked) attrib ~="i";
		return cast(string)attrib;
	}

	private void btisMatch_click(Object sender, EventArgs ea)
	{
/++
		string sur = strip(txRegex.text);
//		RegExp r =  new RegExp(sur,regAttribute());

		if( cast(bool)r.test(strip(txSource.text)))
			txMatches.text="Match!!";
		else
			txMatches.text="NOT FOUND!!";
++/
		string sur = strip(txRegex.text);
		auto m = match(txSource.text, regex(sur, regAttribute()));
		auto c = m.captures;
		if (c.empty())
			txMatches.text="NOT FOUND!!";
		else
			txMatches.text="Match!!";
	}

	private void btReplace_click(Object sender, EventArgs ea)
	{
/++
    string sur = strip(txRegex.text);
		RegExp r =  new RegExp(sur,regAttribute());
		this.txMatches.text =r.replace(txSource.text,txReplace.text);
++/
	    string sur = strip(txRegex.text);
		auto r = regex(sur, regAttribute());
		this.txMatches.text = replace(txSource.text, r, txReplace.text);
	}

	private void btSplit_click(Object sender, EventArgs ea)
	{
/++
		string sur = strip(txRegex.text);
		RegExp r =  new RegExp(sur,regAttribute());
		string[] s = r.split(txSource.text);
		char[] a = null;
		foreach(v ; s)
		{
			a ~= v;
			a ~= std.string.newline ;
		}
		this.txMatches.text = cast(string)a;
++/
		string sur = strip(txRegex.text);
		string[] s = split(txSource.text, regex(sur, regAttribute()));
		char[] a = null;
		foreach(v ; s) {
			a ~= v;
			a ~= "\r\n";
		}
		this.txMatches.text = cast(string)a;
	}

	private void btMatches_click(Object sender, EventArgs ea)
	{
/++		
		string sur = strip(txRegex.text);
		RegExp r =  new RegExp(sur,regAttribute());
		string[] s = r.match(txSource.text);
		char[] a = null;
		foreach(v ; s)
		{
			a ~= v;
			a ~= std.string.newline ;
		}
		this.txMatches.text = cast(string)a;
++/
		string sur = strip(txRegex.text);
		auto m = match(txSource.text, regex(sur, regAttribute()));
		auto c = m.captures;
		string s;
		s = format(".pre='%s'\r\n", c.pre);
		s ~= format(".post='%s'\r\n", c.post);
		s ~= format(".hit='%s'\r\n", c.hit);
		s ~= format(".front='%s'\r\n", c.front);
		s ~= format(".back='%s'\r\n", c.back);
		s ~= format(".empty='%s'\r\n", c.empty ? "ture" : "false");
		s ~= cast(string) format(".length=%d", c.length);
		txMatches.text = s;
	}

	private void btGroups_click(Object sender, EventArgs ea)
	{
		//char[] sub(char[] string, char[] pattern, char[] format, char[] attributes = null);
//		txMatches.text = sub(txSource.text ,txRegex.text ,txReplace.text ,regAttribute() );
	}

	private void btClear_click(Object sender, EventArgs ea)
	{
		txRegex.text ="";
/++
		txSource.text = "";
		txReplace.text = "\u4e00";
		txMatches.text = "\u9fa5";
++/
		txReplace.text = "";
		txMatches.text = "";
	}
	private void button1_click(Object sender, EventArgs ea)
	{
		Application.exitThread();
	}

}

int main()
{
	int result = 0;

	try
	{
		Application.enableVisualStyles();
		Application.run(new RegexTester());
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);

		result = 1;
	}

	return result;
}

