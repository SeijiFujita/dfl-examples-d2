// Written by Christopher E. Miller
// This code is public domain.

// To compile:
// 	dfl draw -gui


private import dfl.all;


class DrawForm: Form
{
	this()
	{
		text = "Draw!";
		backColor = Color(0, 0, 0);
	}
	
	
	protected override void onPaint(PaintEventArgs ea)
	{
		super.onPaint(ea);
		
		// Ideally you wouldn't want to create so many brushes and pens in each paint event.
		
		ea.graphics.drawText("&Hello\tTab1\tTab2aaa\tTab3\r\nWorld", font, Color(38, 153, 84), Rect(0, 0, 250, 20));
		
		// Fill in a 1x1 rectangle using the Brush function and the Color function; white background.
		scope Brush b1 = new SolidBrush(Color(0xFF, 0xFF, 0xFF));
		ea.graphics.fillRectangle(b1, 5, 60, 1, 1); // Brush version.
		ea.graphics.fillRectangle(Color(0xFF, 0xFF, 0xFF), 5, 66, 1, 1); // Color version.
		
		// Again with a bigger area and red background.
		scope Brush b2 = new SolidBrush(Color(0xFF, 0, 0));
		ea.graphics.fillRectangle(b2, 5, 100, 4, 4); // Brush version.
		ea.graphics.fillRectangle(Color(0xFF, 0, 0), 5, 110, 4, 4); // Color version.
		
		// Simple green lines next to the red rectangles.
		scope Pen p1 = new Pen(Color(0, 0xFF, 0));
		ea.graphics.drawLine(p1, 10, 100, 14, 104);
		ea.graphics.drawLine(p1, 10, 110, 14, 114);
		
		// Multiple green lines chained together.
//		static Point[] pts1 = [{x: 2, y: 150}, {x: 20, y: 157}, {x: 3, y: 168}, {x: 7, y: 200}, {x: 2, y: 213}];
		static Point[5] pts1;
		pts1[0] = Point( 2, 150);
		pts1[1] = Point(20, 157);
		pts1[2] = Point( 3, 168);
		pts1[3] = Point( 7, 200);
		pts1[4] = Point( 2, 213);
		ea.graphics.drawLines(p1, pts1);
		
		// Yellow arc.
		scope Pen p2 = new Pen(Color(0xFF, 0xFF, 0));
		ea.graphics.drawArc(p2, 1, 220, 7, 30, 4, 210, 7, 230);
		
		// Yellow bezier with 2 width.
		scope Pen p3 = new Pen(Color(0xFF, 0xFF, 0), 2);
		ea.graphics.drawBezier(p3, Point(20, 60), Point(25, 40), Point(45, 50), Point(55, 70));
		
		// Multiple blue beziers chained together using dashes.
//		static Point[] pts2 = [{x: 17, y: 100}, {x: 80, y: 150}, {x: 160, y: 30}, {x: 90, y: 220},
//			{x: 30, y: 20}, {x: 80, y: 70}, {x: 50, y: 50}];
		static Point[7] pts2;
		pts2[0] = Point(17, 100);
		pts2[1] = Point(80, 150);
		pts2[2] = Point(160, 30);
		pts2[3] = Point(90, 220);
		pts2[4] = Point(30,  20);
		pts2[5] = Point(80,  70);
		pts2[6] = Point(50,  50);

		scope Pen p4 = new Pen(Color(0, 0, 0xFF), 1, PenStyle.DASH);
		ea.graphics.drawBeziers(p4, pts2);
		
		// Blue ellipse using dashes.
		ea.graphics.drawEllipse(p4, 30, 220, 40, 40);
		
		// Blue rectangle using dashes.
		ea.graphics.drawRectangle(p4, 40, 160, 60, 30);
		
		// Yellow ellipse.
		scope Pen p5 = new Pen(Color(0xFF, 0xFF, 0), 1);
		ea.graphics.drawEllipse(p5, 55, 45, 20, 20);
		
		// Bigger red ellipse surrounding the yellow one.
		scope Pen p6 = new Pen(Color(0xFF, 0, 0), 1);
		ea.graphics.drawEllipse(p6, 50, 40, 30, 30);
	}
}


int main()
{
	int result = 0;
	
	try
	{
		Application.run(new DrawForm);
	}
	catch(DflThrowable o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	
	return result;
}

