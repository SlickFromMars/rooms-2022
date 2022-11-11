package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TitleState extends FrameState
{
	// UI variables
	var logo:FlxSprite;
	var beginText:FlxText;

	override public function create()
	{
		// Show the mouse if there is one
		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		#end

		// Initiate the volume keys
		FlxG.sound.muteKeys = CoolData.muteKeys;
		FlxG.sound.volumeDownKeys = CoolData.volumeDownKeys;
		FlxG.sound.volumeUpKeys = CoolData.volumeUpKeys;

		// Setup the UI
		logo = new FlxSprite();
		logo.loadGraphic(Paths.image('logo'));
		logo.antialiasing = true;
		logo.screenCenter();

		beginText = new FlxText(0, FlxG.height - 60, 0, "PRESS ENTER TO BEGIN", 8);
		beginText.screenCenter(X);
		add(beginText);

		add(beginText);
		add(logo);

		super.create();

		FlxG.camera.fade(FlxColor.BLACK, 3, true);
	}

	override public function update(elapsed:Float)
	{
		// Check to see if the player has confirmed
		if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
		{
			pressStart();
		}

		super.update(elapsed);
	}

	function pressStart()
	{
		// Fade to black and then go to PlayState
		FlxG.camera.fade(FlxColor.BLACK, 0.1, false, function()
		{
			FlxG.switchState(new gameplay.PlayState());
		});
	}
}
