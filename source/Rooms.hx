package;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class Rooms
{
	public static function loadRoomFromJSON(key:String)
	{
		var map = PlayState.map;
		var walls = PlayState.walls;
		map = new FlxOgmo3Loader(Paths.getOgmo(), Paths.json('_levels/$key'));
		walls = map.loadTilemap(Paths.image('tileset'), "walls");
		walls.follow();
	}
}
