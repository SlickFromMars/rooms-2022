package;

import flixel.FlxSprite;

enum PropType
{
	DOOR;
	TORCH;
}

class Prop extends FlxSprite
{
	public var my_type:PropType;

	// DOOR STUFF
	public var isOpen:Bool = true;

	public function new(type:PropType)
	{
		this.my_type = type;
		super(x, y);

		switch (type)
		{
			case DOOR:
				loadGraphic(Paths.image('props/door'), true, 16, 16);
				animation.add('closed', [0], 4, false);
				animation.add('open', [1], 4, false);

				animation.play('open');

				setSize(16, 32);

			case TORCH:
				loadGraphic(Paths.image('props/torch'), true, 16, 16);
				animation.add('idle', [1, 2, 3, 4], 4, true);

				animation.play('idle');

			case _:
				trace('UNKNOWN PROP');
				kill();
		}
	}
}
