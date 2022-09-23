package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxVirtualPad;

class PlayState extends FlxState
{
	var camGame:FlxCamera;
	var camUI:FlxCamera;

	var player:Player;

	public static var roomNumber:Int = 0;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var levelText:FlxText;

	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		camGame = new FlxCamera();
		camUI = new FlxCamera();
		camUI.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camUI, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		#if mobile
		virtualPad = new FlxVirtualPad(FULL, NONE);
		add(virtualPad);
		#end

		levelText = new FlxText(0, 5, 0, "LEVEL 1", 10);
		levelText.camera = camUI;

		reloadLevel();

		add(player);
		add(levelText);

		camGame.follow(player, TOPDOWN, 1);

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
		levelText.text = 'Level $roomNumber';

		var levelList:Array<String> = Paths.getText('_levels/$roomNumber.txt').split('\n');
		var tempLvl:String = levelList[Std.random(levelList.length)];

		map = new FlxOgmo3Loader(Paths.getOgmo(), Paths.json('_levels/$tempLvl'));
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

		player = new Player();

		map.loadEntities(placeEntities, "entites");
	}

	var stopCompleteSpam:Bool = false;

	public function completeLevel():Void
	{
		if (!stopCompleteSpam)
		{
			stopCompleteSpam = true;
		}
	}
}
