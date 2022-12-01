package;

import flixel.FlxState;
import flixel.FlxG;

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
		if (Main.fpsVar != null && FlxG.keys.anyJustPressed(CoolData.framesKeys))
		{
			Main.fpsVar.visible = !Main.fpsVar.visible;
		}

		if (FlxG.keys.anyJustPressed(CoolData.fullscreenKeys))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
