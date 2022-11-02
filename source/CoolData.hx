package;

import flixel.input.keyboard.FlxKey;

class CoolData
{
	public static var roomNumber:Int = 1; // Room number

	public static var upKeys:Array<FlxKey> = [UP, W]; // Control array to move up
	public static var downKeys:Array<FlxKey> = [DOWN, S]; // Control array to move down
	public static var leftKeys:Array<FlxKey> = [LEFT, A]; // Control array to move left
	public static var rightKeys:Array<FlxKey> = [RIGHT, D]; // Control array to move right
	public static var confirmKeys:Array<FlxKey> = [ENTER]; // Control array to confirm

	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO]; // Control array to mute
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS]; // Control array to lower volume
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS]; // Control array to raise volume

	// TILE STUFF
	public static var tileCount:Int = 15; // Amount of tiles
	public static var doTileCollision:Array<Int> = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]; // ID for each tile that the player should collide with
}
