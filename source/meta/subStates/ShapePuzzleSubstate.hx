package meta.subStates;

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
	var keyGrp:FlxTypedGroup<ShapePuzzleKey>; // All of the key thingies

	var upScroll:Bool;
	var downScroll:Bool;

	public function new()
	{
		super();

		// setup the UI
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		var funnyText:FlxText = new FlxText(0, 5, 0, "Shape Puzzle", 10);
		funnyText.screenCenter(X);
		funnyText.scrollFactor.set();
		add(funnyText);

		keyGrp = new FlxTypedGroup<ShapePuzzleKey>();
		add(keyGrp);

		var tipText:FlxText = new FlxText(0, 0, 0,
			'Use LEFT And RIGHT to Select Shapes\nUse UP and DOWN to Cycle Shapes\nIf Your Entry Is Correct The Shapes Will Become Green', 8);
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
		FlxTween.tween(bg, {alpha: 1}, 0.3);
		FlxTween.tween(funnyText, {alpha: 1}, 0.5);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		upScroll = FlxG.mouse.wheel > 0;
		downScroll = FlxG.mouse.wheel < 0;

		// Check to see if the player wants to exit
		if (Controls.BACK)
		{
			close();
		}

		// Do the changing thingy
		if (Controls.LEFT_P && !meta.states.PlayState.door.isOpen)
		{
			curWacky -= 1;
			if (curWacky < 0)
			{
				curWacky = 3;
			}
			changeAllKeys();
		}
		else if (Controls.RIGHT_P && !meta.states.PlayState.door.isOpen)
		{
			curWacky += 1;
			if (curWacky > 3)
			{
				curWacky = 0;
			}
			changeAllKeys();
		}
		else if ((Controls.DOWN_P || upScroll) && !meta.states.PlayState.door.isOpen)
		{
			currentEntry[curWacky] -= 1;
			if (currentEntry[curWacky] < 0)
			{
				currentEntry[curWacky] = 4;
			}

			changeAllKeys();
		}
		else if ((Controls.UP_P || downScroll) && !meta.states.PlayState.door.isOpen)
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
			&& puzzleCombo[3] == currentEntry[3] && !meta.states.PlayState.door.isOpen)
		{
			// OPEN THE DOOR PLEASE
			meta.states.PlayState.door.isOpen = true;

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

		if (meta.states.PlayState.door.isOpen)
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
