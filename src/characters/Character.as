package characters 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.plugin.photonstorm.FlxMath;
	
	public class Character extends FlxSprite {	
		public var sightRange:Number = 500;
		public var litColor:uint;
		
		public function Character(X:Number=0, Y:Number=0, SimpleGraphic:Class=null){
			super(X, Y, SimpleGraphic);
			acceleration.y = Globals.gravity;
		}
		
		protected function lineofSight(group:FlxGroup):Character {
			var rayPnt:FlxPoint = new FlxPoint();
			var rp2:FlxPoint = new FlxPoint();
			for each(var a:Character in group.members) {
				if (a && a.alive &&! a.isHidden()) {
					if ((facing == LEFT && a.x > x) || (facing == RIGHT && a.x < x))
						continue;
					if (Math.abs(a.getDist(this)) < sightRange) {
						if(Globals.map.ray(new FlxPoint(x+origin.x, y),new FlxPoint(a.x+a.origin.x, a.y+a.origin.y),rayPnt)){
							return a;
						}
					}
				}
			}
			return null;
		}
		
		public function isHidden():Boolean {
			return false;
		}
		
		public function makeHostileTo(group:FlxGroup):void {
			
		}
		
		public function getDist(Arg:FlxSprite):Number {
			var dx:Number = (Arg.x+Arg.origin.x) - (x+origin.x);
			var dy:Number = (Arg.y+Arg.origin.y) - (y+origin.y);
			return FlxMath.sqrt(dx * dx + dy * dy);
		}
	}

}