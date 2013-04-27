package characters 
{
	import org.flixel.FlxSprite;
	
	public class Character extends FlxSprite 
	{
		
		public function Character(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			acceleration.y = Globals.gravity;
		}
		
	}

}