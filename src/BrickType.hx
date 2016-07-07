package;

/**
 * ...
 * @author Joao Seixas
 */
class BrickType
{
	public static var NORMALVALUE:Int = 50;
	public static var STRONGVALUE:Int = 100;
	public static var STRONGERVALUE:Int = 150;
	
	public static var NORMALDURABILITY:Int = 1;
	public static var STRONGDURABILITY:Int = 2;
	public static var STRONGERDURABILITY:Int = 3;
	
	public static var NORMALCOLOR:UInt = 0xD9CB07;
	public static var STRONGCOLOR:UInt = 0x95EF06;
	public static var STRONGERCOLOR:UInt = 0x0AF5E5;
	
	private var value:Int;
	private var durability:Int;
	private var color:Int;
	
	public function new(value:Int, durability:Int, color:Int) 
	{
		this.value = value;
		this.durability = durability;
		this.color = color;
	}
	
	public function getValue():Int {
		return this.value;
	}
	
	public function getDurability():Int {
		return this.durability;
	}
	
	public function getColor():Int {
		return this.color;
	}
	
	public function setColor(color:Int) {
		this.color = color;
	}
}