package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.geom.Point;
import flash.ui.Mouse;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.media.SoundChannel;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.media.Sound;

enum GameState {
	Splash;
	MainMenu;
	Paused;
	Playing;
	Lost;
	Won;
}

enum BallCollision {
	Left;
	Top;
	Right;
	Bottom;
}


class Main extends Sprite
{
	var inited:Bool;
	
	//DEFAULT COORDINATE VALUES
	private var DEFAULT_GAME_SPEED:Int = 7;
	private var DEFAULT_PLATFORM_COORDINATES:Coordinates = new Coordinates(200, 480);
	private var DEFAULT_BALL_COORDINATES:Coordinates = new Coordinates(250, 470);
	private var DEFAULT_LEFT_WALL_COORDINATES:Coordinates = new Coordinates(0, 0);
	private var DEFAULT_TOP_WALL_COORDINATES:Coordinates = new Coordinates(0, 0);
	private var DEFAULT_RIGHT_WALL_COORDINATES:Coordinates = new Coordinates(490, 0);
	private var DEFAULT_SCORE_MESSAGE_COORDINATES:Coordinates = new Coordinates(20, 440);
	private var DEFAULT_SPLASH_IMAGE_COORDINATES:Coordinates = new Coordinates(125, 175);
	private var DEFAULT_START_BUTTON_COORDINATES:Coordinates = new Coordinates(50, 400);
	private var DEFAULT_SOUND_BUTTON_COORDINATES:Coordinates = new Coordinates(350, 400);

	private var DEFAULT_MESSAGE_FIELD_Y:Int = 350;
	private var DEFAULT_GAME_WON_LOST_MESSAGE_Y:Int = 300;
	private var DEFAULT_SPLASH_TITLE_Y:Int = 100;
	private var DEFAULT_SPLASH_MESSAGE_Y:Int = 450;
	private var DEFAULT_PLATFORM_LENGTH:Int = 100;
	
	//ENVIRONMENT VALUES
	private var INITIAL_SCORE:Int = 0;
	private var NUM_REPEATS:Int = 100;
	private var SCREEN_SIZE:Int = 500;
	private var MENU_BUTTON_WIDTH:Int = 50;
	private var MENU_BUTTON_LENGTH:Int = 100;
	private var PLATFORM_LEFT_LIMIT:Int = 6;
	private var PLATFORM_RIGHT_LIMIT:Int = 394;
	private var BALL_BOUNCE_LEFT:Int = 15;
	private var BALL_BOUNCE_RIGHT:Int = 485;
	private var BALL_BOUNCE_TOP:Int = 15;
	private var DROP_ZONE:Int = 495;
	
	//LETTERS
	private var DEFAULT_LETTER_TYPE:String = "_sans";
	private var SMALL_LETTER_SIZE:Int = 18;
	private var MEDIUM_LETTER_SIZE:Int = 24;
	private var LARGE_LETTER_SIZE:Int = 32;
	private var XTRA_LARGE_LETTER_SIZE:Int = 45;
	
	//STRINGS
	private var DEFAULT_MESSAGE_TEXT:String = "Press SPACE to start\nUse ARROW KEYS to move your platform\nUse ESC to go to the Main Menu";
	private var LEVEL_CLEARED_STRING:String = "LEVEL CLEARED";
	private var LEVEL_FAILED_STRING:String = "LEVEL FAILED!";
	private var GAME_NAME_STRING:String = "BREAK THEM ALL!";
	private var SPLASH_FIELD_MESSAGE_STRING:String = "Press ANY KEY to go to Main Menu";
	private var START_BUTTON_STRING:String = "Start!";
	private var SOUND_BUTTON_STRING_ON:String = "Sound:ON";
	private var SOUND_BUTTON_STRING_OFF:String = "Sound:OFF";
	private var GAME_WON_STRING:String = "YOU WON THE GAME!";
	private var SCORE_STRING:String = "Score: ";
	
	//COLORS
	private var COLOR_GREY:Int = 0xbbbbbb;
	private var COLOR_GREEN:Int = 0x66ff66;
	private var COLOR_BLUE:Int = 0x80aaff;
	private var COLOR_ORANGE:Int = 0xffad33;
	
	//SCREEN ELEMENTS
	private var platform:Platform;
	private var ball:Ball;
	private var leftWall:WallVertical;
	private var rightWall:WallVertical;
	private var topWall:WallHorizontal;
	private var scorePlayer:Int;
	private var scoreField:TextField;
	private var messageField:TextField;
	private var splashMessageField:TextField;
	private var gameLost:TextField;
	private var gameTitle:TextField;
	private var gameWon:TextField;
	private var level:Level;
	private var splashImage:Bitmap;
	private var buttonStart:MenuButton;
	private var buttonSound:MenuButton;
	
	//HELPERS
	private var currentGameState:GameState;
	private var levels:Array<Level>;
	private var currentLevel:String = "Level1";
	private var soundLevels:Array<String>;
	
	//SOUND
	private var sound:Bool = true;
	private var introSound:Sound;
	private var introChannel:SoundChannel;
	
	//MOVEMENT KEYS
	private var arrowKeyLeft:Bool;
	private var arrowKeyRight:Bool;
	
	//BALL COLLISION POINTS
	private var bottomPoint:Point;
	private var leftPoint:Point;
	private var topPoint:Point;
	private var rightPoint:Point;
	

	/* ENTRY POINT */

	function resize(e)
	{
		if (!inited) init();
		// else (resize or orientation change)
	}

	function init()
	{
		if (inited) return;
		inited = true;

		//SCREEN INITIALIZATIONS
		initSplashScreen();
		initMainMenu();
		initGenericLevel();

		//Keyboard event listeners
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		
		//Mouse event listeners
		stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		
		//Game Loop
		stage.addEventListener(Event.ENTER_FRAME, gameLoop);
		
		setGameState(Splash);
	}
	
	
	/* EVENT LISTENERS */
	
	//Keyboard Events
	private function keyDown(event:KeyboardEvent):Void {
		switch(currentGameState) {
			case MainMenu:
				switch (event.keyCode) {
					default:
						setGameState(Paused);
				}
			case Paused:
				switch (event.keyCode) {
					case 32:
						updateScore();
						setGameState(Playing);
					case 27: //ESC Key
						removeChildFromStage(level);
						removeChildFromStage(ball);
						removeChildFromStage(platform);
						removeChildFromStage(messageField);
						this.level.stopSound();
						if (sound) {
							introChannel = introSound.play(0, NUM_REPEATS);
						}
						setGameState(MainMenu);
					case 37:
						//arrowKeyLeft = true;
					case 39:
						//arrowKeyRight = true;
					default:
						//Do Nothing
				}
			case Playing:
				switch(event.keyCode) {
					case 32:
						setGameState(Paused);
					case 37:
						arrowKeyLeft = true;
					case 39:
						arrowKeyRight = true;
					default:
						//Do Nothing
				}
			case Lost:
				switch (event.keyCode) {
					case 32:
						this.level.stopSound();
						resetGame(levels[0].getLevelName());
						setGameState(Paused);
					case 27:
						//ESC Key
						this.level.stopSound();
						
						removeChildFromStage(level);
						removeChildFromStage(ball);
						removeChildFromStage(platform);
						removeChildFromStage(messageField);
						removeChildFromStage(gameLost);
						
						introChannel = introSound.play(0, NUM_REPEATS);
						setGameState(MainMenu);
				}
			case Won:
				switch (event.keyCode) {
					case 32:
						//go to next level
						setGameState(Paused);
					case 27:
						removeChildFromStage(level);
						removeChildFromStage(ball);
						removeChildFromStage(platform);
						removeChildFromStage(messageField);
						removeChildFromStage(gameWon);
						setGameState(MainMenu);
				}
			case Splash:
				switch (event.keyCode) {
					default:
						setGameState(MainMenu);
				}
			default:
				//Do Nothing
		}
	}
	
	private function keyUp(event:KeyboardEvent):Void {
		switch(currentGameState) {
			case MainMenu:
				//MainMenuCode
			case Paused:
				//DoNothing
			case Playing:
				switch(event.keyCode) {
					case 37:
						arrowKeyLeft = false;
					case 39:
						arrowKeyRight = false;
					default:
						//Do Nothing
				}
			default:
				//Do Nothing
		}
	}
	
	//Mouse Events
	private function mouseMove(event:MouseEvent):Void {
		switch(currentGameState) {
			case Playing:
				platform.x = event.localX;
				
			default:
				//
		}
	}
	
	private function startGameClick(event:MouseEvent) {
		setGameState(Paused);		
	}
	
	private function toggleSoundClick(event:MouseEvent) {
		this.sound = !this.sound;
		
		if (sound) {
			buttonSound.setText(SOUND_BUTTON_STRING_ON);
			introChannel = introSound.play(0, NUM_REPEATS);
		} else {
			buttonSound.setText(SOUND_BUTTON_STRING_OFF);
			introChannel.stop();
		}
	}
	
	//Game Loop
	private function gameLoop(event:Event):Void {
		switch(currentGameState) {
			case MainMenu:
				//MainMenu code
			case Playing:
				updateScore();
				
				//Platform Movement Code
				if (arrowKeyLeft) {
					platform.x -= platform.getPlatformSpeed();
				}
				
				if (arrowKeyRight) {
					platform.x += platform.getPlatformSpeed();
				}
				
				if (platform.x < PLATFORM_LEFT_LIMIT) platform.x = PLATFORM_LEFT_LIMIT;
				if (platform.x > PLATFORM_RIGHT_LIMIT) platform.x = PLATFORM_RIGHT_LIMIT;
				
				//Ball Movement Code
				ball.x += ball.getBallMovement().x;
				ball.y += ball.getBallMovement().y;
				if (ball.x < BALL_BOUNCE_LEFT || ball.x > BALL_BOUNCE_RIGHT) ball.setBallMovementXandY(ball.getBallMovement().x * -1, ball.getBallMovement().y); // Go to Oposite X direction, when touching a vertical wall
				if (ball.y < BALL_BOUNCE_TOP) ball.setBallMovementXandY(ball.getBallMovement().x, ball.getBallMovement().y * -1); //Go to the Oposite Y direction when touching an horizontal wall
				if (ball.y > DROP_ZONE) setGameState(Lost);
				
				//Ball Bouncing Code
				//Logic: Check if the ball is going down and is close to touching the platform. Then Check if the ball is within boundaries of the platform
				if (ball.getBallMovement().y > 0 && ball.y > DEFAULT_BALL_COORDINATES.getY() && ball.x >= platform.x && ball.x <= platform.x + platform.getPlatformLength()) {
					if (sound) {
						platform.playPlatformSound();
					}
					ball.setBallMovementXandY(ball.getBallMovement().x, ball.getBallMovement().y * -1);
					//ball.setBallMovement(new Point(Math.cos(MathHelper.calculateBallBounceAngle(ball.x,platform.getPlatformLength())) * ball.getBallSpeed(), Math.sin(MathHelper.calculateBallBounceAngle(ball.x,platform.getPlatformLength()/2)) * ball.getBallSpeed()));
				}
				
				//BALL COLLISION POINTS
				leftPoint = new Point(ball.x - ball.getBallRadius(), ball.y);
				rightPoint = new Point(ball.x + ball.getBallRadius(), ball.y);
				
				topPoint = new Point(ball.x, ball.y - ball.getBallRadius());
				bottomPoint = new Point(ball.x, ball.y + ball.getBallRadius());
				
				checkForBrickCollisions();
				
				if (level.getBrickList().length == 0) setGameState(Won);
				
				//POWERUP MOVEMENT
				var powerUps:Array<PowerUp> = level.getPowerUpList();
				if (powerUps.length > 0) {
					for (i in 0...powerUps.length) {
						powerUps[i].getImage().y += powerUps[i].getPowerUpSpeed();
						
						if (powerUps[i].getImage().y > DEFAULT_BALL_COORDINATES.getY() && powerUps[i].getImage().y < DROP_ZONE && powerUps[i].getImage().x >= platform.x && powerUps[i].getImage().x <= platform.x + platform.getPlatformLength()) {
							if (sound) {
								level.playPowerUpSound();
							}
							level.applyPowerUp(powerUps[i], platform);
							break;
						}
						
						if (powerUps[i].getImage().y > DROP_ZONE) {
							level.removePowerUp(powerUps[i]);
							break;
						}
					}
				}
				
			case Paused:
				//Do Nothing
			default:
				//Do Nothing
		}
	}
	
	
	/* PRIVATE METHODS */
	
	private function initGenericLevel():Void {
		
		platform = new Platform();
		platform.x = DEFAULT_PLATFORM_COORDINATES.getX();
		platform.y = DEFAULT_PLATFORM_COORDINATES.getY();

		ball = new Ball();
		ball.x = DEFAULT_BALL_COORDINATES.getX();
		ball.y = DEFAULT_BALL_COORDINATES.getY();
		
		leftWall = new WallVertical();
		leftWall.x = DEFAULT_LEFT_WALL_COORDINATES.getX();
		leftWall.y = DEFAULT_LEFT_WALL_COORDINATES.getY();
		stage.addChild(leftWall);
		
		rightWall = new WallVertical ();
		rightWall.x = DEFAULT_RIGHT_WALL_COORDINATES.getX();
		rightWall.y = DEFAULT_RIGHT_WALL_COORDINATES.getY();
		stage.addChild(rightWall);
		
		topWall = new WallHorizontal ();
		topWall.x = DEFAULT_TOP_WALL_COORDINATES.getX();
		topWall.y = DEFAULT_TOP_WALL_COORDINATES.getY();
		stage.addChild(topWall);
		
		var scoreFormat:TextFormat = new TextFormat(DEFAULT_LETTER_TYPE, MEDIUM_LETTER_SIZE, COLOR_GREY, true);
		scoreFormat.align = TextFormatAlign.RIGHT;

		scorePlayer = INITIAL_SCORE;
		
		scoreField = new TextField();
	
		scoreField.width = SCREEN_SIZE;
		scoreField.x -= DEFAULT_SCORE_MESSAGE_COORDINATES.getX();
		scoreField.y = DEFAULT_SCORE_MESSAGE_COORDINATES.getY();
		scoreField.defaultTextFormat = scoreFormat;
		scoreField.selectable = false;

		var messageFormat:TextFormat = new TextFormat(DEFAULT_LETTER_TYPE, SMALL_LETTER_SIZE, COLOR_GREY, true);
		messageFormat.align = TextFormatAlign.CENTER;

		messageField = new TextField();

		messageField.width = SCREEN_SIZE;
		messageField.y = DEFAULT_MESSAGE_FIELD_Y;
		messageField.defaultTextFormat = messageFormat;
		messageField.selectable = false;
		messageField.text = DEFAULT_MESSAGE_TEXT; //"Press SPACE to start\nUse ARROW KEYS to move your platform\nUse ESC to go to the Main Menu"
		
		var gameWonFormat:TextFormat = new TextFormat(DEFAULT_LETTER_TYPE, LARGE_LETTER_SIZE, COLOR_GREEN, true);
		gameWonFormat.align = TextFormatAlign.CENTER;

		gameWon = new TextField();
		gameWon.width = SCREEN_SIZE;
		gameWon.y = DEFAULT_GAME_WON_LOST_MESSAGE_Y;
		gameWon.defaultTextFormat = gameWonFormat;
		gameWon.selectable = false;
		gameWon.text = LEVEL_CLEARED_STRING; //"LEVEL CLEARED!"
		
		var gameLostFormat:TextFormat = new TextFormat(DEFAULT_LETTER_TYPE, LARGE_LETTER_SIZE, COLOR_BLUE, true);
		gameLostFormat.align = TextFormatAlign.CENTER;

		gameLost = new TextField();
		gameLost.width = SCREEN_SIZE;
		gameLost.y = DEFAULT_GAME_WON_LOST_MESSAGE_Y;
		gameLost.defaultTextFormat = gameLostFormat;
		gameLost.selectable = false;
		gameLost.text = LEVEL_FAILED_STRING;//"LEVEL FAILED"
		
		//MOVEMENT INITIALIZATION
		arrowKeyLeft = false;
		arrowKeyRight = false;
		
		platform.setPlatformSpeed(DEFAULT_GAME_SPEED);
		
		//INIT BALL MOVEMENT
		ball.setBallSpeed(DEFAULT_GAME_SPEED);
		var randomPositiveAngle:Float = Math.random() * -1 * Math.PI;
		ball.setBallMovement(new Point(Math.cos(randomPositiveAngle) * ball.getBallSpeed(), Math.sin(randomPositiveAngle) * ball.getBallSpeed()));
		
		//INIT LEVELS
		levels = parseLevels();
		level = levels[0];
		
		soundLevels = parseSounds(level);
		level.setSound(soundLevels[0]);

	}

	private function initSplashScreen():Void {
		
		var gameTitleFormat:TextFormat = new TextFormat(DEFAULT_LETTER_TYPE, XTRA_LARGE_LETTER_SIZE, COLOR_ORANGE, true);
		gameTitleFormat.align = TextFormatAlign.CENTER;

		gameTitle = new TextField();
		gameTitle.width = SCREEN_SIZE;
		gameTitle.y = DEFAULT_SPLASH_TITLE_Y;
		gameTitle.defaultTextFormat = gameTitleFormat;
		gameTitle.selectable = false;
		gameTitle.text = GAME_NAME_STRING; //"BREAK THEM ALL"
		
		var imageData:BitmapData = Assets.getBitmapData("img/breakout.png");
		splashImage = new Bitmap(imageData);
		splashImage.x = DEFAULT_SPLASH_IMAGE_COORDINATES.getX();
		splashImage.y = DEFAULT_SPLASH_IMAGE_COORDINATES.getY();
		
		var messageFormat:TextFormat = new TextFormat(DEFAULT_LETTER_TYPE, SMALL_LETTER_SIZE, COLOR_GREY, true);
		messageFormat.align = TextFormatAlign.CENTER;
		
		splashMessageField = new TextField();
		splashMessageField.width = SCREEN_SIZE;
		splashMessageField.y = DEFAULT_SPLASH_MESSAGE_Y;
		splashMessageField.defaultTextFormat = messageFormat;
		splashMessageField.selectable = false;
		splashMessageField.text = SPLASH_FIELD_MESSAGE_STRING; //"Press ANY KEY to go to Main Menu"
		
		introSound = Assets.getSound("audio/intro_pokemon.wav");
		if (sound) {
			introChannel = introSound.play(0, NUM_REPEATS);
		}
	}
	
	private function initMainMenu():Void {
		buttonStart = new MenuButton(DEFAULT_START_BUTTON_COORDINATES.getX(), DEFAULT_START_BUTTON_COORDINATES.getY(), MENU_BUTTON_LENGTH, MENU_BUTTON_WIDTH, START_BUTTON_STRING);
		buttonSound = new MenuButton(DEFAULT_SOUND_BUTTON_COORDINATES.getX(), DEFAULT_SOUND_BUTTON_COORDINATES.getY(), MENU_BUTTON_LENGTH, MENU_BUTTON_WIDTH, SOUND_BUTTON_STRING_ON);
		
		buttonStart.mouseChildren = false;
		buttonStart.buttonMode = true;
		buttonStart.addEventListener(MouseEvent.CLICK, startGameClick);
		
		buttonSound.mouseChildren = false;
		buttonSound.buttonMode = true;
		buttonSound.addEventListener(MouseEvent.CLICK, toggleSoundClick);
	}
		
	private function setGameState(state:GameState):Void {
		currentGameState = state;
		
		switch(state){
			case Paused:
				this.introChannel.stop();
				stage.addChild(ball);
				stage.addChild(platform);
				stage.addChild(level);
				stage.addChild(messageField);
				removeChildFromStage(splashImage);
				removeChildFromStage(buttonSound);
				removeChildFromStage(buttonStart);
				removeChildFromStage(gameWon);
			case Playing:
				if (sound) {
					level.playSound();
				}
				stage.addChild(scoreField);
				updateScore();
				removeChildFromStage(messageField);
			case Lost:
				stage.addChild(messageField);
				stage.addChild(gameLost);
			case Won:
				removeChildFromStage(level);
				if (!goToNextLevel(levels[0], soundLevels[0])) {
					stage.addChild(messageField);
					gameWon.text = GAME_WON_STRING;//"YOU WON THE GAME!"
					stage.addChild(gameWon);
				} else {
					stage.addChild(messageField);
					resetGame(level.getLevelName());
					setGameState(Paused);
				}
				
			case MainMenu:
				resetGame(levels[0].getLevelName());
				removeChildFromStage(scoreField);
				removeChildFromStage(gameTitle);
				removeChildFromStage(splashMessageField);
				stage.addChild(splashImage);
				splashImage.y = 50;
				stage.addChild(buttonStart);
				stage.addChild(buttonSound);
				
			case Splash:
				stage.addChild(gameTitle);
				stage.addChild(splashMessageField);
				stage.addChild(splashImage);
			default:
				//Do Nothing
		}
	}
	
	private function resetGame(currentLevel:String):Void {
		ball.x = DEFAULT_BALL_COORDINATES.getX();
		ball.y = DEFAULT_BALL_COORDINATES.getY();
		
		platform.x = DEFAULT_PLATFORM_COORDINATES.getX();
		platform.y = DEFAULT_PLATFORM_COORDINATES.getY();
		
		scorePlayer = INITIAL_SCORE;
		this.level.setCurrentScore(scorePlayer);
		
		arrowKeyLeft = false;
		arrowKeyRight = false;
		
		this.platform.setPlatformSpeed(DEFAULT_GAME_SPEED);
		this.platform.setPlatformLength(DEFAULT_PLATFORM_LENGTH);
		
		removeChildFromStage(gameLost);
		removeChildFromStage(scoreField);
			
		this.level.reload(currentLevel);
		
		//INIT BALL MOVEMENT
		ball.setBallSpeed(DEFAULT_GAME_SPEED);
		var randomPositiveAngle:Float = Math.random() * -1 * Math.PI;
		ball.setBallMovement(new Point(Math.cos(randomPositiveAngle) * ball.getBallSpeed(), Math.sin(randomPositiveAngle) * ball.getBallSpeed()));
		
	}

	private function updateScore():Void {
		if (level != null) {
			scorePlayer = level.getCurrentScore();
		}
		
		scoreField.text = SCORE_STRING + scorePlayer; //"Score: "
	}	
		
	private function checkForBrickCollisions() {
		//Check for collisions on each of the four points
		var brick:Brick = level.checkForBrickCollisions(leftPoint.x, leftPoint.y);
		if (brick != null) {
			if (sound) {
				brick.playCollisionSound();
			}
			handleBrickCollision(Left);
			brick = null;
		}
		
		//top
		brick = level.checkForBrickCollisions(topPoint.x, topPoint.y);
		if (brick != null) {
			if (sound) {
				brick.playCollisionSound();
			}
			handleBrickCollision(Top);
			brick = null;
		}
		
		//right
		brick = level.checkForBrickCollisions(rightPoint.x, rightPoint.y);
		if (brick != null) {
			if (sound) {
				brick.playCollisionSound();
			}
			handleBrickCollision(Right);
			brick = null;
		}
		
		//bottom
		brick = level.checkForBrickCollisions(bottomPoint.x, bottomPoint.y);
		if (brick != null) {
			if (sound) {
				brick.playCollisionSound();
			}
			handleBrickCollision(Bottom);
			brick = null;
		}
		
		
	}
	
	private function handleBrickCollision(collisionSide:BallCollision) {
		//Invert ball movement
		switch(collisionSide) {
			case Left:
				ball.setBallMovementXandY(ball.getBallMovement().x * -1, ball.getBallMovement().y);
			case Top:
				ball.setBallMovementXandY(ball.getBallMovement().x, ball.getBallMovement().y * -1);
			case Right:
				ball.setBallMovementXandY(ball.getBallMovement().x * -1, ball.getBallMovement().y);
			case Bottom:
				ball.setBallMovementXandY(ball.getBallMovement().x, ball.getBallMovement().y * -1);
			default:
				//Do Nothing
		}
	}
	
	private function parseLevels():Array<Level> {
		var levels:Array<Level> = new Array<Level>();
		var assetsInput:Array<String> = Assets.list(AssetType.TEXT);
		var currentFileName:String;
		
		for (i in 0...assetsInput.length) {
			//Files go like "levels/LevelX.txt" so I'm parsing for levels and LevelX.txt, grabbing the second one, then parsing again on the '.' and grabbing the first one
			currentFileName = assetsInput[i].split("/")[1].split(".")[0];
			levels.push(new Level(currentFileName));
		}
		
		//The function is parsing Level3, Level2, Level1, so I have to reverse the order
		levels.reverse();
		
		return levels;
	}
	
	private function parseSounds(level:Level):Array<String> {
		var sounds:Array<String> = new Array<String>();
		var assetsInput:Array<String> = Assets.list(AssetType.SOUND);
		var currentFileName:String;
		
		for (i in 0...assetsInput.length) {
			if (assetsInput[i].indexOf("audio/levels/level") >= 0) {
				currentFileName = assetsInput[i].split("/")[2].split(".")[0];
				sounds.push(currentFileName);
			}
		}
		
		sounds.reverse();
		
		return sounds;
	}
	
	private function goToNextLevel(level:Level, sound:String):Bool {
		level.stopSound();
		levels.remove(level);
		this.level = levels[0];
		
		this.soundLevels.remove(sound);
		
		if (this.level != null) {
			
			this.level.setSound(soundLevels[0]);
			return true;
		}
		
		return false;
	}
	
	private function removeChildFromStage(child:DisplayObject):Bool {
		if (stage.contains(child)) {
			stage.removeChild(child);
			return true;
		} else {
			return false;
		}
	}
	
	
	/* SETUP */

	public function new()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e)
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}

	public static function main()
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		//
	}
}
