package;

import flixel.FlxG;
import flixel.FlxState;

class FrameState extends FlxState
{
	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed(CoolData.fullscreenKeys))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
