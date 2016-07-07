package ;
import openfl.display.Sprite;

class WallHorizontal extends Sprite implements Wall
{
	
	public function new()
	{
		super();

		this.graphics.beginFill(0xffffff);
		this.graphics.drawRect(0, 0, 500, 10);
		this.graphics.endFill();
	}
}
