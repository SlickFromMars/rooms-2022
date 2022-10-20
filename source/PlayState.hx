package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var camGame:FlxCamera;
	var camUI:FlxCamera;

	var player:Player;

	var door:Prop;

	public static var map:FlxOgmo3Loader;
	public static var walls:FlxTilemap;

	var levelText:FlxText;

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		#end

		camGame = new FlxCamera();
		camUI = new FlxCamera();
		camUI.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camUI, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		levelText = new FlxText(0, 5, 0, "LEVEL ???", 10);
		levelText.camera = camUI;

		reloadLevel();

		add(levelText);

		camGame.follow(player, TOPDOWN, 1);

		super.create();

		FlxG.sound.playMusic(Paths.music('funkysuspense'), 0.7, true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, walls);
		FlxG.collide(player, door, completeLevel);
	}

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				player.x = entity.x;
				player.y = entity.y;

			case "door":
				door = new Prop(DOOR);
				door.x = entity.x;
				door.y = entity.y;
				add(door);

			default:
				throw 'Unrecognized actor type ${entity.name}';
		}
	}

	public function reloadLevel():Void
	{
		levelText.text = 'Level $Progress.roomNumber';

		var levelList:Array<String> = Paths.getText('_gen/$Progress.roomNumber.txt').split('\n');
		var tempLvl:String = levelList[Std.random(levelList.length)];

		map = new FlxOgmo3Loader(Paths.getOgmo(), Paths.json('_levels/$tempLvl'));
		walls = map.loadTilemap(Paths.image('tileset'), "walls");
		walls.follow();

		for (i in 0...CoolData.doTileCollision.length)
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

		add(player);

		map.loadEntities(placeEntities, "entites");
	}

	var stopCompleteSpam:Bool = false;

	function completeLevel(player:Player, door:Prop)
	{
		if (!stopCompleteSpam && door.isOpen)
		{
			stopCompleteSpam = true;
			Progress.roomNumber += 1;
			FlxG.resetState();
		}
	}
}
