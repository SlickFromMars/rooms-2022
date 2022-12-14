package gameplay;

import flixel.FlxSprite;

class Prop extends FlxSprite
{
	public var my_type:PropType; // The prop type

	// UNIQUE VARIABLES
	public var isOpen:Bool = true; // For the door
	public var hintType:String = "solution"; // For the hint

	public function new(type:PropType)
	{
		this.my_type = type;
		super(x, y);

		// Stop it from slipping and sliding around
		immovable = true;
		solid = true;

		// Based off the type, make the prop unique
		switch (type)
		{
			case DOOR:
				loadGraphic(Paths.image('props/utils/door'), true, 16, 16);
				animation.add('closed', [0], 4, false);
				animation.add('closed_s', [1], 4, false);
				animation.add('open', [2], 4, false);
				animation.add('open_s', [3], 4, false);

				animation.play('open');

				setSize(32, 32);
				offset.set(-8, 0);

			case TORCH:
				loadGraphic(Paths.image('props/decor/torch'), true, 16, 16);
				animation.add('idle', [1, 2, 3, 4], 4, true);

				animation.play('idle');
				animation.frameIndex = Std.random(3);

			case SHAPELOCK:
				loadGraphic(Paths.image('props/utils/shapepanel'), true, 16, 16);
				animation.add('normal', [0], 4, false);
				animation.add('hover', [1], 4, false);
				animation.add('complete', [2], 4, false);

				animation.play('normal');

				setSize(32, 32);
				offset.set(-8, 0);

			case CRATE:
				loadGraphic(Paths.image('props/decor/crate'));

				setSize(14, 14);
				offset.set(1, 1);

			case BARREL:
				loadGraphic(Paths.image('props/decor/barrel'));

				setSize(8, 12);
				offset.set(4, 2);

			case VASE:
				loadGraphic(Paths.image('props/decor/vase'));

				setSize(5, 5);
				offset.set(5, 5);

			case BOOKSHELF:
				loadGraphic(Paths.image('props/decor/bookshelf'));

				setSize(16, 16);

			case HINT:
				loadGraphic(Paths.image('props/utils/hint'), true, 16, 16);
				animation.add('normal', [0], 4, false);
				animation.add('hover', [1], 4, false);

				animation.play('normal');

				setSize(32, 32);
				offset.set(-8, -8);

			case KEY:
				loadGraphic(Paths.image('props/utils/key'), true, 16, 16);
				animation.add('normal', [0], 4, false);
				animation.add('hover', [1], 4, false);

				animation.play('normal');

				setSize(32, 32);
				offset.set(-8, -8);

			default:
				// Kill the prop as an emergency fallback
				trace('UNKNOWN PROP');
				kill();
		}
	}
}

// Different prop types
enum PropType
{
	DOOR;
	TORCH;
	SHAPELOCK;
	CRATE;
	BARREL;
	VASE;
	BOOKSHELF;
	HINT;
	KEY;
}
