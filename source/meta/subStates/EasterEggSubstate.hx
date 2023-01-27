package meta.subStates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class EasterEggSubstate extends FrameSubState
{
	var eggName:String;

	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var eggText:FlxText; // The sprite group that contains all stuff

	public function new(name:String)
	{
		eggName = name;

		super();

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		eggText = new FlxText(0, 0, 0, Paths.getText('data/_eggs/$name.txt'), 8);
		eggText.alignment = CENTER;
		eggText.screenCenter();
		add(eggText);

		// set alphas
		bg.alpha = 0;
		eggText.alpha = 0;

		// tween things and cameras
		FlxTween.tween(bg, {alpha: 1}, 0.3);
		FlxTween.tween(eggText, {alpha: 1}, 0.3);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var stopSpam:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check stuff
		if (Controls.CONFIRM)
		{
			switch (eggName.toUpperCase())
			{
				case 'BENSOUND':
					FlxG.openURL('https://www.bensound.com/');
				default:
					trace('CONFIRMED ON $eggName');
			}
		}
		else if (Controls.BACK)
		{
			stopSpam = true;
			FlxTween.tween(eggText, {alpha: 0}, 0.3, {
				onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
		}
	}
}
