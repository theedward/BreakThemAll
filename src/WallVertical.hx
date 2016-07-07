package ;
import openfl.display.Sprite;

class WallVertical extends Sprite implements Wall
{
	
	public function new()
	{
		super();

		this.graphics.beginFill(0xffffff);
		this.graphics.drawRect(0, 0, 10, 500);
		this.graphics.endFill();
	}
}
