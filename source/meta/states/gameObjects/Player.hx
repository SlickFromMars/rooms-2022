package meta.states.gameObjects;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	// Control variables
	var up:Bool = false;
	var down:Bool = false;
	var left:Bool = false;
	var right:Bool = false;

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
		// Check the keybinds
		up = Controls.PLAYER_UP;
		down = Controls.PLAYER_DOWN;
		left = Controls.PLAYER_LEFT;
		right = Controls.PLAYER_RIGHT;

		// Diagonal movement math
		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (up || down || left || right)
		{
			var newAngle:Float = 0;
			if (up)
			{
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
			}
			else if (left)
				newAngle = 180;
			else if (right)
				newAngle = 0;

			velocity.set(125, 0);
			velocity.pivotDegrees(FlxPoint.weak(0, 0), newAngle);
		}

		// Play animations
		if (right)
		{
			animation.play('r');
		}
		else if (left)
		{
			animation.play('l');
		}
		else if (up)
		{
			animation.play('u');
		}
		else if (down)
		{
			animation.play('d');
		}
	}
}
