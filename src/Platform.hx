package ;
import openfl.display.Sprite;
import openfl.media.Sound;
import openfl.Assets;

class Platform extends Sprite
{
	//CONSTANTS
	//Copy from Main.hx
	private var COLOR_ORANGE:Int = 0xffad33;
	
	//VARIABLES
	private var platformSpeed:Int;
	private var platformLength:Float = 100;
	private var platformWidth:Int = 15;
	private var platformSound:Sound = Assets.getMusic("audio/ball_hit_platform.wav");
	
	public function new()
	{
		super();

		this.graphics.beginFill(COLOR_ORANGE);
		this.graphics.drawRect(0, 0, platformLength, platformWidth);
		this.graphics.endFill();
	}
	
	
	/* GETTERS & SETTERS */
	
	public function getPlatformSpeed():Int {
		return this.platformSpeed;
	}
	
	public function setPlatformSpeed(speed:Int) {
		this.platformSpeed = speed;
	}
	
	public function getPlatformLength():Float {
		return this.platformLength;
	}
	
	public function setPlatformLength(length:Float) {
		this.platformLength = length;
	}
	
	public function getPlatformWidth():Int {
		return this.platformWidth;
	}
	
	
	/* PUBLIC METHODS */
	
	public function playPlatformSound():Void {
		this.platformSound.play();
	}

}
