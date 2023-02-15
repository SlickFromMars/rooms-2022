package meta;

import flixel.FlxG;

class Preferences
{
	public static var retroMode:Bool = false;
	public static var showFPS:Bool = false;

	public static function savePrefs()
	{
		FlxG.save.data.retroMode = retroMode;
		FlxG.save.data.showFPS = showFPS;

		applyPrefs();

		FlxG.save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs()
	{
		if (FlxG.save.data.retroMode != null)
			retroMode = FlxG.save.data.retroMode;
		if (FlxG.save.data.showFPS != null)
		{
			showFPS = FlxG.save.data.showFPS;
		}

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		applyPrefs();
	}

	public static function applyPrefs()
	{
		Main.fpsVar.visible = showFPS;
	}
}
