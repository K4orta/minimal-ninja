package  
{
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	
	
	public class MapLoader {
		[Embed(source = "data/blocking-tiles1.png")] public static var MapTileGfx:Class;
		[Embed(source = "data/background-tiles.png")] public static var MapBackgroundGfx:Class;
		
		public function MapLoader(){
		}
		
		public static function parseMapJSON(json:String, maps:Array, state:PlayState):void {
			var data:Object = JSON.parse(json);
			var spriteList:Array;
			var r:RegExp = /ROWEND/g
			for (var a:String in data) {
				
				if (a == "sprites") {
					spriteList = data[a];
				}else if (a == "blocking") {
					maps[0].loadMap(data[a].replace(r, "\n"), MapLoader.MapTileGfx, 16, 16, 0, 0, 1, 1);
				}else if (a == "background") {
					maps[1].loadMap(data[a].replace(r, "\n"), MapLoader.MapBackgroundGfx, 16, 16, 0, 0, 1, 1);
				}
			}
			//so maps are loaded before we put objects into them
			for each(var sp:Object in spriteList) {
				state.addSprite(sp.type, sp.x, sp.y, sp.properties);
			}
			
		}
		
	}

}