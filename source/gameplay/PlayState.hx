package gameplay;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import gameplay.Player;
import gameplay.Prop;
#if mobile
import flixel.ui.FlxVirtualPad;
#end

class PlayState extends FlxState
{
	var camGame:FlxCamera;
	var camUI:FlxCamera;

	public static var map:FlxOgmo3Loader;
	public static var walls:FlxTilemap;

	var player:Player;
	var door:Prop;
	var propGrp:FlxTypedGroup<Prop>;

	var levelText:FlxText;

	override public function create()
	{
		#if mobile
		public static var virtualPad:FlxVirtualPad;
		#end

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
		virtualPad.camera = camUI;
		add(virtualPad);
		#end

		levelText = new FlxText(0, 5, 0, "LEVEL ???", 10);
		levelText.camera = camUI;

		reloadLevel();

		add(levelText);

		camGame.follow(player, TOPDOWN, 1);

		super.create();

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music('funkysuspense'), 0.7, true);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, walls);

		FlxG.overlap(player, door, completeLevel);
	}

	function placeEntities(entity:EntityData)
	{
		propGrp = new FlxTypedGroup<Prop>();

		switch (entity.name)
		{
			case "player":
				player.x = entity.x + 4;
				player.y = entity.y + 4;

			case "door":
				door = new Prop(DOOR);
				door.x = entity.x - 8;
				door.y = entity.y;
				add(door);

			case 'torch':
				var torch:Prop = new Prop(TORCH);
				torch.x = entity.x;
				torch.y = entity.y;
				propGrp.add(torch);

			default:
				throw 'Unrecognized actor type ${entity.name}';
		}
		add(propGrp);
	}

	public function reloadLevel():Void
	{
		levelText.text = 'Level ' + CoolData.roomNumber;

		var levelList:Array<String> = Paths.getText('_gen/' + CoolData.roomNumber + '.txt').split('\n');
		var tempLvl:String = FlxG.random.getObject(levelList);
		trace('Chose $tempLvl from $levelList');

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

		map.loadEntities(placeEntities, "entites");

		add(player);
	}

	var stopCompleteSpam:Bool = false;

	function completeLevel(player:Player, door:Prop)
	{
		if (!stopCompleteSpam && door.isOpen && FlxG.keys.anyJustPressed(CoolData.confirmKeys))
		{
			stopCompleteSpam = true;
			CoolData.roomNumber += 1;
			if (Paths.fileExists('data/_gen/' + CoolData.roomNumber + '.txt'))
			{
				FlxG.resetState();
			}
			else
			{
				FlxG.switchState(new menus.CompleteState());
			}
		}
	}
}
