package{

	import characters.*;
	import objects.*;
	import flash.geom.Point;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import JSON;

	public class PlayState extends FlxState{
		[Embed(source = "data/tileset1.png")] public var MapTileGfx:Class;
		[Embed(source = "data/levels/Group1.json", mimeType = "application/octet-stream")] public var TestLevel:Class;
		[Embed(source = "data/levels/Level2.json", mimeType = "application/octet-stream")] public var TestLevel2:Class;
		
		
		public var map:FlxTilemap;
		public var backgroundMap:FlxTilemap;
		// anything that will piss off enemies goes in this group
		public var player:FlxGroup;
		// anything that the player's weapons(if any) goes in here
		public var enemies:FlxGroup;
		// add anything that collides here
		public var metaGroup:FlxGroup;
		public var miscObjects:FlxGroup;
		public var backgroundObjects:FlxGroup;
		public var lights:FlxGroup;
		public var particles:FlxGroup;
		
		protected var lockOnPlayer:Boolean = true;
		public var cameraTarget:FlxObject = new FlxObject();
		
		public var hero:Hero;
		public var tileSize:uint = 16;
		public var levels:Array = new Array(TestLevel, TestLevel2);
		
		override public function create():void {
			super.create();
			Globals.logic = this;
			
			FlxG.framerate = 60;
			FlxG.flashFramerate = 60;
			// Press ~ to see the debugger
			FlxG.debug = true;
			
			loadLevel(TestLevel);
		}
		
		private function initStage(mapData:String=""):void {
			player = new FlxGroup();
			enemies = new FlxGroup();
			metaGroup = new FlxGroup();
			backgroundObjects = new FlxGroup();
			miscObjects = new FlxGroup();
			lights = new FlxGroup();
			
			FlxG.bgColor = 0xFF000000;
			map = new FlxTilemap();
			backgroundMap = new FlxTilemap();
			Globals.map = map;
			if (mapData) {
				MapLoader.parseMapJSON(mapData, [map, backgroundMap], this);
				FlxG.log(map.height);
			}
			
			// set up collision groups
			
			backgroundObjects.add(lights);
			metaGroup.add(player);
			metaGroup.add(enemies);
			
			// add map and character to stage
			add(backgroundMap);
			add(backgroundObjects);
			add(map);
			add(enemies);
			add(player);
			add(cameraTarget);
			
			FlxG.camera.setBounds(0,0,map.width,map.height,true);
			FlxG.camera.follow(cameraTarget);

		}
		
		public function onHit(hero:Hero, enemy:Enemy):void {
			if (hero.dashing && !enemy.knockedOut) {
				enemy.knockedOut = true;
				Globals.guarksKnockedOut += 1;
				enemy.velocity.x = hero.velocity.x * 4;
				enemy.velocity.y = -600;
			}
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(metaGroup, map);
			FlxG.overlap(player, enemies, onHit);
			
			var heroMid:FlxPoint = hero.getMidpoint();
			var heroTileIndex:Point = new Point(Math.floor(heroMid.x/tileSize), Math.floor(heroMid.y/tileSize));
			
			hero.currentTileBackground = backgroundMap.getTile(heroTileIndex.x, heroTileIndex.y);
			updateLights();
			
			//center camera on player
			if(lockOnPlayer){
				cameraTarget.x = hero.x + hero.origin.x;
				cameraTarget.y = hero.y + hero.origin.y;
			}
		}
		
		public function updateLights():void {
			for each(var light:Light in lights.members) {
				if (hero.getDist(light) < light.radius) {
					hero.currentTileBackground = light.getColor();
				}
			}
		}
		
		public function addSprite(type:String, x:Number, y:Number, options:Object=null):FlxSprite {
			var newCharacter:FlxSprite;
			if (type=="Hero") {
				newCharacter = new Hero(x, y);
				hero = newCharacter as Hero;
				player.add(newCharacter);
			}else if (type == "Guard") {
				newCharacter = new Enemy(x, y);
				(newCharacter as Enemy).makeHostileTo(player);
				enemies.add(newCharacter);
			}else if (type == "Door") {
				options["player"] = player;
				newCharacter = new Door(x, y, options);
				backgroundObjects.add(newCharacter);
			}else if (type == "Light") {
				if (!options.radius) options.radius = 32; 
				newCharacter = new Light(x, y, Number(options.radius));
				lights.add(newCharacter);
			}
			return newCharacter;
		}
		
		public function nextMap():void {
			loadLevel(levels[++Globals.currentLevel]);
		}
		
		public function prevMap():void {
			loadLevel(levels[--Globals.currentLevel]);
		}
		
		public function loadLevel(mapData:Class):void {
			unload();
			initStage(new mapData());
		}
		
		private function unload():void {
			remove(player);
			remove(enemies);
			remove(map);
			remove(backgroundMap);
			remove(backgroundObjects);
			map = null;
			backgroundMap = null;
			Globals.map = null;
			if(enemies){
				enemies.kill();
				player.kill();
				backgroundObjects.kill();
			}
		}
		
	}
}

