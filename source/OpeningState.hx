package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class OpeningState extends FrameState
{
	var text1:FlxText;
	var text2:FlxText;
	var skipText:FlxText;

	override function create()
	{
		FlxG.mouse.visible = false;

		text1 = new FlxText(0, FlxG.height / 2, FlxG.width, 'You have fallen into the Everchanging Dungeon.', 10);
		text1.y -= text1.height * 1.5;
		text1.alignment = CENTER;
		text1.alpha = 0;
		text2 = new FlxText(0, text1.y + text1.height * 1.5, FlxG.width, 'Complete puzzles to escape.', text1.size);
		text2.alignment = text1.alignment;
		text2.alpha = text1.alpha;

		skipText = new FlxText(FlxG.width, FlxG.height, 0, 'Press ENTER To Skip', 8);
		skipText.x -= skipText.width;
		skipText.y -= skipText.height;
		skipText.alpha = text2.alpha;

		add(text1);
		add(text2);
		add(skipText);

		super.create();

		FlxG.sound.playMusic(Paths.music('newdawn'), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.7);

		FlxTween.tween(text1, {alpha: 1}, 2, {
			startDelay: 1,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(text2, {alpha: 1}, 2, {
					startDelay: 5,
					onComplete: function(twn:FlxTween)
					{
						FlxTween.tween(text1, {alpha: 0}, 3, {
							startDelay: 5
						});
						FlxTween.tween(text2, {alpha: 0}, 3, {
							startDelay: 5,
							onComplete: function(twn:FlxTween)
							{
								FrameState.switchState(new TitleState());
							}
						});
					}
				});
			}
		});
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
		{
			if (skipText.alpha == 0)
			{
				skipText.alpha = 1;
			}
			else
			{
				skipState();
			}
		}
		super.update(elapsed);
	}

	var stopSpam:Bool = false;

	function skipState():Void
	{
		if (stopSpam == false)
		{
			stopSpam = true;

			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
			{
				FlxG.sound.music.volume = 0.7;
				FrameState.switchState(new TitleState());
			});
		}
	}
}
