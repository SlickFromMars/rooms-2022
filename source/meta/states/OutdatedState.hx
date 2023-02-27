package meta.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameState;
#if DISCORD_RPC
import meta.Discord.DiscordClient;
#end

#if CHECK_FOR_UPDATES
class OutdatedState extends FrameState
{
	var leftState:Bool = false;

	public static var updateVersion:String = '';
	public static var updateState:CompResult = NONE;

	var warnText:FlxText;
	var sillySprite:FlxSprite;
	var sillyTween:FlxTween;

	override function create()
	{
		super.create();

		if (updateState == MUSTUPDATE)
		{
			#if DISCORD_RPC
			DiscordClient.changePresence('TELL THIS USER TO UPDATE', updateVersion + ' if ur curious');
			#end
		}

		quickBG();

		warnText = new FlxText(0, 0, FlxG.width, '', 14);
		warnText.alignment = CENTER;
		updateUIText();

		sillySprite = new FlxSprite(0, warnText.y + warnText.height - 30);
		sillySprite.loadGraphic(Paths.image('slickfrommars'));
		sillySprite.setGraphicSize(50);
		sillySprite.screenCenter(X);
		sillySprite.angle = -20;

		add(warnText);
		add(sillySprite);

		sillyTween = FlxTween.tween(sillySprite, {angle: 20}, 3, {type: PINGPONG, ease: FlxEase.quadInOut});

		FlxG.camera.fade(FlxColor.BLACK, 0.1, true);
	}

	override function update(elapsed:Float)
	{
		if (!leftState)
		{
			if (Controls.CONFIRM)
			{
				leftState = true;
				RoomsUtils.openURL("https://gamejolt.com/games/tsarooms/788793");
			}
			else if (Controls.BACK)
			{
				leftState = true;
			}

			if (leftState)
			{
				sillyTween.cancel();
				FlxTween.tween(sillySprite, {y: FlxG.height, angle: 0}, 1, {ease: FlxEase.quadIn});
				FlxTween.tween(warnText, {alpha: 0}, 1, {ease: FlxEase.quadIn});
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FrameState.switchState(new meta.states.OpeningState());
				});
			}
		}
		super.update(elapsed);
	}

	override function updateUIText()
	{
		if (updateState == MUSTUPDATE)
		{
			warnText.text = "Hey, looks like you're playing an\nold version of ROOMS ("
				+ Init.gameVersion
				+ "),\nplease update to "
				+ updateVersion
				+ "!";
		}
		else if (updateState == UNRELEASED)
		{
			warnText.text = "Hey, looks like you're playing an\nunreleased version of ROOMS ("
				+ Init.gameVersion
				+ ")\nThe latest stable release\nis "
				+ updateVersion
				+ "!";
		}

		warnText.text += "\nPress ";

		switch (Controls.CONTROL_SCHEME)
		{
			case KEYBOARD:
				warnText.text += 'ESC';
			case GAMEPAD:
				warnText.text += 'B';
		}
		warnText.text += ' To Proceed';

		warnText.screenCenter(Y);
	}
}
#end

enum CompResult
{
	NONE;
	MUSTUPDATE;
	UNRELEASED;
}
