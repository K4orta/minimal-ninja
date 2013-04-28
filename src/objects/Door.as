package objects 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	public class Door extends FlxSprite {
		[Embed(source = "../data/door.png")] protected var ImgDoor:Class;
		protected var player:FlxGroup;
		protected var doorType:String;
		public function Door(X:Number=0, Y:Number=0, options:Object=null){
			super(X, Y, ImgDoor);
			player = options.player;
			doorType = options.doorType;
		}
		
		override public function update():void {
			super.update();
			if (overlaps(player)) {
				if (doorType == "prev") {
					Globals.logic.prevMap();
				}else{
					Globals.logic.nextMap();
				}
			}
		}
	}
}