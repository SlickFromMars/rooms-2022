package gameplay;

import flixel.util.FlxColor;
import flixel.FlxSprite;

// Different prop types
enum PropType
{
	DOOR;
	TORCH;
	SHAPELOCK;
}

class Prop extends FlxSprite
{
	public var my_type:PropType; // The prop type

	// UNIQUE VARIABLES
	public var isOpen:Bool = true; // For the door

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
				animation.add('closed_s', [1], 4, false);
				animation.add('open', [2], 4, false);
				animation.add('open_s', [3], 4, false);

				animation.play('open');

				setSize(32, 32);
				offset.set(-8, 0);

			case TORCH:
				loadGraphic(Paths.image('props/torch'), true, 16, 16);
				animation.add('idle', [1, 2, 3, 4], 4, true);

				animation.play('idle');
				animation.frameIndex = Std.random(3);

			case SHAPELOCK:
				loadGraphic(Paths.image('props/shapepanel'), true, 16, 16);
				animation.add('normal', [0], 4, false);
				animation.add('hover', [1], 4, false);

				animation.play('normal');

				setSize(32, 32);
				offset.set(-8, 0);

			default:
				// Kill the prop as an emergency fallback
				trace('UNKNOWN PROP');
				kill();
		}
	}
}
