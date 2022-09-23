package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var roomNumber:Int = 0;
	var player:Player;

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		player = new Player();
		map.loadEntities(placeEntities, "entities");

		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);

		startRoom();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, walls);
	}

	function placeEntities(entity:EntityData)
	{
		if (entity.name == "player")
		{
			player.setPosition(entity.x, entity.y);
		}
	}

	public function startRoom()
	{
		roomNumber += 1;

		map = new FlxOgmo3Loader('assets/levels.ogmo', Paths.json('_levels/start.json'));
	}
}
