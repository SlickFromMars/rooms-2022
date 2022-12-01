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
		animation.add('1', [2], 1, true);
		animation.add('1_sel', [3], 1, true);
		animation.add('2', [4], 1, true);
		animation.add('2_sel', [5], 1, true);
		animation.add('3', [6], 1, true);
		animation.add('3_sel', [7], 1, true);

		updateAnim();
	}

	public function updateAnim()
	{
		// Do the actual updating
		var suffix = '';

		if (PlayState.door.isOpen == true)
		{
			suffix = '_sel'; // temporary til I make a new anim
		}
		else if (id == ShapePuzzleSubstate.curWacky)
		{
			suffix = '_sel';
		}

		animation.play(Std.string(ShapePuzzleSubstate.currentEntry[id]) + suffix);
	}
}
