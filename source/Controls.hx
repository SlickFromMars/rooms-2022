package;

import flixel.input.keyboard.FlxKey;

class Controls
{
	// GAMEPLAY
	public static var upKeys:Array<FlxKey> = [UP, W];
	public static var downKeys:Array<FlxKey> = [DOWN, S];
	public static var leftKeys:Array<FlxKey> = [LEFT, A];
	public static var rightKeys:Array<FlxKey> = [RIGHT, D];
	public static var confirmKeys:Array<FlxKey> = [ENTER];

	// VOLUME
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
}
