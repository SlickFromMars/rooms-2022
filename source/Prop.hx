package;

import flixel.FlxG;
import flixel.FlxSprite;

class Prop extends FlxSprite
{
	public var my_type:PropType; // The prop type

	// UNIQUE VARIABLES
	public var isOpen:Bool = true; // For the door
	public var hintType:String = "solution"; // For the hint
	public var launchDirection:String = "r"; // For the arrows
	public var launchDistance:Int = 5; // For the arrows

	public function new(x:Float, y:Float, type:PropType)
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
				var skinCount:Int = 2; // For easy addition
				loadGraphic(Paths.image('props/decor/bookshelf'), true, 16, 16);
				for (i in 0...skinCount)
				{
					animation.add(Std.string(i), [i], 4, true);
				}
				animation.play(Std.string(FlxG.random.int(0, skinCount - 1)));

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

			case BARRIER:
				loadGraphic(Paths.image('props/utils/barrier'));
				#if debug
				alpha = 0.1;
				#else
				alpha = 0;
				#end

				setSize(16, 16);

			case ARROW:
				loadGraphic(Paths.image('props/utils/arrows'), true, 16, 16);
				animation.add('u', [0], 4, false);
				animation.add('u_sel', [1], 4, false);
				animation.add('l', [2], 4, false);
				animation.add('l_sel', [3], 4, false);
				animation.add('d', [4], 4, false);
				animation.add('d_sel', [5], 4, false);
				animation.add('r', [6], 4, false);
				animation.add('r_sel', [7], 4, false);

				animation.play('u'); // Just for testing and stuff

				setSize(16, 16);

			default:
				// Kill the prop as an emergency fallback
				FlxG.log.warn('Unrecognized prop type ' + type);
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
	BARRIER;
	ARROW;
}
