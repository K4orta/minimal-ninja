package characters {
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxDelay;

	public class Enemy extends Character {
		[Embed(source = "../data/playerSheet_red.png")] protected var ImgHeroRed:Class;
		protected var hostileGroup:FlxGroup;
		protected var attackTarget:Character;
		protected var alertTarget:Character;
		protected var guardPost:FlxPoint;
		protected var jumpPower:uint = 200;

		protected var maxRunSpeed:Array = [50, 100, 150];
		protected var turnTimer:FlxDelay;
		protected var standDelay:uint = 0;
		
		private const CALM:uint = 0;
		private const ALERT:uint = 1;
		private const CHASING:uint = 2;
		
		protected var alertState:uint = 0;
		
		public function Enemy(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			guardPost = new FlxPoint(X, Y);
			turnTimer = new FlxDelay(Math.random() * 2000 + 2000);
			turnTimer.start();
			loadGraphic(ImgHeroRed, true, true, 64, 64);
			
			drag.x = maxRunSpeed[2]*10;
			drag.y = 600;
			
			width = 30;
			height = 42;
			offset.x = 16;
			offset.y = 13;
			addAnimation('standing', [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61], 30, true);
			play('standing');
		}
		
		override public function makeHostileTo(group:FlxGroup):void {
			hostileGroup = group;
		}
		
		override public function update():void {
			super.update();
			acceleration.x = 0;
			if (attackTarget) {
				alertState = CHASING;
				facing = x < attackTarget.x ? RIGHT : LEFT;
				// attack behavior has highest priority
				//flicker(1);
			}else {
				// no target, then just guard
				if (turnTimer.hasExpired) {
					facing = facing == LEFT ? RIGHT : LEFT; 
					turnTimer.reset(Math.random() * 2000 + 2000);
				}
				attackTarget = lineofSight(hostileGroup);
			}
			
			if(standDelay <= 0){
				if (facing == LEFT) {
					if(Math.abs(velocity.x)< maxRunSpeed[alertState]){
						acceleration.x -= drag.x;
					}
					if (isTouching(LEFT)) {
						velocity.y = -jumpPower;
					}
				} else {
					if(Math.abs(velocity.x)<maxRunSpeed[alertState]){
						acceleration.x += drag.x;
					}				
					if (isTouching(RIGHT)) {
						velocity.y = -jumpPower;
					}
				}
				
				if (alertState == CALM){
					if (Math.random() * 100 < 1) {
						standDelay = Math.round(Math.random() * 300);
					}
				}
			}else {
				standDelay--;
			}
		}		
		
	}

}