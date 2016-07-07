package ;
import openfl.display.Sprite;

class WallHorizontal extends Sprite implements Wall
{
	
	//CONSTANTS
	private var HORIZONTAL_WALL_WIDTH:Int = 500;
	private var HORIZONTAL_WALL_HEIGHT:Int = 10;
	private var COLOR_WHITE:Int = 0xffffff;
	
	public function new()
	{
		super();

		this.graphics.beginFill(COLOR_WHITE);
		this.graphics.drawRect(0, 0, HORIZONTAL_WALL_WIDTH, HORIZONTAL_WALL_HEIGHT);
		this.graphics.endFill();
	}
}
