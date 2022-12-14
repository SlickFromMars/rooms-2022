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
import flixel.FlxSprite;

using StringTools;

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
	public static var player:Player;

	// The UI stuff
	var overlay:FlxSprite;
	var levelText:FlxText;
	var denyText:FlxText;

	override public function create()
	{
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

		// UI stuffs
		overlay = new FlxSprite();
		overlay.loadGraphic(Paths.image('overlay'));
		overlay.cameras = [camUI];

		levelText = new FlxText(0, 5, 0, "- LEVEL ??? -", 10);
		levelText.alignment = CENTER;
		levelText.screenCenter(X);
		levelText.cameras = [camUI];

		denyText = new FlxText(0, FlxG.height * 0.8, "Denied.", 10);
		denyText.alignment = FlxTextAlign.CENTER;
		denyText.screenCenter(X);
		denyText.cameras = [camUI];
		denyText.alpha = 0;

		// Setup the level
		reloadLevel();

		// ADD THINGS
		add(overlay);
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

		#if debug
		// If debug is enabled, check to see if skip keys are pressed and then skip the current level
		if (FlxG.keys.anyJustPressed(CoolData.skipKeys))
		{
			completeLevel();
		}

		// If debug is enabled, check to see if overlay keys are pressed and toggle overlay
		if (FlxG.keys.anyJustPressed(CoolData.overlayKeys))
		{
			CoolData.overlayShown = !CoolData.overlayShown;
		}
		#end

		// Collision stuff
		FlxG.collide(player, walls);

		// Update the overlay
		if (PlayState.player != null)
		{
			overlay.x = player.getScreenPosition().x - overlay.width / 2;
			overlay.y = player.getScreenPosition().y - overlay.height / 2;
		}
		else
		{
			overlay.screenCenter();
		}
		overlay.visible = CoolData.overlayShown;

		propGrp.forEach(function(spr:Prop)
		{
			// If this prop is to be ignored, ignore it
			if (!CoolData.allowPropCollision.contains(spr.my_type))
			{
				FlxG.collide(player, spr);
			}

			// Check for overlaps
			if (spr.my_type == SHAPELOCK)
			{
				if (player.overlaps(spr) && door.isOpen == false)
				{
					spr.animation.play('hover');

					if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
					{
						openSubState(new ShapePuzzleSubstate());
					}
				}
				else
				{
					if (door.isOpen == true)
					{
						spr.animation.play('complete');
					}
					else
					{
						spr.animation.play('normal');
					}
				}
			}
			else if (spr.my_type == HINT)
			{
				if (player.overlaps(spr) && door.isOpen == false)
				{
					spr.animation.play('hover');

					if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
					{
						openSubState(new HintSubstate(spr.hintType));
					}
				}
				else
				{
					spr.animation.play('normal');
				}
			}
			else if (spr.my_type == KEY)
			{
				if (player.overlaps(spr) && door.isOpen == false)
				{
					spr.animation.play('hover');

					if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
					{
						door.isOpen = true;
						spr.kill();

						trace("KEY LOCATED!!!!!!");
						denyText.text = 'Door has been unlocked.';
						denyText.screenCenter(X);
						denyText.alpha = 1;
						FlxTween.tween(denyText, {alpha: 0}, 2, {startDelay: 1});
					}
				}
				else
				{
					spr.animation.play('normal');
				}
			}
		});

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
		switch (entity.name)
		{
			case "player":
				player.x = entity.x + (16 - Player.physicsJSON.hitbox) / 2;
				player.y = entity.y + (16 - Player.physicsJSON.hitbox) / 2;

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
				var shapeLock = new Prop(SHAPELOCK);
				shapeLock.x = entity.x - 8;
				shapeLock.y = entity.y;
				propGrp.add(shapeLock);

				ShapePuzzleSubstate.shuffleCombo();

			case 'crate':
				var crate:Prop = new Prop(CRATE);
				crate.x = entity.x + 1;
				crate.y = entity.y + 1;
				propGrp.add(crate);

			case 'barrel':
				var barrel:Prop = new Prop(BARREL);
				barrel.x = entity.x + 4;
				barrel.y = entity.y + 2;
				propGrp.add(barrel);

			case 'vase':
				var vase:Prop = new Prop(VASE);
				vase.x = entity.x + 5;
				vase.y = entity.y + 5;
				propGrp.add(vase);

			case 'bookshelf':
				var bookshelf:Prop = new Prop(BOOKSHELF);
				bookshelf.x = entity.x;
				bookshelf.y = entity.y;
				propGrp.add(bookshelf);

			case 'hint':
				var hint:Prop = new Prop(HINT);
				hint.x = entity.x - 8;
				hint.y = entity.y - 8;
				hint.hintType = entity.values.hintType;
				propGrp.add(hint);

			case 'key':
				var key:Prop = new Prop(KEY);
				key.x = entity.x - 8;
				key.y = entity.y - 8;
				propGrp.add(key);

			default:
				trace('Unrecognized actor type ' + entity.name);
		}
		add(propGrp);
	}

	public function chooseLevel():String
	{
		var fullText:String = Paths.getText('_gen/' + Std.string(CoolData.roomNumber) + '.txt').trim();
		var swagArray:Array<String> = fullText.split('--');
		var swagItem:String = FlxG.random.getObject(swagArray);
		trace('Chose $swagItem from $swagArray');

		return swagItem;
	}

	public function reloadLevel()
	{
		// Reload the UI
		levelText.text = '- Room ' + CoolData.roomNumber + ' -';
		levelText.screenCenter(X);

		// Build the level
		var tempLvl:String = chooseLevel();

		map = new FlxOgmo3Loader(Paths.getOgmo(), Paths.json('_levels/$tempLvl'));
		walls = map.loadTilemap(Paths.image('tileset'), "walls");
		walls.follow(camGame);

		// Setup the collision
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

		// Finalize and add stuff
		add(walls);
		player = new Player();
		propGrp = new FlxTypedGroup<Prop>();
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
