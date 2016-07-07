package ;
import flash.geom.Point;
import openfl.display.Sprite;

class Ball extends Sprite
{
	private var ballMovement:Point;
	private var ballSpeed:Int;
	private var ballRadius:Float = 5;

	public function new()
	{
		super();

		this.graphics.beginFill(0xffffff);
		this.graphics.drawCircle(0, 0, ballRadius*2);
		this.graphics.endFill();
	}

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
