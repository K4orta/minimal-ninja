package
{
	import org.flixel.FlxTilemap;
	public class Globals
	{
		public static var logic:PlayState;
		public static var map:FlxTilemap;
		public static var gravity:Number = 1400;
		public static var currentLevel:int = 0;
		public static var timesSeen:uint = 0;
		public static var guarksKnockedOut:uint = 0;
		
		public function Globals(){
			
		}
	}

}