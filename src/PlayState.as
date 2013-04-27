package{

	import characters.*;
	import flash.geom.Point;
	import org.flixel.*;

	public class PlayState extends FlxState{
		[Embed(source = "data/levels/mapCSV_Group1_Map1.csv", mimeType = "application/octet-stream")] public var MapTiles:Class;
		[Embed(source = "data/tileset1.png")] public var MapTileGfx:Class;
		
		public var map:FlxTilemap;
		public var player:FlxGroup;
		public var enemies:FlxGroup = new FlxGroup();
		public var metaGroup:FlxGroup = new FlxGroup();
		
		protected var lockOnPlayer:Boolean = true;
		public var cameraTarget:FlxObject = new FlxObject();
		
		public var hero:Hero;
		public var tileSize:uint = 16;
		
		override public function create():void {
			Globals.logic = this;
			hero = new Hero(40, 50);
			FlxG.bgColor = 0xFFFFFFFF;
			map = new FlxTilemap();
			Globals.map = map;
			map.loadMap(new MapTiles(), MapTileGfx, tileSize, tileSize, 0, 0, 1, 6);
			// set up collision groups
			
			metaGroup.add(map);
			metaGroup.add(hero);
			metaGroup.add(enemies);
			
			// add map and character to stage
			add(map);
			add(enemies);
			add(hero);
			
			FlxG.camera.setBounds(0,0,map.width,map.height,true);
			FlxG.camera.follow(cameraTarget);
			FlxG.framerate = 60;
			FlxG.flashFramerate = 60;
			
			// Press ~ to see the debugger
			FlxG.debug = true;
			addEnemy("guard", 500, 160);
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(metaGroup);
			
			var heroMid:FlxPoint = hero.getMidpoint();
			var heroTileIndex:Point = new Point(Math.floor(heroMid.x/tileSize), Math.floor(heroMid.y/tileSize));
			
			hero.currentTileBackground = map.getTile(heroTileIndex.x, heroTileIndex.y);
			
			//center camera on player
			if(lockOnPlayer){
				cameraTarget.x = hero.x + hero.origin.x;
				cameraTarget.y = hero.y + hero.origin.y;
			}
		}
		
		public function addEnemy(enType:String, x:Number, y:Number):Character {
			if (enType == "guard") {
				enemies.add(new Enemy(x,y));
			}
			return null;
		}
		
	}
}

