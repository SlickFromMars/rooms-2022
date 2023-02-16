package;

import flixel.FlxG;

class RoomsData
{
	// PROGRESS STUFF
	public static var roomNumber:Int = 1; // Room number

	// PREFS STUFF
	public static var showFPS:Bool = false; // show the FPS counter
	public static var retroMode:Bool = false; // enable the bw shader in gameplay

	public static function saveData()
	{
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.retroMode = retroMode;

		applyPrefs();

		FlxG.save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadData()
	{
		if (FlxG.save.data.showFPS != null)
			showFPS = FlxG.save.data.showFPS;
		if (FlxG.save.data.retroMode != null)
			retroMode = FlxG.save.data.retroMode;

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
