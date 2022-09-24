package;

import flixel.FlxSprite;

class Door extends FlxSprite
{
	public function new()
	{
		super(x, y);

		loadGraphic(Paths.image('props/door'), true, 16, 16);
		animation.add('closed', [0], 4, false);
		animation.add('open', [1], 4, false);

		animation.play('closed');
	}
}
