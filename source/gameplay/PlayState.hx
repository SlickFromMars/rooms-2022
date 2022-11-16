package gameplay;

import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
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
	public static var shapeLock:Prop;
	public static var propGrp:FlxTypedGroup<Prop>;

	// The player variable
	var player:Player;

	// The UI stuff
	var levelText:FlxText;
	var denyText:FlxText;

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
		levelText.cameras = [camUI];

		denyText = new FlxText(0, FlxG.height * 0.8, "Denied.", 10);
		denyText.alignment = FlxTextAlign.CENTER;
		denyText.screenCenter(X);
		denyText.cameras = [camUI];
		denyText.alpha = 0;

		// Setup the level
		reloadLevel();

		// ADD THINGS
		add(levelText);
		add(denyText);

		// Finish setting up the camera
		camGame.follow(player, TOPDOWN, 1);
		super.create();

		// Play some music
		if (CoolData.roomNumber == 1)
		{
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('funkysuspense'), 0.7, true);
		}

		// Epic transition
		camUI.fade(FlxColor.BLACK, 0.1, true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// If debug is enabled, check to see if skip keys are pressed and then skip the current level
		#if debug
		if (FlxG.keys.anyJustPressed(CoolData.skipKeys))
		{
			completeLevel();
		}
		#end

		// Check if reset keys are pressed and then reset the current level
		if (FlxG.keys.anyJustPressed(CoolData.resetKeys))
		{
			FlxG.resetState();
		}

		// Collision stuff
		FlxG.collide(player, walls);

		if (shapeLock != null)
		{
			if (player.overlaps(shapeLock))
			{
				shapeLock.animation.play('hover');

				if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
				{
					openSubState(new ShapePuzzleSubstate());
				}
			}
			else
			{
				shapeLock.animation.play('normal');
			}
		}

		if (player.overlaps(door))
		{
			if (door.isOpen)
			{
				door.animation.play('open_s');

				if (!stopCompleteSpam && FlxG.keys.anyJustPressed(CoolData.confirmKeys))
				{
					completeLevel();
				}
			}
			else
			{
				door.animation.play('closed_s');

				if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
				{
					trace("DOOR IS LOCKED BOZO!!!");
					denyText.text = 'This door is locked.';
					denyText.screenCenter(X);
					denyText.alpha = 1;
					FlxTween.tween(denyText, {alpha: 0}, 2, {startDelay: 1});
				}
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
				door.isOpen = !entity.values.locked;
				add(door);

			case 'torch':
				var torch:Prop = new Prop(TORCH);
				torch.x = entity.x;
				torch.y = entity.y;
				propGrp.add(torch);

			case 'shapelock':
				shapeLock = new Prop(SHAPELOCK);
				shapeLock.x = entity.x - 8;
				shapeLock.y = entity.y;
				add(shapeLock);

			case 'crate':
				var crate:Prop = new Prop(CRATE);
				crate.x = entity.x + 4;
				crate.y = entity.y + 4;
				propGrp.add(crate);

			case 'barrel':
				var barrel:Prop = new Prop(BARREL);
				barrel.x = entity.x + 4;
				barrel.y = entity.y + 4;
				propGrp.add(barrel);

			default:
				trace('Unrecognized actor type ' + entity.name);
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
		map.loadEntities(placeEntities, "decor");
		map.loadEntities(placeEntities, "utils");
		add(player);
	}

	var stopCompleteSpam:Bool = false; // Stop people from breaking the level

	function completeLevel()
	{
		stopCompleteSpam = true;

		// TO THE NEXT LEVEL WOOOOOOOO
		CoolData.roomNumber += 1;

		// Fade to black and then figure out what to do
		camUI.fade(FlxColor.BLACK, 0.1, false, function()
		{
			// Check to see if a file exists, and then go to the next level if it does
			if (Paths.fileExists('data/_gen/' + CoolData.roomNumber + '.txt'))
			{
				FlxG.resetState();
			}
			else
			{
				FlxG.switchState(new menus.CompleteState());
			}
		});
	}
}
