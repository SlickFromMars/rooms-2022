package gameplay;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import gameplay.Player;
import gameplay.Prop;
#if mobile
import flixel.ui.FlxVirtualPad;
#end

class PlayState extends FrameState
{
	// Camera stuff
	var camGame:FlxCamera;
	var camUI:FlxCamera;

	// The world variables
	public static var map:FlxOgmo3Loader;
	public static var walls:FlxTilemap;
	public static var door:Prop;
	public static var propGrp:FlxTypedGroup<Prop>;

	// The player variable
	var player:Player;

	// The UI stuff
	var levelText:FlxText;

	override public function create()
	{
		// Initialize virtual pad if on mobile
		#if mobile
		public static var virtualPad:FlxVirtualPad;
		#end

		// Hide the mouse if there is one
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		// Set up the cameras
		camGame = new FlxCamera();
		camUI = new FlxCamera();
		camUI.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camUI, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		// Finish setting up the virtual pad if on mobile
		#if mobile
		virtualPad = new FlxVirtualPad(FULL, NONE);
		virtualPad.camera = camUI;
		add(virtualPad);
		#end

		// UI stuffs
		levelText = new FlxText(0, 5, 0, "LEVEL ???", 10);
		levelText.camera = camUI;

		// Setup the level
		reloadLevel();

		// ADD THINGS
		add(levelText);
		// Finish setting up the camera
		camGame.follow(player, TOPDOWN, 1);
		super.create();
		// Play some music
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music('funkysuspense'), 0.7, true);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Collision stuff
		FlxG.collide(player, walls);

		if (player.overlaps(door))
		{
			if (door.isOpen)
			{
				door.animation.play('open_s');
			}
			else
			{
				door.animation.play('closed_s');
			}

			if (!stopCompleteSpam && door.isOpen && FlxG.keys.anyJustPressed(CoolData.confirmKeys))
			{
				FlxG.overlap(player, door, completeLevel);
			}
		}
		else
		{
			if (door.isOpen)
			{
				door.animation.play('open');
			}
			else
			{
				door.animation.play('closed');
			}
		}
	}

	function placeEntities(entity:EntityData) // Setup the props
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
		// Reload the UI
		levelText.text = 'Level ' + CoolData.roomNumber;

		// Randomize the level
		var levelList:Array<String> = Paths.getText('_gen/' + CoolData.roomNumber + '.txt').split('\n');
		var tempLvl:String = FlxG.random.getObject(levelList);
		trace('Chose $tempLvl from $levelList');

		// Build the level
		map = new FlxOgmo3Loader(Paths.getOgmo(), Paths.json('_levels/$tempLvl'));
		walls = map.loadTilemap(Paths.image('tileset'), "walls");
		walls.follow();

		// Setup the collision
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

		// Finalize and add stuff
		add(walls);
		player = new Player();
		map.loadEntities(placeEntities, "entites");
		add(player);
	}

	var stopCompleteSpam:Bool = false; // Stop people from breaking the level

	function completeLevel(player:Player, door:Prop)
	{
		stopCompleteSpam = true;

		// TO THE NEXT LEVEL WOOOOOOOO
		CoolData.roomNumber += 1;

		// Check to see if a file exists, and then go to the next level if it does
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
