package meta;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Controls
{
	public static var UP:Bool;
	public static var UP_P:Bool;
	public static var DOWN:Bool;
	public static var DOWN_P:Bool;
	public static var LEFT:Bool;
	public static var LEFT_P:Bool;
	public static var RIGHT:Bool;
	public static var RIGHT_P:Bool;
	public static var CONFIRM:Bool;
	public static var BACK:Bool;
	public static var PAUSE:Bool;
	public static var FULLSCREEN:Bool;

	public static function updateKeys()
	{
		UP = FlxG.keys.anyPressed([FlxKey.UP, FlxKey.W]);
		UP_P = FlxG.keys.anyJustPressed([FlxKey.UP, FlxKey.W]);
		DOWN = FlxG.keys.anyPressed([FlxKey.DOWN, FlxKey.S]);
		DOWN_P = FlxG.keys.anyJustPressed([FlxKey.DOWN, FlxKey.S]);
		LEFT = FlxG.keys.anyPressed([FlxKey.LEFT, FlxKey.A]);
		LEFT_P = FlxG.keys.anyJustPressed([FlxKey.LEFT, FlxKey.A]);
		RIGHT = FlxG.keys.anyPressed([FlxKey.RIGHT, FlxKey.D]);
		RIGHT_P = FlxG.keys.anyJustPressed([FlxKey.RIGHT, FlxKey.D]);
		CONFIRM = FlxG.keys.anyJustPressed([FlxKey.ENTER, FlxKey.E]);
		BACK = FlxG.keys.anyJustPressed([FlxKey.ESCAPE, FlxKey.SPACE]);
		PAUSE = FlxG.keys.anyJustPressed([FlxKey.P, FlxKey.ESCAPE]);
		FULLSCREEN = FlxG.keys.anyJustPressed([FlxKey.F11]);
	}
}
