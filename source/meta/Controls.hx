package meta;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;

class Controls
{
	public static var CONTROL_SCHEME:ControlScheme = KEYBOARD;

	public static var PLAYER_X:Float = 0;
	public static var PLAYER_Y:Float = 0;
	public static var UI_UP:Bool = false;
	public static var UI_DOWN:Bool = false;
	public static var UI_LEFT:Bool = false;
	public static var UI_RIGHT:Bool = false;
	public static var CONFIRM:Bool = false;
	public static var CONFIRM_SECONDARY:Bool = false;
	public static var CONFIRM_TERTIARY:Bool = false;
	public static var BACK:Bool = false;
	public static var PAUSE:Bool = false;
	public static var FULLSCREEN:Bool = false;

	public static function updateKeys()
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
			if (CONTROL_SCHEME != GAMEPAD && gamepad.justPressed.ANY)
			{
				CONTROL_SCHEME = GAMEPAD;
				trace('GAMEPAD CONNECTED');
			}

		if (CONTROL_SCHEME != KEYBOARD && FlxG.keys.justPressed.ANY)
		{
			CONTROL_SCHEME = KEYBOARD;
			trace('KEYBOARD CONNECTED');
		}

		if (CONTROL_SCHEME == GAMEPAD && gamepad != null)
		{
			PLAYER_X = gamepad.analog.value.LEFT_STICK_X;
			PLAYER_Y = gamepad.analog.value.LEFT_STICK_Y;
			UI_UP = gamepad.justPressed.DPAD_UP;
			UI_DOWN = gamepad.justPressed.DPAD_DOWN;
			UI_LEFT = gamepad.justPressed.DPAD_LEFT;
			UI_RIGHT = gamepad.justPressed.DPAD_RIGHT;
			CONFIRM = gamepad.justPressed.X;
			CONFIRM_SECONDARY = gamepad.justPressed.Y;
			CONFIRM_TERTIARY = gamepad.justPressed.A;
			BACK = gamepad.justPressed.B;
			PAUSE = gamepad.justPressed.START;
			FULLSCREEN = false;
		}
		else if (CONTROL_SCHEME == KEYBOARD)
		{
			var up:Bool = FlxG.keys.anyPressed([FlxKey.UP, FlxKey.W]);
			var down:Bool = FlxG.keys.anyPressed([FlxKey.DOWN, FlxKey.S]);
			var left:Bool = FlxG.keys.anyPressed([FlxKey.LEFT, FlxKey.A]);
			var right:Bool = FlxG.keys.anyPressed([FlxKey.RIGHT, FlxKey.D]);
			if (up && down)
				up = down = false;
			if (left && right)
				left = right = false;

			var x:Float = 0;
			var y:Float = 0;
			if (up)
				y = -1;
			if (down)
				y = 1;
			if (left)
				x = -1;
			if (right)
				x = 1;

			PLAYER_X = x;
			PLAYER_Y = y;
			UI_UP = FlxG.keys.anyJustPressed([FlxKey.UP, FlxKey.W]);
			UI_DOWN = FlxG.keys.anyJustPressed([FlxKey.DOWN, FlxKey.S]);
			UI_LEFT = FlxG.keys.anyJustPressed([FlxKey.LEFT, FlxKey.A]);
			UI_RIGHT = FlxG.keys.anyJustPressed([FlxKey.RIGHT, FlxKey.D]);
			CONFIRM = FlxG.keys.anyJustPressed([FlxKey.ENTER, FlxKey.E]);
			CONFIRM_SECONDARY = FlxG.keys.anyJustPressed([FlxKey.TAB]);
			CONFIRM_TERTIARY = FlxG.keys.anyJustPressed([FlxKey.SHIFT]);
			BACK = FlxG.keys.anyJustPressed([FlxKey.ESCAPE, FlxKey.SPACE]);
			PAUSE = FlxG.keys.anyJustPressed([FlxKey.P, FlxKey.ESCAPE]);
			FULLSCREEN = FlxG.keys.anyJustPressed([FlxKey.F11]);
		}
	}
}

enum ControlScheme
{
	KEYBOARD;
	GAMEPAD;
}
