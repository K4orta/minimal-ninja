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
		public var dashing:Boolean = false; 
		public var dashSpeed:uint = 0; 
		public var dashDown:Boolean = false; 
		public var currentTileBackground:uint = 0;
		protected var currentColorIndex:uint = 0;
		
		public function Hero(X:Number=0, Y:Number=0){
			super(X, Y);
			loadGraphic(ImgHero, true, true, 64, 64);
			maxRunSpeed = 280;
			immovable = false;
			jumpPower = 500;
			drag.x = maxRunSpeed*3;
			drag.y = 600;
			
			var runningArray:Array = [];
			for (var i:int = 1; i < 33; i++) {
				runningArray.push(i);
			}
			
			addAnimation('running', runningArray, 60, true);
			addAnimation('jumping', [39,40,41,42,43,42,41,40], 60, true);
			addAnimation('standing', [48,49,50,51,52,53,54,55,56,57,58,59,60,61], 60, true);
			addAnimation('ducking', [62], 60, false);
			
			
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
			if (currentColorIndex == currentTileBackground) {
				alpha = 0.5;
			} else {
				alpha = 1;
			}
		}
		
		public function handleKeys():void {
			if (FlxG.keys.M) {
				if(!dashing && !dashDown){
					dashing = true;
					dashSpeed = maxRunSpeed * 3;
					velocity.x = dashSpeed * (facing == RIGHT ? 1 : -1);
					acceleration.x = dashSpeed;
				}
				dashDown = true;
			}else {
				dashDown = false;
			}			
			
			if (dashSpeed < maxRunSpeed) {
				dashing = false;
				dashSpeed = 0;
			} else {
				dashSpeed *= 0.95;
			}
			
			if (dashing) {
				play('ducking');
				if(Math.abs(velocity.x)<dashSpeed){
					if (facing == LEFT) {
						acceleration.x -= drag.x;
					}else {
						acceleration.x += drag.x;
					}
				}
			}else if (FlxG.keys.LEFT || FlxG.keys.A) {
				facing = LEFT;
				if(!jumping) play('running');
				if(Math.abs(velocity.x)<maxRunSpeed+dashSpeed){
					acceleration.x -= drag.x;
				}
			}else if (FlxG.keys.RIGHT || FlxG.keys.D) {
				facing = RIGHT;
				if(!jumping) play('running');
				if(Math.abs(velocity.x)<maxRunSpeed+dashSpeed){
					acceleration.x += drag.x;
				}
			}else if (FlxG.keys.DOWN || FlxG.keys.S) {
				if(!jumping) play('ducking');
			}else if(!jumping){
				play('standing');
			}
			
			
			
			if (FlxG.keys.J) {
				currentColorIndex = 0;
				updatePlayerColor('');
			} else if (FlxG.keys.K) {
				currentColorIndex = 3;
				updatePlayerColor('Red');
			} else if (FlxG.keys.L) {
				currentColorIndex = 4;
				updatePlayerColor('Blue');
			} else if (FlxG.keys.SEMICOLON) {
				currentColorIndex = 5;
				updatePlayerColor('Black');
			}
			
			if (FlxG.keys.justPressed("SPACE")) {
				if(!velocity.y) {
					velocity.y = -jumpPower;
					jumping = true;
				}else {
					if (isTouching(LEFT)) {
						facing = RIGHT;
						velocity.x = maxRunSpeed*2;
						velocity.y = -jumpPower;
						jumping = true;
					}else if (isTouching(RIGHT)) {
						facing = LEFT;
						velocity.x = -maxRunSpeed*2;
						velocity.y = -jumpPower;
						jumping = true;
					}					
				}
				play('jumping');
			}
			
			if (!velocity.y) jumping = false;			
			
		}
	}

}