package meta.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameState;

#if CHECK_FOR_UPDATES
class OutdatedState extends FrameState
{
	var leftState:Bool = false;

	public static var updateVersion:String = '';

	var warnText:FlxText;
	var sillySprite:FlxSprite;

	override function create()
	{
		super.create();

		warnText = new FlxText(0, 0, FlxG.width, '', 14);
		warnText.alignment = CENTER;
		updateUIText();
		add(warnText);

		sillySprite = new FlxSprite(0, warnText.y + warnText.height - 30);
		sillySprite.loadGraphic(Paths.image('slickfrommars'));
		sillySprite.setGraphicSize(50);
		sillySprite.screenCenter(X);
		sillySprite.angle = -20;
		add(sillySprite);

		FlxTween.tween(sillySprite, {angle: 20}, 3, {type: PINGPONG, ease: FlxEase.quadInOut});

		FlxG.camera.fade(FlxColor.BLACK, 0.1, true);
	}

	override function update(elapsed:Float)
	{
		if (!leftState)
		{
			if (Controls.CONFIRM)
			{
				leftState = true;
				RoomsUtils.openURL("https://github.com/SlickFromMars/rooms-2022");
			}
			else if (Controls.BACK)
			{
				leftState = true;
			}

			if (leftState)
			{
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function(twn:FlxTween)
					{
						FrameState.switchState(new meta.states.OpeningState());
					}
				});
			}
		}
		super.update(elapsed);
	}

	override function updateUIText()
	{
		warnText.text = "Hey, looks like you're playing an\nold version of ROOMS ("
			+ Init.gameVersion
			+ "),\nplease update to "
			+ updateVersion
			+ "!\nPress ";

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
