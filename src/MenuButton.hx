package ;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class MenuButton extends Sprite
{
	//CONSTANTS
	//Copy from Main.hx
	private var DEFAULT_LETTER_TYPE:String = "_sans";
	private var COLOR_ORANGE:Int = 0xffad33;
	
	private var COLOR_WHITE:Int = 0xffffff;
	private var LETTER_SIZE:Int = 16;
	private var TEXT_FIELD_ELEVATION:Int = 15;
	
	//VARIABLES
	private var textField:TextField;
	
	public function new(x:Int, y:Int, width:Int, height:Int, text:String)
	{
		super();

		var messageFormat:TextFormat = new TextFormat(DEFAULT_LETTER_TYPE, LETTER_SIZE, COLOR_WHITE, true);
		messageFormat.align = TextFormatAlign.CENTER;
		
		textField = new TextField();
		textField.x = x;
		textField.y = y + TEXT_FIELD_ELEVATION;
		textField.width = width;
		textField.height = height;
		textField.defaultTextFormat = messageFormat;
		textField.selectable = true;
		
		this.textField.text = text;
		
		this.addChild(textField);
		
		this.graphics.beginFill(COLOR_ORANGE);
		this.graphics.drawRect(x, y, width, height);
		this.graphics.endFill();
	}
	
	
	/* GETTERS & SETTERS */
	
	public function setText(text:String):Void {
		this.textField.text = text;
	}
}
