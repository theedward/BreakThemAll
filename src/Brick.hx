package ;

import openfl.display.Sprite;
import openfl.media.Sound;
import openfl.Assets;

enum BrickTypes {
	Normal;
	Strong;
	Stronger;
}

class Brick extends Sprite
{

	private var type:BrickType;
	private var xMapIndex:Int;
	private var yMapIndex:Int;
	private var brickLength:Int = 30;
	private var brickWidth:Int = 20;
	private var poweredUp:Bool = false;
	private var powerUp:PowerUp;
	private var collisionSound:Sound = Assets.getMusic("audio/explosion.wav");
	
	public function new(type:BrickTypes, x:Int, y:Int)
	{
		super();
		switch(type) {
			case Normal:
				this.type = new BrickType(BrickType.NORMALVALUE, BrickType.NORMALDURABILITY, BrickType.NORMALCOLOR);
			case Strong:
				this.type = new BrickType(BrickType.STRONGVALUE, BrickType.STRONGDURABILITY, BrickType.STRONGCOLOR);
			case Stronger:
				this.type = new BrickType(BrickType.STRONGERVALUE, BrickType.STRONGERDURABILITY, BrickType.STRONGERCOLOR);
			default:
				//Do Nothing
		}
		
		this.xMapIndex = x * brickLength;
		this.yMapIndex = y * brickWidth;
		
		//Will it have a powerup behind?
		if (Math.random() <= 0.1) {
			//Create a powerup behind (let's see which one)
			this.powerUp = createPowerUp();
			if (this.powerUp != null) {
				this.poweredUp = true;
			}
		}
				
		this.graphics.beginFill(this.type.getColor());
		this.graphics.drawRect(xMapIndex, yMapIndex, brickLength - 1, brickWidth - 1);
		this.graphics.endFill();
	}
	
	private function createPowerUp():PowerUp {
		var whichPowerUp:Float = Math.random();
		var powerUp:PowerUp;
		
		if (whichPowerUp <= 0.5 ) {
			//Bigger Paddle
			powerUp = new PowerUp(PowerUp.BIGGERPADDLE);
		} else {
			//Faster Paddle
			powerUp = new PowerUp(PowerUp.FASTERPADDLE);
		}
		
		return powerUp;
	}
	
	public function collidedWithMe(ballX:Float, ballY:Float):Bool {
		if ((ballX >= (xMapIndex) && ballX <= ((xMapIndex) + brickLength)) && (ballY >= (yMapIndex) && ballY <= ((yMapIndex) + brickWidth))) {
			return true;
		}
		
		return false;
	}
	
	public function getXMapIndex():Int {
		return this.xMapIndex;
	}
	
	public function getYMapIndex():Int {
		return this.yMapIndex;
	}
	
	public function getBrickType():BrickType {
		return this.type;
	}
	
	public function playCollisionSound():Void {
		this.collisionSound.play();
	}
	
	public function setBrickType(brickType:BrickType) {
		this.type = brickType;
		
		this.graphics.clear();
		this.graphics.beginFill(this.type.getColor());
		this.graphics.drawRect(xMapIndex, yMapIndex, brickLength - 1, brickWidth - 1);
		this.graphics.endFill();
	}
	
	public function hasPowerUp():Bool {
		return this.poweredUp;
	}
	
	public function getPowerUp():PowerUp {
		return this.powerUp;
	}
}
