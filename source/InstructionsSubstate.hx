package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class InstructionsSubstate extends FrameSubState
{
	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var helpText:FlxText; // The sprite group that contains all stuff

	public function new()
	{
		super();

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		helpText = new FlxText(0, 0, 0, Paths.getText('data/keybinds.txt'), 8);
		helpText.alignment = CENTER;
		helpText.screenCenter();
		add(helpText);

		// set alphas
		bg.alpha = 0;
		helpText.alpha = 0;

		// tween things and cameras
		FlxTween.tween(bg, {alpha: 0.7}, 0.3);
		FlxTween.tween(helpText, {alpha: 1}, 0.3);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var stopSpam:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if (Controls.BACK || FlxG.keys.anyJustPressed([TAB]))
		{
			stopSpam = true;
			FlxTween.tween(helpText, {alpha: 0}, 0.3, {
				onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
		}
	}
}
