package objects {
	import flash.display.Graphics;
	import org.flixel.FlxSprite;
	import flash.display.Shape;
	import org.flixel.FlxG;
	
	public class Light extends FlxSprite {
		public var radius:Number;
		protected var lightColor:uint;
		public function Light(X:Number=0, Y:Number=0, argRadius:Number=0) {
			super(X, Y);
			radius = argRadius;
			lightColor = TileColors.WHITE;
		}
		
		public function drawLight():void {
			var lightGfx:Graphics = FlxG.flashGfx;
			lightGfx.clear();
			lightGfx.beginFill(0xFFFFFF);
			lightGfx.drawCircle(x-FlxG.camera.scroll.x, y-FlxG.camera.scroll.y, radius);
			FlxG.camera.buffer.draw(FlxG.flashGfxSprite);
		}
		
		public function getColor():uint {
			return lightColor;
		}
		
		override public function draw():void {
			drawLight();
			super.draw();
		}
		
	}

}