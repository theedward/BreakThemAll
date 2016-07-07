package ;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class MenuButton extends Sprite
{

	private var textField:TextField;
	
	public function new(x:Int, y:Int, width:Int, height:Int, text:String)
	{
		super();

		var messageFormat:TextFormat = new TextFormat("_sans", 16, 0xffffff, true);
		messageFormat.align = TextFormatAlign.CENTER;
		
		textField = new TextField();
		textField.x = x;
		textField.y = y + 15;
		textField.width = width;
		textField.height = height;
		textField.defaultTextFormat = messageFormat;
		textField.selectable = true;
		
		this.textField.text = text;
		
		this.addChild(textField);
		
		this.graphics.beginFill(0xffad33);
		this.graphics.drawRect(x, y, width, height);
		this.graphics.endFill();
	}
	
	public function setText(text:String):Void {
		this.textField.text = text;
	}
}
