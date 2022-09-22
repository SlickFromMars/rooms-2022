package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.Assets;

class Player extends FlxSprite
{
	public static var upKeys:Array<FlxKey> = [UP, W];
	public static var downKeys:Array<FlxKey> = [DOWN, S];
	public static var leftKeys:Array<FlxKey> = [LEFT, A];
	public static var rightKeys:Array<FlxKey> = [RIGHT, D];

	var up:Bool = false;
	var down:Bool = false;
	var left:Bool = false;
	var right:Bool = false;

	static inline var SPEED:Float = 175;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic(Paths.image('characters/cubee'), true, 16, 16);
		animation.add('d', [0], 4, true);
		animation.add('l', [1], 4, true);
		animation.add('r', [2], 4, true);
		animation.add('u', [3], 4, true);

		drag.x = drag.y = 1600;

		animation.play('r');
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}

	function updateMovement()
	{
		up = FlxG.keys.anyPressed(upKeys);
		down = FlxG.keys.anyPressed(downKeys);
		left = FlxG.keys.anyPressed(leftKeys);
		right = FlxG.keys.anyPressed(rightKeys);

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
