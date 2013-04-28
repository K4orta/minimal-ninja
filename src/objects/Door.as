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
			super(X, Y);
			player = options.player;
			doorType = options.doorType;
			loadGraphic(ImgDoor, true, false, 48, 64);
			addAnimation("open", [1], 0, false);
			addAnimation("locked", [0], 0, false);
			play("open");
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