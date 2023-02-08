package meta;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;

class Controls
{
	public static var CONTROL_SCHEME:ControlScheme = KEYBOARD;

	public static var PLAYER_UP:Bool = false;
	public static var PLAYER_DOWN:Bool = false;
	public static var PLAYER_LEFT:Bool = false;
	public static var PLAYER_RIGHT:Bool = false;
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
			var up = gamepad.analog.value.LEFT_STICK_Y < 0;
			var down = gamepad.analog.value.LEFT_STICK_Y > 0;
			var left = gamepad.analog.value.LEFT_STICK_X < 0;
			var right = gamepad.analog.value.LEFT_STICK_X > 0;

			PLAYER_UP = gamepad.justPressed.DPAD_UP || up;
			PLAYER_DOWN = gamepad.justPressed.DPAD_DOWN || down;
			PLAYER_LEFT = gamepad.justPressed.DPAD_LEFT || left;
			PLAYER_RIGHT = gamepad.justPressed.DPAD_RIGHT || right;
			UI_UP = gamepad.justPressed.DPAD_UP || up;
			UI_DOWN = gamepad.justPressed.DPAD_DOWN || down;
			UI_LEFT = gamepad.justPressed.DPAD_LEFT || left;
			UI_RIGHT = gamepad.justPressed.DPAD_RIGHT || right;
			CONFIRM = gamepad.justPressed.X;
			CONFIRM_SECONDARY = gamepad.justPressed.Y;
			CONFIRM_TERTIARY = gamepad.justPressed.A;
			BACK = gamepad.justPressed.B;
			PAUSE = gamepad.justPressed.START;
			FULLSCREEN = false;
		}
		else if (CONTROL_SCHEME == KEYBOARD)
		{
			if (CONTROL_SCHEME != KEYBOARD)
				CONTROL_SCHEME = KEYBOARD;

			PLAYER_UP = FlxG.keys.anyPressed([FlxKey.UP, FlxKey.W]);
			PLAYER_DOWN = FlxG.keys.anyPressed([FlxKey.DOWN, FlxKey.S]);
			PLAYER_LEFT = FlxG.keys.anyPressed([FlxKey.LEFT, FlxKey.A]);
			PLAYER_RIGHT = FlxG.keys.anyPressed([FlxKey.RIGHT, FlxKey.D]);
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
