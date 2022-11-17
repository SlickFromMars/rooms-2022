package gameplay;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;

class ShapePuzzleSubstate extends FlxSubState
{
	// Important variables and things
	public static var puzzleCombo:Array<Int> = [1, 2, 3, 4];

	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var funnyText:FlxSprite; // the title thingy

	public function new()
	{
		super();
		trace('Setting up the wacky shape puzzle.');

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		funnyText = new FlxText(0, 5, 0, "Shape Puzzle", 10);
		funnyText.screenCenter(X);
		funnyText.scrollFactor.set();
		add(funnyText);

		// set alphas
		bg.alpha = 0;
		funnyText.alpha = 0;

		// tween things
		FlxTween.tween(bg, {alpha: 0.6}, 0.3);
		FlxTween.tween(funnyText, {alpha: 1}, 0.5);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if (FlxG.keys.anyJustPressed(CoolData.backKeys))
		{
			trace('Closing the wacky shape puzzle');
			close();
		}
	}

	public static function shuffleCombo()
	{
		for (i in 0...4)
		{
			puzzleCombo[i] = Std.random(3);
		}
		trace('The combo is ' + puzzleCombo);
	}
}
