package meta.states.gameObjects;

import flixel.FlxSprite;

class Player extends FlxSprite
{
	var speed:Float = 125;

	public var lockMovement:Bool = true;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// Load the sprites and animations
		loadGraphic(Paths.image('player'), true, 16, 16);
		animation.add('d', [0], 4, true);
		animation.add('l', [1], 4, true);
		animation.add('r', [2], 4, true);
		animation.add('u', [3], 4, true);

		animation.play('r');

		// Setup the physics
		drag.x = drag.y = 1600;
		setSize(8, 8);
		offset.set((16 - width) / 2, (16 - height) / 2);
		angle = 0;
	}

	override function update(elapsed:Float)
	{
		// Update the movement
		if (!lockMovement)
		{
			updateMovement();
		}

		super.update(elapsed);
	}

	function updateMovement()
	{
		var velX = Controls.PLAYER_X;
		var velY = Controls.PLAYER_Y;

		if (velX != 0 || velY != 0)
		{
			if (velX != 0 && velY != 0)
			{
				velX = velX * 0.7;
				velY = velY * 0.7;
			}

			velocity.set(velX * speed, velY * speed);
		}

		// Play animations
		if (velY < 0)
			animation.play('u');
		else if (velY > 0)
			animation.play('d');
		else if (velX < 0)
			animation.play('l');
		else if (velX > 0)
			animation.play('r');
	}
}
