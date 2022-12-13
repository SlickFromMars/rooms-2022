package;

import gameplay.Prop.PropType;
import flixel.input.keyboard.FlxKey;

class CoolData
{
	// PROGRESS STUFF
	public static var roomNumber:Int = 1; // Room number

	// MISC VARIABLES
	public static var overlayShown:Bool = true;

	// CONTROLS STUFF
	public static var upKeys:Array<FlxKey> = [UP]; // Control array to move up
	public static var downKeys:Array<FlxKey> = [DOWN]; // Control array to move down
	public static var leftKeys:Array<FlxKey> = [LEFT]; // Control array to move left
	public static var rightKeys:Array<FlxKey> = [RIGHT]; // Control array to move right

	public static var confirmKeys:Array<FlxKey> = [ENTER, Z]; // Control array to confirm
	public static var helpKeys:Array<FlxKey> = [TAB]; // Control array for the help screen
	public static var backKeys:Array<FlxKey> = [ESCAPE, X]; // Control array to go back

	public static var fullscreenKeys:Array<FlxKey> = [F, NUMPADONE, ONE, F11]; // Control array to toggle fullscreen
	public static var framesKeys:Array<FlxKey> = [NUMPADTWO, TWO]; // Control array to toggle FPS counter
	public static var skipKeys:Array<FlxKey> = [NUMPADTHREE, THREE]; // To skip levels in debug only
	public static var overlayKeys:Array<FlxKey> = [NUMPADFOUR, FOUR]; // To toggle dark overlay in debug only

	public static var muteKeys:Array<FlxKey> = [NUMPADZERO, ZERO]; // Control array to mute
	public static var volumeDownKeys:Array<FlxKey> = [NUMPADMINUS, MINUS]; // Control array to lower volume
	public static var volumeUpKeys:Array<FlxKey> = [NUMPADPLUS, PLUS]; // Control array to raise volume

	// COLLISION STUFF
	public static var doTileCollision:Array<Int> = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]; // ID for each tile that the player should collide with
	public static var tileCount:Int = 27; // Amount of tiles in the tileset
	public static var allowPropCollision:Array<PropType> = [SHAPELOCK, HINT, KEY]; // Props that ignore collision
}
