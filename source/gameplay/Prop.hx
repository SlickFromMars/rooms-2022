package gameplay;

import flixel.FlxSprite;

// Different prop types
enum PropType
{
	DOOR;
	TORCH;
}

class Prop extends FlxSprite
{
	public var my_type:PropType; // The prop type

	// DOOR STUFF
	public var isOpen:Bool = true;

	public function new(type:PropType)
	{
		this.my_type = type;
		super(x, y);

		// Based off the type, make the prop unique
		switch (type)
		{
			case DOOR:
				loadGraphic(Paths.image('props/door'), true, 16, 16);
				animation.add('closed', [0], 4, false);
				animation.add('open', [1], 4, false);

				animation.play('open');

				setSize(32, 32);
				offset.set(-8, 0);

			case TORCH:
				loadGraphic(Paths.image('props/torch'), true, 16, 16);
				animation.add('idle', [1, 2, 3, 4], 4, true);

				animation.play('idle');
				animation.frameIndex = Std.random(3);

			default:
				// Kill the prop as an emergency fallback
				trace('UNKNOWN PROP');
				kill();
		}
	}
}
