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

		#if !mobile
		if (Main.fpsVar != null && FlxG.keys.anyJustPressed(CoolData.framesKeys))
		{
			Main.fpsVar.visible = !Main.fpsVar.visible;
		}
		#end
	}
}
