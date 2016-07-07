package ;
import openfl.display.Sprite;

class WallVertical extends Sprite implements Wall
{

	//CONSTANTS
	private var VERTICAL_WALL_HEIGHT:Int = 500;
	private var VERTICAL_WALL_WIDTH:Int = 10;
	private var COLOR_WHITE:Int = 0xffffff;
	
	public function new()
	{
		super();

		this.graphics.beginFill(COLOR_WHITE);
		this.graphics.drawRect(0, 0, VERTICAL_WALL_WIDTH, VERTICAL_WALL_HEIGHT);
		this.graphics.endFill();
	}
}
