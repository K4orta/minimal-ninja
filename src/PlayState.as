package{

	import characters.*;
	import org.flixel.*;

	public class PlayState extends FlxState{
		[Embed(source = "data/levels/mapCSV_Group1_Map1.csv", mimeType = "application/octet-stream")] public var MapTiles:Class;
		[Embed(source = "data/tileset1.png")] public var MapTileGfx:Class;
		
		public var map:FlxTilemap;
		public var player:FlxGroup;
		public var enemies:FlxGroup = new FlxGroup();
		public var metaGroup:FlxGroup = new FlxGroup();
		
		public var cameraTarget:FlxObject = new FlxObject();
		
		public var hero:Character;
		
		override public function create():void{
			hero = new Hero(40, 50);
			FlxG.bgColor = 0xFFFFFFFF;
			map = new FlxTilemap();
			map.loadMap(new MapTiles(), MapTileGfx, 16, 16, 0, 0, 1, 2);
			// set up collision groups
			
			metaGroup.add(map);
			metaGroup.add(hero);
			
			// add map and character to stage
			add(map);
			add(hero);
			
			FlxG.camera.setBounds(0,0,map.width,map.height,true);
			FlxG.camera.follow(cameraTarget);
			FlxG.framerate = 60;
			FlxG.flashFramerate = 60;
			
			// Press ~ to see the debugger
			FlxG.debug = true;
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(metaGroup);
			
			//center camera on player
			cameraTarget.x = hero.x + hero.origin.x;
			cameraTarget.y = hero.y + hero.origin.y;
			
		}
		
	}
}

