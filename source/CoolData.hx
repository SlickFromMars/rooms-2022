package;

import Prop.PropType;
import flixel.input.keyboard.FlxKey;

class CoolData
{
	// PROGRESS STUFF
	public static var roomNumber:Int = 1; // Room number

	// PREFS STUFF
	public static var overlayVisible:Bool = true; // overlay visible thingy

	// CONTROLS STUFF
	public static var upKeys:Array<FlxKey> = [UP, W]; // Control array to move up
	public static var downKeys:Array<FlxKey> = [DOWN, S]; // Control array to move down
	public static var leftKeys:Array<FlxKey> = [LEFT, A]; // Control array to move left
	public static var rightKeys:Array<FlxKey> = [RIGHT, D]; // Control array to move right

	public static var confirmKeys:Array<FlxKey> = [ENTER, E]; // Control array to confirm
	public static var backKeys:Array<FlxKey> = [ESCAPE, SPACE]; // Control array to go back
	public static var pauseKeys:Array<FlxKey> = [P, ESCAPE]; // Control array to pause

	public static var fullscreenKeys:Array<FlxKey> = [F, NUMPADONE, ONE, F11]; // Control array to toggle fullscreen

	public static var muteKeys:Array<FlxKey> = [NUMPADZERO, ZERO]; // Control array to mute
	public static var volumeDownKeys:Array<FlxKey> = [NUMPADMINUS, MINUS]; // Control array to lower volume
	public static var volumeUpKeys:Array<FlxKey> = [NUMPADPLUS, PLUS]; // Control array to raise volume

	// COLLISION STUFF
	public static var doTileCollision:Array<Int> = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]; // ID for each tile that the player should collide with
	public static var tileCount:Int = 27; // Amount of tiles in the tileset
	public static var allowPropCollision:Array<PropType> = [SHAPELOCK, HINT, KEY, ARROW]; // Props that ignore collision
}
