package characters {
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	public class Hero extends Character {
		[Embed(source = "../data/playerSheet.png")] protected var ImgHero:Class;
		[Embed(source = "../data/playerSheet_red.png")] protected var ImgHeroRed:Class;
		[Embed(source = "../data/playerSheet_blue.png")] protected var ImgHeroBlue:Class;
		[Embed(source = "../data/playerSheet_black.png")] protected var ImgHeroBlack:Class;
		protected var jumpPower:Number;
		protected var maxRunSpeed:Number;
		public var jumping:Boolean = false; 
		public var currentTileBackground:uint = 0;
		protected var currentColorIndex:uint = 0;
		
		public function Hero(X:Number=0, Y:Number=0){
			super(X, Y);
			loadGraphic(ImgHero, true, true, 64, 64);
			maxRunSpeed = 280;
			immovable = false;
			jumpPower = 500;
			drag.x = maxRunSpeed * 10;
			drag.y = 600;
			
			var runningArray:Array = [];
			for (var i:int = 1; i < 33; i++) {
				runningArray.push(i);
			}
			
			addAnimation('running', runningArray, 60, true);
			addAnimation('jumping', [39,40,41,42,43,42,41,40], 60, true);
			addAnimation('standing', [48,49,50,51,52,53,54,55,56,57,58,59,60,61], 60, true);
			
			// tweak the bounding box of the player
			width = 30;
			height = 42;
			offset.x = 16;
			offset.y = 13;
			
		}
		
		private function updatePlayerColor(color:String):void {
			loadGraphic(this['ImgHero' + color], true, true, 64, 64);
			
			width = 30;
			height = 42;
			offset.x = 16;
			offset.y = 13;
		}
		
		override public function isHidden():Boolean {
			return currentColorIndex == currentTileBackground;
		}
		
		override public function update():void {
			super.update();
			acceleration.x = 0;
			handleKeys();
			// should make it so color changes are detected even when jumping
			if (velocity.x == 0 && !jumping) {
				if (currentColorIndex == currentTileBackground) {
					alpha = 0.5;
				} else {
					alpha = 1;
				}
			} else {
				alpha = 1;
			}
		}
		
		public function handleKeys():void {
			
			if (FlxG.keys.LEFT || FlxG.keys.A) {
				facing = LEFT;
				if(!jumping) play('running');
				if(Math.abs(velocity.x)<maxRunSpeed){
					acceleration.x -= drag.x;
				}
			}else if (FlxG.keys.RIGHT || FlxG.keys.D) {
				facing = RIGHT;
				if(!jumping) play('running');
				if(Math.abs(velocity.x)<maxRunSpeed){
					acceleration.x += drag.x;
				}
			}else if(!jumping){
				play('standing');
			}
			
			if (FlxG.keys.ONE) {
				currentColorIndex = 0;
				updatePlayerColor('');
			} else if (FlxG.keys.TWO) {
				currentColorIndex = 3;
				updatePlayerColor('Red');
			} else if (FlxG.keys.THREE) {
				currentColorIndex = 4;
				updatePlayerColor('Blue');
			} else if (FlxG.keys.FOUR) {
				currentColorIndex = 5;
				updatePlayerColor('Black');
			}
			
			if (FlxG.keys.justPressed("SPACE") && (!velocity.y)) {
				velocity.y = -jumpPower;
				jumping = true;
				play('jumping');
			}
			
			if (!velocity.y) jumping = false;
		
			
			
		}
	}

}