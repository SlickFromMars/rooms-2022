package;

import meta.states.gameObjects.Prop.PropType;

class RoomsData
{
	// PROGRESS STUFF
	public static var roomNumber:Int = 1; // Room number

	// PREFS STUFF
	public static var retroMode:Bool = false; // whether to use the film filter

	// COLLISION STUFF
	public static var doTileCollision:Array<Int> = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 27, 28, 29, 30, 31, 32]; // ID for each tile that the player should collide with
	public static var tileCount:Int = 33; // Amount of tiles in the tileset
	public static var allowPropCollision:Array<PropType> = [SHAPELOCK, HINT, KEY, ARROW, FINALETRIP]; // Props that ignore collision
}
