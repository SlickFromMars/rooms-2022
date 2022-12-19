package gameplay;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class ShapePuzzleSubstate extends FrameSubState
{
	// Important variables and things
	public static var curWacky:Int = 0;
	public static var puzzleCombo:Array<Int> = [1, 2, 3, 4];
	public static var currentEntry:Array<Int> = [0, 0, 0, 0];

	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var tipText:FlxText; // Keybinds for bozos
	var funnyText:FlxSprite; // the title thingy
	var keyGrp:FlxTypedGroup<ShapePuzzleKey>; // All of the key thingies

	public function new()
	{
		super();

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

		tipText = new FlxText(0, 0, 0, Paths.getLang('shapePuzzleTip'), 8);
		tipText.y = FlxG.height - (tipText.height + 2);
		tipText.alignment = CENTER;
		tipText.screenCenter(X);
		add(tipText);

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
		FlxTween.tween(bg, {alpha: 0.7}, 0.3);
		FlxTween.tween(funnyText, {alpha: 1}, 0.5);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if (FlxG.keys.anyJustPressed(CoolData.backKeys))
		{
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
				currentEntry[curWacky] = 4;
			}

			changeAllKeys();
		}
		else if (FlxG.keys.anyJustPressed(CoolData.upKeys) && PlayState.door.isOpen == false)
		{
			currentEntry[curWacky] += 1;
			if (currentEntry[curWacky] > 4)
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
		if (puzzleCombo[0] == currentEntry[0] && puzzleCombo[1] == currentEntry[1] && puzzleCombo[2] == currentEntry[2]
			&& puzzleCombo[3] == currentEntry[3] && PlayState.door.isOpen == false)
		{
			// OPEN THE DOOR PLEASE
			PlayState.door.isOpen = true;
			trace('Shape puzzle complete.');

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

		shuffleComboFunc();
		while (puzzleCombo[0] == puzzleCombo[1] && puzzleCombo[0] == puzzleCombo[2] && puzzleCombo[0] == puzzleCombo[3])
		{
			trace('Improper combo ' + puzzleCombo);
			shuffleComboFunc();
		}
		trace('The combo is ' + puzzleCombo);
	}

	static function shuffleComboFunc()
	{
		for (i in 0...4)
		{
			puzzleCombo[i] = Std.random(5);
		}
	}
}

class ShapePuzzleKey extends FlxSprite
{
	public var id:Int = 0;

	public function new(iteration:Int)
	{
		// do the basic things
		id = iteration;
		super(x, y);

		// load the sprites
		loadGraphic(Paths.image('shapekey'), true, 64, 64);
		animation.add('0', [0], 1, true);
		animation.add('0_sel', [1], 1, true);
		animation.add('0_com', [2], 1, true);
		animation.add('1', [3], 1, true);
		animation.add('1_sel', [4], 1, true);
		animation.add('1_com', [5], 1, true);
		animation.add('2', [6], 1, true);
		animation.add('2_sel', [7], 1, true);
		animation.add('2_com', [8], 1, true);
		animation.add('3', [9], 1, true);
		animation.add('3_sel', [10], 1, true);
		animation.add('3_com', [11], 1, true);
		animation.add('4', [12], 1, true);
		animation.add('4_sel', [13], 1, true);
		animation.add('4_com', [14], 1, true);

		updateAnim();
	}

	public function updateAnim()
	{
		// Do the actual updating
		var suffix = '';

		if (PlayState.door.isOpen == true)
		{
			suffix = '_com';
		}
		else if (id == ShapePuzzleSubstate.curWacky)
		{
			suffix = '_sel';
		}

		animation.play(Std.string(ShapePuzzleSubstate.currentEntry[id]) + suffix);
	}
}
