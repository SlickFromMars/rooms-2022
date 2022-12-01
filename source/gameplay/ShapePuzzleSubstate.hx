package gameplay;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class ShapePuzzleSubstate extends FrameSubState
{
	// Important variables and things
	public static var curWacky:Int = 0;
	public static var puzzleCombo:Array<Int> = [1, 2, 3, 4];
	public static var currentEntry:Array<Int> = [0, 0, 0, 0];

	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var funnyText:FlxSprite; // the title thingy
	var keyGrp:FlxTypedGroup<ShapePuzzleKey>; // All of the key thingies

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

		keyGrp = new FlxTypedGroup<ShapePuzzleKey>();
		add(keyGrp);

		for (i in 0...4)
		{
			var key = new ShapePuzzleKey(i);
			key.x = (i * 64) + 32;
			key.screenCenter(Y);
			keyGrp.add(key);
		}

		// set alphas
		bg.alpha = 0;
		funnyText.alpha = 0;

		// tween things and cameras
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
			trace('Closing the wacky shape puzzle.');
			close();
		}

		// Do the changing thingy
		if (FlxG.keys.anyJustPressed(CoolData.leftKeys) && PlayState.door.isOpen == false)
		{
			curWacky -= 1;
			if (curWacky < 0)
			{
				curWacky = 3;
			}
			changeAllKeys();
		}
		else if (FlxG.keys.anyJustPressed(CoolData.rightKeys) && PlayState.door.isOpen == false)
		{
			curWacky += 1;
			if (curWacky > 3)
			{
				curWacky = 0;
			}
			changeAllKeys();
		}
		else if (FlxG.keys.anyJustPressed(CoolData.downKeys) && PlayState.door.isOpen == false)
		{
			currentEntry[curWacky] -= 1;
			if (currentEntry[curWacky] < 0)
			{
				currentEntry[curWacky] = 3;
			}

			changeAllKeys();
			trace('Current combo is ' + ShapePuzzleSubstate.currentEntry);
		}
		else if (FlxG.keys.anyJustPressed(CoolData.upKeys) && PlayState.door.isOpen == false)
		{
			currentEntry[curWacky] += 1;
			if (currentEntry[curWacky] > 3)
			{
				currentEntry[curWacky] = 0;
			}

			changeAllKeys();
		}
	}

	function changeAllKeys()
	{
		// Update wacky anims
		updateAnims();

		// Open the door if the combo is correct
		if (puzzleCombo[0] == currentEntry[0] && puzzleCombo[1] == currentEntry[1] && puzzleCombo[2] == currentEntry[2] && puzzleCombo[3] == currentEntry[3])
		{
			// OPEN THE DOOR PLEASE
			PlayState.door.isOpen = true;

			// update to show that you got it
			updateAnims();
		}
	}

	function updateAnims()
	{
		keyGrp.forEach(function(key:ShapePuzzleKey)
		{
			key.updateAnim();
		});
	}

	public static function shuffleCombo()
	{
		currentEntry = [0, 0, 0, 0];

		for (i in 0...4)
		{
			puzzleCombo[i] = Std.random(4);
		}
		trace('The combo is ' + puzzleCombo);
	}
}
