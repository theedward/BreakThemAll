package ;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.Assets;

class PowerUp
{

	public static var BIGGERPADDLE:String = "BiggerPaddle";
	public static var FASTERPADDLE:String = "FasterPaddle";
	
	private var powerUpLength:Int = 20;
	private var powerUpWidth:Int = 10;
	private var powerUpSpeed:Int = 1;
	private var imageData:BitmapData;
	private var image:Bitmap;
	private var type:String;
	
	public function new(type:String)
	{			
		var fastImage:BitmapData;
		fastImage = Assets.getBitmapData("img/FAST.png");
		var bigImage:BitmapData;
		bigImage = Assets.getBitmapData("img/BIG.png");

		switch(type) {
			case "BiggerPaddle":
				this.imageData = bigImage;
			case "FasterPaddle":
				this.imageData = fastImage;
			default:
				//Do Nothing
		}
		
		this.type = type;

	}
	
	public function getPowerUpSpeed():Int {
		return this.powerUpSpeed;
	}
	
	public function getImageData():BitmapData {
		return this.imageData;
	}
	
	public function setImage(image:Bitmap) {
		this.image = image;
	}
	
	public function getImage():Bitmap {
		return this.image;
	}
	
	public function getType():String {
		return this.type;
	}
}
