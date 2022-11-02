package gameplay;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	// Control variables
	var up:Bool = false;
	var down:Bool = false;
	var left:Bool = false;
	var right:Bool = false;

	// Basic moddable variables
	static inline var SPEED:Float = 150;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// Load the sprites and animations
		loadGraphic(Paths.image('player'), true, 16, 16);
		animation.add('d', [0], 4, true);
		animation.add('l', [1], 4, true);
		animation.add('r', [2], 4, true);
		animation.add('u', [3], 4, true);

		// Setup the physics
		drag.x = drag.y = 1600;
		setSize(8, 8);
		offset.set(4, 4);

		animation.play('r');
	}

	override function update(elapsed:Float)
	{
		// Update the movement
		updateMovement();

		super.update(elapsed);
	}

	function updateMovement()
	{
		// If on desktop, check the keybids
		#if FLX_KEYBOARD
		up = FlxG.keys.anyPressed(CoolData.upKeys);
		down = FlxG.keys.anyPressed(CoolData.downKeys);
		left = FlxG.keys.anyPressed(CoolData.leftKeys);
		right = FlxG.keys.anyPressed(CoolData.rightKeys);
		#end

		// If on mobile, check the virtual pad
		#if mobile
		var virtualPad = PlayState.virtualPad;
		up = up || virtualPad.buttonUp.pressed;
		down = down || virtualPad.buttonDown.pressed;
		left = left || virtualPad.buttonLeft.pressed;
		right = right || virtualPad.buttonRight.pressed;
		#end

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

			velocity.set(SPEED, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);
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
