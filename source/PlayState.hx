package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxVirtualPad;

class PlayState extends FlxState
{
	var player:Player;

	public static var roomNumber:Int = 0;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		#if mobile
		virtualPad = new FlxVirtualPad(FULL, NONE);
		add(virtualPad);
		#end

		reloadLevel();

		player = new Player();
		map.loadEntities(placeEntities, "entites");

		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, walls);
	}

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				player.x = entity.x;
				player.y = entity.y;
			default:
				throw 'Unrecognized actor type ${entity.name}';
		}
	}

	public function reloadLevel():Void
	{
		roomNumber += 1;

		map = new FlxOgmo3Loader(Paths.getOgmo(), Paths.json('_levels/start'));
		walls = map.loadTilemap(Paths.image('tileset'), "walls");
		walls.follow();

		for (i in 0...CoolData.tileCount)
		{
			if (CoolData.doTileCollision.contains(i))
			{
				walls.setTileProperties(i, ANY);
			}
			else
			{
				walls.setTileProperties(i, NONE);
			}
		}

		add(walls);
	}
}
