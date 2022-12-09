package menus;

import lime.app.Application;
import flixel.effects.FlxFlicker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TitleState extends FrameState
{
	// UI variables
	var logo:FlxSprite; // The wacky logo
	var beginText:FlxText; // The prompt to press start
	var versionText:FlxText; // The version

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
		logo.loadGraphic(Paths.image('ui/logo'));
		logo.antialiasing = true;
		logo.screenCenter();

		beginText = new FlxText(0, FlxG.height - 60, 0, Paths.getText('en_us/start.txt'), 8);
		beginText.alignment = CENTER;
		beginText.screenCenter(X);
		add(beginText);

		versionText = new FlxText(2, FlxG.height - 12, 0, Application.current.meta.get('version'), 8);
		add(versionText);

		add(beginText);
		add(logo);

		super.create();

		// Play some music
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music('november'), 0.7);
		}

		// Epic transition
		FlxG.camera.fade(FlxColor.BLACK, 3, true);
	}

	var stopSpam:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player has confirmed
		if (FlxG.keys.anyJustPressed(CoolData.confirmKeys) && stopSpam == false)
		{
			// Stop people from spamming the button
			stopSpam = true;

			// Do Funky Effects and then go to PlayState
			FlxG.sound.music.fadeOut(1.1);

			FlxFlicker.flicker(beginText, 1.1, 0.15, false, true, function(flick:FlxFlicker)
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.1, false, function()
				{
					FlxG.switchState(new gameplay.PlayState());
				});
			});
		}
	}
}
