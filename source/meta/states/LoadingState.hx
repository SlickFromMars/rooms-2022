package meta.states;

import meta.Frame.FrameState;
import openfl.utils.Assets;

class LoadingState extends FrameState
{
	inline static var MIN_TIME = 1.0;

	override function create()
	{
		super.create();

		checkLibrary('shared');
		checkLibrary('levels');

		FrameState.switchState(new meta.states.PlayState());
	}

	function checkLibrary(library:String):Void
	{
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null)
		{
			Assets.loadLibrary(library);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
