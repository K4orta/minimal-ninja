package{

	import characters.*;
	import flash.geom.Point;
	import org.flixel.*;
	import JSON;

	public class PlayState extends FlxState{
		[Embed(source = "data/tileset1.png")] public var MapTileGfx:Class;
		[Embed(source = "data/levels/Group1.json", mimeType = "application/octet-stream")] public var TestLevel:Class;
		
		public var map:FlxTilemap;
		public var backgroundMap:FlxTilemap;
		// anything that will piss off enemies goes in this group
		public var player:FlxGroup;
		// anything that the player's weapons(if any) goes in here
		public var enemies:FlxGroup;
		// add anything that collides here
		public var metaGroup:FlxGroup;
		
		protected var lockOnPlayer:Boolean = true;
		public var cameraTarget:FlxObject = new FlxObject();
		
		public var hero:Hero;
		public var tileSize:uint = 16;
		
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
			
			FlxG.bgColor = 0xFF000000;
			map = new FlxTilemap();
			backgroundMap = new FlxTilemap();
			Globals.map = map;
			if (mapData) {
				MapLoader.parseMapJSON(mapData, [map, backgroundMap], this);
				FlxG.log(map.height);
			}
			
			// set up collision groups
			
			metaGroup.add(map);
			metaGroup.add(player);
			metaGroup.add(enemies);
			
			// add map and character to stage
			add(backgroundMap);
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
				enemy.velocity.x = hero.velocity.x * 4;
				enemy.velocity.y = -600;
			}
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(metaGroup);
			FlxG.overlap(player, enemies, onHit);
			
			var heroMid:FlxPoint = hero.getMidpoint();
			var heroTileIndex:Point = new Point(Math.floor(heroMid.x/tileSize), Math.floor(heroMid.y/tileSize));
			
			hero.currentTileBackground = backgroundMap.getTile(heroTileIndex.x, heroTileIndex.y);
			
			//center camera on player
			if(lockOnPlayer){
				cameraTarget.x = hero.x + hero.origin.x;
				cameraTarget.y = hero.y + hero.origin.y;
			}
		}
		
		public function addCharacter(type:String, x:Number, y:Number, ...args):Character {
			var newCharacter:Character;
			if (type=="Hero") {
				newCharacter = new Hero(x, y);
				hero = newCharacter as Hero;
				player.add(newCharacter);
			}else if (type == "Guard") {
				newCharacter = new Enemy(x, y);
				newCharacter.makeHostileTo(player);
				enemies.add(newCharacter);
			}
			return newCharacter;
		}
		
		public function loadLevel(mapData:Class):void {
			//unload();
			initStage(new mapData());
		}
		
		private function unload():void {
			map = null;
			Globals.map = null;
			if(enemies){
				enemies.kill();
				player.kill();
			}
		}
		
	}
}

