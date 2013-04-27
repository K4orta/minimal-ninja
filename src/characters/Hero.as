package characters {
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Erik
	 */
	
	public class Hero extends Character {
		[Embed(source = "../data/playerSheet.png")] protected var ImgHero:Class;
		protected var jumpPower:Number;
		protected var maxRunSpeed:Number;
		public var jumping:Boolean = false; 
		
		public function Hero(X:Number=0, Y:Number=0){
			super(X, Y);
			loadGraphic(ImgHero, true, true, 64, 64);
			maxRunSpeed = 250;
			immovable = false;
			jumpPower = 500;
			drag.x = maxRunSpeed * 10;
			drag.y = 300;
			
			// tweak the bounding box of the player
			width = 30;
			height = 42;
			offset.x = 16;
			offset.y = 13;
			
		}
		
		override public function update():void {
			super.update();
			acceleration.x = 0;
			handleKeys();
		}
		
		public function handleKeys():void {
			
			if (FlxG.keys.LEFT) {
				facing = LEFT;
				if(Math.abs(velocity.x)<maxRunSpeed)
					acceleration.x -= drag.x;
			}else if (FlxG.keys.RIGHT) {
				facing = RIGHT;
				if(Math.abs(velocity.x)<maxRunSpeed)
					acceleration.x += drag.x;
			}
			
			if (FlxG.keys.justPressed("SPACE") && (!velocity.y)) {
				velocity.y = -jumpPower;
				jumping = true;
			}
			
		}
	}

}