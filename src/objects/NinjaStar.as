package objects 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	
	/**
	 * ...
	 * @author Erik
	 */
	public class NinjaStar extends FlxSprite {
		[Embed(source = "../data/ninjastar.png")] protected var ImgStar:Class;
		protected var fadeDelay:FlxDelay;
		public function NinjaStar(X:Number=0, Y:Number=0, Target:FlxPoint=null) {
			super(X, Y, ImgStar);
			FlxVelocity.moveTowardsPoint(this, Target, 500);
			blend = "difference";
			
		}
		
		override public function update():void {
			super.update();
			if (justTouched(ANY)) {
			 velocity.x = 0;
			 velocity.y = 0;
			 allowCollisions = NONE;
			 
			}
			
		}
		
	}

}