package

{

	import org.flixel.*;
	[SWF(width="720", height="405", backgroundColor="#FFFFFF")]
	[Frame(factoryClass="Preloader")]



	public class MinimalNinja extends FlxGame{

		public function MinimalNinja(){

			super(720,405,MenuState, 1, 60, 60);
			forceDebugger = true;
		}

	}

}

