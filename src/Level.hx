package ;

import flash.display.Sprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import haxe.Timer;
import openfl.display.DisplayObject;
import openfl.media.Sound;
import openfl.media.SoundChannel;

class Level extends Sprite
{
	//DEFAULT VALUES
	private var LEVEL_MAP_LENGTH:Int = 18;
	private var LEVEL_MAP_WIDTH:Int = 16;
	private var NORMAL_BRICK:Int = 1;
	private var STRONG_BRICK:Int = 2;
	private var STRONGER_BRICK:Int = 3;
	private var SCALE_UP:Float = 1.75;
	private var SCALE_DOWN:Float = 0.75;
	private var POWER_UP_TIMEOUT_MS:Int = 5000;
	private var POWER_UP_SCALE_DOWN:Float = 0.25;
	
	//Repeated from Main ..
	private var NUM_REPEATS:Int = 100;
	private var DEFAULT_GAME_SPEED:Int = 7;
	
	//STRINGS
	private var FILE_NOT_FOUND_STRING:String = "[ERROR]: File was not found!";
	//Cannot add BiggerPaddle and FasterPaddle here because he complains that Capture variables (in the case) must be lower-case
	
	//VARIABLES
	private var brickList:Array<Brick> = new Array<Brick>();
	private var powerUpList:Array<PowerUp> = new Array<PowerUp>();
	private var map:Array<Array<Int>>;
	private var currentScore:Int = 0;
	private var levelName:String;
	private var powerUpSound:Sound = Assets.getMusic("audio/power_up.wav");
	private var sound:Sound;
	private var soundChannel:SoundChannel;
	
	public function new(fileName:String)
	{
		super();	
		
		this.levelName = fileName;
		
		map = createLevel(fileName);
		iterateThroughMap(map);
	}
	
	
	/* GETTERS & SETTERS */
	
	public function getBrickList():Array<Brick> {
		return this.brickList;
	}
	
	public function getPowerUpList():Array<PowerUp> {
		return this.powerUpList;
	}
	
	public function setSound(fileName:String) {
		var levelSound:Sound = Assets.getMusic("audio/levels/" + fileName + ".wav");
		if (levelSound == null){
			trace(FILE_NOT_FOUND_STRING);
		} else {
			this.sound = levelSound; 
		}
	}
	
	public function getSound():Sound {
		return this.sound;
	}
	
	public function getCurrentScore():Int {
		return this.currentScore;
	}
	
	public function getLevelName():String {
		return this.levelName;
	}
	
	
	/* PRIVATE METHODS */
	
	private function iterateThroughMap(map:Array<Array<Int>>):Void{
		var brick:Brick;
		//Iterate through rows
			for (y in 0...LEVEL_MAP_LENGTH) {
				//Iterate through columns
				for (x in 0...LEVEL_MAP_WIDTH) {
					if (map[y][x] == 0) {
						//Do Nothing
					} else if (map[y][x] == NORMAL_BRICK) {
						//Draw Normal Brick
						brick = new Brick(Normal, x, y);
						brickList.push(brick);
						this.addChild(brick);
						
					} else if (map[y][x] == STRONG_BRICK) {
						//Draw Strong Brick
						brick = new Brick(Strong, x, y);
						brickList.push(brick);
						this.addChild(brick);
						
					} else if (map[y][x] == STRONGER_BRICK) {
						//Draw Stronger Brick
						brick = new Brick(Stronger, x, y);
						brickList.push(brick);
						this.addChild(brick);
						
					}
				}
			}
	}
	
	private function handleBrickRemoval(brick:Brick) {
		//Handle Block Removal
		switch(brick.getBrickType().getDurability()){
			case BrickType.NORMALDURABILITY:
				
				brickList.remove(brick);
				removeBrick(brick);
				
				if (brick.hasPowerUp()) {
					handlePowerUp(brick);
				}
				
				currentScore += brick.getBrickType().getValue();
			case BrickType.STRONGDURABILITY:
				brick.setBrickType(new BrickType(BrickType.NORMALVALUE, BrickType.NORMALDURABILITY, BrickType.NORMALCOLOR));
				currentScore += brick.getBrickType().getValue();
				
			case BrickType.STRONGERDURABILITY:
				brick.setBrickType(new BrickType(BrickType.STRONGVALUE, BrickType.STRONGDURABILITY, BrickType.STRONGCOLOR));
				currentScore += brick.getBrickType().getValue();			
		}
	}
	
	private function handlePowerUp(brick:Brick):Void {
		//Draw powerup if there is one
		var splashImage:Bitmap = new Bitmap(brick.getPowerUp().getImageData());
		splashImage.scaleX = POWER_UP_SCALE_DOWN;
		splashImage.scaleY = POWER_UP_SCALE_DOWN;
		splashImage.x = brick.getXMapIndex();
		splashImage.y = brick.getYMapIndex();
		
		brick.getPowerUp().setImage(splashImage);
		
		powerUpList.push(brick.getPowerUp());
		
		this.addChild(splashImage);
	}
	
	private function undoPowerUp(powerUp:PowerUp, platform:Platform):Void {		
		switch(powerUp.getType()) {
			case "BiggerPaddle":
				platform.setPlatformLength(platform.getPlatformLength() / 2);
				platform.scaleX = SCALE_DOWN;
			case "FasterPaddle":
				platform.setPlatformSpeed(platform.getPlatformSpeed() - DEFAULT_GAME_SPEED);
			default:
				//
		}
	}
	
	private function createLevel(levelFile:String):Array<Array<Int>> {
		var map:Array<Array<Int>> = new Array<Array<Int>>();
		var input:String = Assets.getText("levels/" + levelFile + ".txt");
		
		if (input == null){
			trace(FILE_NOT_FOUND_STRING);
		} else {
			var rows:Array<String> = input.split("]");
			var columnValues:Array<String>;
			
			for (i in 0...rows.length) {
				var line:Array<Int> = new Array<Int>();
				
				columnValues = rows[i].split(",");
				for (j in 0...columnValues.length) {
					line.push(Std.parseInt(columnValues[j]));
				}
				map.push(line);
			}
		}
		return map;
	}
	
	
	/* PUBLIC METHODS */
	
	public function checkForBrickCollisions(ballX:Float, ballY:Float):Brick {
		for (i in 0...brickList.length) {
			if (brickList[i].collidedWithMe(ballX, ballY)) {
				
				var brick:Brick = brickList[i];
				
				handleBrickRemoval(brick);
				
				return brick;
			}
		}
		return null;
	}
	
	public function reload(fileName:String) {
		//Clear any powerup that may have been left wondering
		for (i in 0...powerUpList.length) {
			this.removeChild(powerUpList[i].getImage());			
		}
		
		powerUpList.splice(0, powerUpList.length);
		
		for (j in 0...brickList.length) {
			removeBrick(brickList[j]);
		}
		
		brickList.splice(0, brickList.length);
		
		map = createLevel(fileName);
		iterateThroughMap(map);
	
	}
	
	public function removePowerUp(powerUp:PowerUp) {
		this.removeChild(powerUp.getImage());
		this.powerUpList.remove(powerUp);
	}
	
	public function removeBrick(brick:Brick) {
		this.removeChild(brick);
	}
	
	public function playSound():Void {
		this.soundChannel = sound.play(0, NUM_REPEATS);
	}
	
	public function stopSound():Void {
		this.soundChannel.stop();
	}
	
	public function applyPowerUp(powerUp:PowerUp, platform:Platform) {
		switch(powerUp.getType()) {
			case "BiggerPaddle":
				platform.setPlatformLength(platform.getPlatformLength() + platform.getPlatformLength());
				platform.scaleX = SCALE_UP;
			case "FasterPaddle":
				platform.setPlatformSpeed(platform.getPlatformSpeed() + DEFAULT_GAME_SPEED);
			default:
				//
		}
		Timer.delay(function () {
				undoPowerUp(powerUp, platform);
			}, POWER_UP_TIMEOUT_MS);
		
		removePowerUp(powerUp);
	}
	
	public function playPowerUpSound():Void {
		this.powerUpSound.play();
	}
	
	public function setCurrentScore(score:Int) {
		this.currentScore = score;
	}

}
