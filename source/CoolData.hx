package;

import flixel.input.keyboard.FlxKey;

class CoolData
{
	// PROGRESS STUFF
	public static var roomNumber:Int = 1; // Room number

	// CONTROLS STUFF
	public static var upKeys:Array<FlxKey> = [UP, W]; // Control array to move up
	public static var downKeys:Array<FlxKey> = [DOWN, S]; // Control array to move down
	public static var leftKeys:Array<FlxKey> = [LEFT, A]; // Control array to move left
	public static var rightKeys:Array<FlxKey> = [RIGHT, D]; // Control array to move right

	public static var confirmKeys:Array<FlxKey> = [ENTER]; // Control array to confirm
	public static var backKeys:Array<FlxKey> = [ESCAPE]; // Control array to go back
	public static var resetKeys:Array<FlxKey> = [R]; // Control array to reset
	#if debug
	public static var skipKeys:Array<FlxKey> = [ONE]; // To skip levels in debug only
	#end
	public static var fullscreenKeys:Array<FlxKey> = [F]; // Control array to toggle fullscreen

	public static var muteKeys:Array<FlxKey> = [ZERO]; // Control array to mute
	public static var volumeDownKeys:Array<FlxKey> = [NUMPADMINUS, MINUS]; // Control array to lower volume
	public static var volumeUpKeys:Array<FlxKey> = [NUMPADPLUS, PLUS]; // Control array to raise volume

	// TILE STUFF
	public static var tileCount:Int = 15; // Amount of tiles
	public static var doTileCollision:Array<Int> = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]; // ID for each tile that the player should collide with
}
