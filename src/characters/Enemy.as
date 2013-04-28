package characters {
	import flash.geom.Point;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxDelay;

	public class Enemy extends Character {
		[Embed(source = "../data/playerSheet.png")] protected var ImgHero:Class;
		[Embed(source = "../data/playerSheet_red.png")] protected var ImgHeroRed:Class;
		[Embed(source = "../data/playerSheet_blue.png")] protected var ImgHeroBlue:Class;
		protected var hostileGroup:FlxGroup;
		protected var attackTarget:Character;
		protected var alertTarget:Character;
		protected var guardPost:FlxPoint;
		protected var jumpPower:uint = 200;
		public var knockedOut:Boolean = false;

		protected var maxRunSpeed:Array = [50, 100, 150];
		protected var turnTimer:FlxDelay;
		protected var standDelay:uint = 0;
		
		private const CALM:uint = 0;
		private const ALERT:uint = 1;
		private const CHASING:uint = 2;
		
		private var lastKnownPoint:Point;
		private var alertCountDown:uint = 0;;
		
		protected var alertState:uint = 0;
		protected var starMagazine:uint = 3;
		protected var attackDelay: FlxDelay;
		
		public function Enemy(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			guardPost = new FlxPoint(X, Y);
			turnTimer = new FlxDelay(Math.random() * 2000 + 2000);
			turnTimer.start();
			loadGraphic(ImgHeroBlue, true, true, 64, 64);
			attackDelay = new FlxDelay(0);
			attackDelay.start();
			
			drag.x = maxRunSpeed[2]*10;
			drag.y = 600;
			
			width = 30;
			height = 42;
			offset.x = 16;
			offset.y = 13;
			addAnimation('standing', [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61], 30, true);
			addAnimation('knockedOut', [62], 30, true);
			play('standing');
		}
		
		private function updatePlayerColor(color:String):void {
			loadGraphic(this['ImgHero' + color], true, true, 64, 64);
			
			width = 30;
			height = 42;
			offset.x = 16;
			offset.y = 13;
		}
		
		override public function makeHostileTo(group:FlxGroup):void {
			hostileGroup = group;
		}
		
		protected function starAttack():void {
			Globals.logic.addProjectile("star", x, y, new FlxPoint(attackTarget.x+attackTarget.origin.x, attackTarget.y+attackTarget.origin.y));
			if (starMagazine > 0) {
				attackDelay.reset(400);
				--starMagazine;
			}else {
				attackDelay.reset(2000);
				starMagazine = 3;
			}
			
		}
		
		override public function update():void {
			super.update();
			acceleration.x = 0;
			if (knockedOut) {
				if(alertState == CALM){
					play('knockedOut');
					return;
				}else {
					knockedOut = false;
				}
			}
			
			if (attackTarget) {
				if (alertState == CALM) {
					updatePlayerColor('Red');
					alertCountDown = 180;
					alertState = CHASING;
					lastKnownPoint = new Point(attackTarget.x, attackTarget.y);
				}
				
				facing = x < lastKnownPoint.x ? RIGHT : LEFT;
				if(attackDelay.hasExpired){
					starAttack();
				}
				
				// adding a minimum distance so the player can't just invis in the guard's face
				if (!lineofSight(hostileGroup) && getDist(attackTarget) > 168) {
					alertState = ALERT;
					if (Math.abs(x - lastKnownPoint.x) < 30) {
						standDelay = 120;
						if (alertCountDown > 0) alertCountDown--;
						else {
							attackTarget = null;
							updatePlayerColor('Blue');
							standDelay = 120;
							alertState = CALM;
						}
					}					
				}else {
					lastKnownPoint = new Point(attackTarget.x, attackTarget.y);
					alertState = CHASING;
					alertCountDown = 180;
				}
				// attack behavior has highest priority
				//flicker(1);
			}else {
				// no target, then just guard
				if (turnTimer.hasExpired) {
					facing = facing == LEFT ? RIGHT : LEFT; 
					turnTimer.reset(Math.random() * 2000 + 2000);
				}
				attackTarget = lineofSight(hostileGroup);
				if (attackTarget) {
					Globals.timesSeen += 1;
				}
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