package characters {
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxDelay;

	public class Enemy extends Character {
		[Embed(source = "../data/playerSheet_red.png")] protected var ImgHeroRed:Class;
		protected static var hostileGroup:FlxGroup;
		protected var attackTarget:FlxObject;
		protected var alertTarget:FlxObject;
		protected var guardPost:FlxPoint;

		protected var turnTimer:FlxDelay;
		
		public function Enemy(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			guardPost = new FlxPoint(X, Y);
			turnTimer = new FlxDelay(Math.random() * 2000 + 2000);
			turnTimer.start();
			loadGraphic(ImgHeroRed, true, true, 64, 64);
			
			width = 30;
			height = 42;
			offset.x = 16;
			offset.y = 13;
			addAnimation('standing', [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61], 30, true);
			play('standing');
		}
		
		override public function update():void {
			super.update();
			if (attackTarget) {
				// attack behavior has highest priority
			}else {
				// no target, then just guard
				scanForPlayer();
				if (turnTimer.hasExpired) {
					facing = facing == LEFT ? RIGHT : LEFT; 
					turnTimer.reset(Math.random() * 2000 + 2000);
				}
			}
		}
		
		protected function scanForPlayer():Character {
			return null;
		}
	}

}