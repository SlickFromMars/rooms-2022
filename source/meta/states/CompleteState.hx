package meta.states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
#if DISCORD_RPC
import meta.Discord.DiscordClient;
#end

class CompleteState extends FrameState
{
	// The UI varaibles
	var winText:FlxText;

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
		winText = new FlxText(0, 0, 0, 'To Be Continued...\nYou escaped the dungeon.\nPress ENTER to return to the menu.', 8);
		winText.alignment = CENTER;
		winText.screenCenter();
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
		FlxG.sound.music.fadeOut(0.1);
		FlxG.camera.fade(FlxColor.BLACK, 0.1, false, function()
		{
			RoomsData.roomNumber = 1;
			FrameState.switchState(new TitleState());
		});
	}
}