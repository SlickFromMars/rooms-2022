package gameplay;

import flixel.FlxSprite;

class ShapePuzzleKey extends FlxSprite
{
	public var id:Int = 0;

	public function new(iteration:Int)
	{
		// do the basic things
		id = iteration;
		super(x, y);

		// load the sprites
		loadGraphic(Paths.image('ui/shapekey'), true, 64, 64);
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
