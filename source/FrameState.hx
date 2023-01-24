package;

import flixel.FlxG;
import flixel.FlxState;

class FrameState extends FlxState
{
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check keys
		backgroundKeys();
	}

	// Checking important keys for frame states
	public static function backgroundKeys()
	{
		if (FlxG.keys.anyJustPressed(CoolData.fullscreenKeys))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}

	// Switch state function
	public static function switchState(nextState:FlxState)
	{
		var curState:FlxState = FlxG.state;
		if (curState == nextState)
		{
			FlxG.resetState();
		}
		else
		{
			FlxG.switchState(nextState);
		}
	}

	public static function resetState()
	{
		FrameState.switchState(FlxG.state);
	}
}
