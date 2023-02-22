package meta.states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameState;
#if DISCORD_RPC
import meta.Discord.DiscordClient;
#end

class CompleteState extends FrameState
{
	// The UI varaibles
	var winText:FlxText; // the silly text

	override function create()
	{
		// Hide the mouse if there is one
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		#if DISCORD_RPC
		// Updating Discord Rich Presence.
		DiscordClient.changePresence('In The Completed Screen', null);
		#end

		// Setup the UI
		quickBG();

		winText = new FlxText(0, 0, FlxG.width, '', 8);
		updateUIText();
		winText.alignment = CENTER;
		winText.screenCenter(Y);
		winText.alpha = 0;

		add(winText);

		super.create();

		// Cool fade to make it smoother
		FlxG.camera.fade(FlxColor.WHITE, 5, true, function()
		{
			FlxTween.tween(winText, {alpha: 1}, 3, {startDelay: 1});
		});
	}

	override function update(elapsed:Float)
	{
		// Check to see if the player has confirmed
		if (Controls.CONFIRM && winText.alpha == 1)
		{
			pressStart();
		}

		super.update(elapsed);
	}

	function pressStart()
	{
		// Fade to black and then go to PlayState again
		FlxTween.tween(winText, {y: FlxG.height}, 1, {ease: FlxEase.quadIn});
		FlxG.sound.music.fadeOut(0.7);
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
		{
			RoomsData.roomNumber = 1;
			FrameState.switchState(new TitleState());
		});
	}

	override function updateUIText()
	{
		winText.text = 'To Be Continued...\nYou escaped the dungeon.\nPress ';
		switch (Controls.CONTROL_SCHEME)
		{
			case KEYBOARD:
				winText.text += 'ENTER';
			case GAMEPAD:
				winText.text += 'X';
		}
		winText.text += ' to return to the menu.';
	}
}
