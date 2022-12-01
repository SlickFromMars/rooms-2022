package;

import flixel.FlxSubState;

class FrameSubState extends FlxSubState
{
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check keys
		FrameState.backgroundKeys();
	}
}
