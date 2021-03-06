package ;
import flash.geom.Point;
import openfl.display.Sprite;

class Ball extends Sprite
{
	//CONSTANTS
	private var COLOR_WHITE:Int = 0xffffff;
	
	//VARIABLES
	private var ballMovement:Point;
	private var ballSpeed:Int;
	private var ballRadius:Float = 5;

	public function new()
	{
		super();

		this.graphics.beginFill(COLOR_WHITE);
		this.graphics.drawCircle(0, 0, ballRadius*2);
		this.graphics.endFill();
	}

	/* GETTERS & SETTERS */
	
	public function getBallMovement():Point {
		return this.ballMovement;
	}
	
	public function getBallSpeed():Int {
		return this.ballSpeed;
	}
	
	public function setBallMovement(ballMovement:Point) {
		this.ballMovement = ballMovement;
	}
	
	public function setBallMovementXandY(pointX:Float, pointY:Float) {
		this.ballMovement.x = pointX;
		this.ballMovement.y = pointY;
	}
	
	public function setBallSpeed(speed:Int){
		this.ballSpeed = speed;
	}
	
	public function getBallRadius():Float {
		return this.ballRadius;
	}

}
