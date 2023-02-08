package meta;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import meta.Controls.ControlScheme;

class FrameState extends FlxState
{
	private var lastTextUpdate:ControlScheme;

	override function update(elapsed:Float)
	{
		// Check ui
		if (lastTextUpdate != Controls.CONTROL_SCHEME)
		{
			updateUIText();
		}

		// Check keys
		Controls.updateKeys();
		backgroundKeys();

		super.update(elapsed);
	}

	// for states with help tips
	function updateUIText()
	{
		// trace('Updating UI');
	}

	// Checking important keys for frame states
	public static function backgroundKeys()
	{
		if (Controls.FULLSCREEN)
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

class FrameSubState extends FlxSubState
{
	private var lastTextUpdate:ControlScheme;

	override function update(elapsed:Float)
	{
		// Check ui
		if (lastTextUpdate != Controls.CONTROL_SCHEME)
		{
			updateUIText();
		}

		super.update(elapsed);

		// Check keys
		Controls.updateKeys();
		FrameState.backgroundKeys();
	}

	// for states with help tips
	function updateUIText()
	{
		// trace('Updating UI');
	}
}
