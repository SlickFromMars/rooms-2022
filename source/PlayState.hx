package;

import Player;
import Prop;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import particles.JumpEmitter;

using StringTools;

#if DISCORD_RPC
import Discord.DiscordClient;
#end

class PlayState extends FrameState
{
	// Camera stuff
	var camGame:FlxCamera;
	var camUI:FlxCamera;

	// The world variables
	public static var map:FlxOgmo3Loader;
	public static var walls:FlxTilemap;
	public static var walls2:FlxTilemap;

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

		denyText = new FlxText(0, FlxG.height * 0.8, 0, "Denied.", 10);
		denyText.alignment = CENTER;
		denyText.screenCenter(X);
		denyText.cameras = [camUI];
		denyText.alpha = 0;

		levelText.text = '- Room ' + CoolData.roomNumber + ' -';
		levelText.screenCenter(X);

		// Build the level
		var fullText:String = Paths.getText('data/_gen/' + Std.string(CoolData.roomNumber) + '.txt').trim();
		var swagArray:Array<String> = fullText.split('\n');
		for (i in 0...swagArray.length)
		{
			swagArray[i] = swagArray[i].trim();
		}
		var swagItem:String = FlxG.random.getObject(swagArray);
		trace('Chose $swagItem from $swagArray');

		map = new FlxOgmo3Loader(Paths.getOgmo(), Paths.json('_levels/$swagItem'));
		walls = map.loadTilemap(Paths.image('tileset'), "walls");
		walls.follow(camGame);
		walls2 = map.loadTilemap(Paths.image('tileset'), "no_collision");

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
		add(walls2);
		player = new Player();
		propGrp = new FlxTypedGroup<Prop>();
		map.loadEntities(placeEntities, "decor");
		map.loadEntities(placeEntities, "utils");
		add(player);
		add(overlay);
		add(levelText);
		add(denyText);

		// Finish setting up the camera
		camGame.follow(player, TOPDOWN_TIGHT, 1);

		#if DISCORD_RPC
		// Updating Discord Rich Presence.
		var stateText:String = '';
		switch (CoolData.roomNumber)
		{
			case 1:
				stateText = 'Learning How To Play';
			case 2:
				stateText = 'Finding A Key';
			case 3:
				stateText = 'Solving A Shape Puzzle';
			case 4:
				stateText = 'Crossing The Chasm';
		}
		DiscordClient.changePresence('On Room ' + CoolData.roomNumber, stateText);
		#end

		super.create();
		stopCompleteSpam = false;

		// Play some music
		if (CoolData.roomNumber == 1)
		{
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('november'), 0.7, true);
		}

		// Epic transition
		camUI.fade(FlxColor.BLACK, 0.1, true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player needs help
		if (FlxG.keys.anyJustPressed(CoolData.pauseKeys))
		{
			openSubState(new PauseSubState());
		}

		// Collision stuff
		checkPlayerCollision();

		// Update the overlay
		if (PlayState.player != null)
		{
			overlay.x = PlayState.player.getScreenPosition().x - overlay.width / 2;
			overlay.y = PlayState.player.getScreenPosition().y - overlay.height / 2;
		}
		else
		{
			overlay.screenCenter();
		}
		visible = CoolData.overlayVisible;
	}

	function checkPlayerCollision()
	{
		// walls blah blah blah
		FlxG.collide(player, walls);

		// props blah blah blah
		var isTouching:Bool = false;
		propGrp.forEach(function(spr:Prop)
		{
			// If this prop is to be ignored, ignore it
			if (!CoolData.allowPropCollision.contains(spr.my_type) && player.lockMovement == false)
			{
				FlxG.collide(player, spr);
			}

			// Check for overlaps
			if (spr.my_type == ARROW)
			{
				if (player.overlaps(spr) && isTouching == false && player.lockMovement == false)
				{
					isTouching = true;
					spr.animation.play(spr.launchDirection + '_sel');

					if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
					{
						player.lockMovement = true;

						// smoothly set position and then do the thing
						FlxTween.tween(player, {x: spr.x + player.offset.x, y: spr.y + player.offset.y}, 0.05, {
							onComplete: function(twn:FlxTween)
							{
								player.animation.play(spr.launchDirection);

								// start the funky particles
								var emitter:JumpEmitter = new JumpEmitter(spr.x + player.offset.x, spr.y + player.offset.y);
								emitter.start(true);
								add(emitter);

								// do the movement stuff
								var xChange:Float = 0;
								var yChange:Float = 0;
								var spin:Float = 360;
								switch (spr.launchDirection)
								{
									case 'u':
										yChange = spr.launchDistance * -16;
										spin *= -1;
									case 'l':
										xChange = spr.launchDistance * -16;
										spin *= -1;
									case 'd':
										yChange = spr.launchDistance * 16;
									case 'r':
										xChange = spr.launchDistance * 16;
								}
								FlxTween.tween(player, {x: (player.x + xChange), y: (player.y + yChange), angle: spin}, spr.launchDistance / 10, {
									onComplete: function(twn:FlxTween)
									{
										player.angle = 0;
										player.lockMovement = false;
									}
								});
							}
						});
					}
				}
				else
				{
					spr.animation.play(spr.launchDirection);
				}
			}
			else if (spr.my_type == SHAPELOCK)
			{
				if (player.overlaps(spr) && door.isOpen == false && player.lockMovement == false)
				{
					isTouching = true;
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
				if (player.overlaps(spr) && player.lockMovement == false)
				{
					isTouching = true;
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
				if (player.overlaps(spr) && door.isOpen == false && player.lockMovement == false)
				{
					isTouching = true;
					spr.animation.play('hover');

					if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
					{
						door.isOpen = true;
						spr.kill();

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

		if (player.overlaps(door) && isTouching == false)
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
		var startX = entity.x;
		var startY = entity.y;

		switch (entity.name)
		{
			case "player":
				player.setPosition(startX + (16 - player.width) / 2, startY + (16 - player.height) / 2);

			case "door":
				door = new Prop(startX - 8, startY, DOOR);
				door.isOpen = !entity.values.locked;
				add(door);

			case 'torch':
				propGrp.add(new Prop(startX, startY, TORCH));

			case 'shapelock':
				propGrp.add(new Prop(startX - 8, startY, SHAPELOCK));
				ShapePuzzleSubstate.shuffleCombo();

			case 'crate':
				propGrp.add(new Prop(startX + 1, startY + 1, CRATE));

			case 'barrel':
				propGrp.add(new Prop(startX + 4, startY + 2, BARREL));

			case 'vase':
				propGrp.add(new Prop(startX + 5, startY + 5, VASE));

			case 'bookshelf':
				propGrp.add(new Prop(startX, startY, BOOKSHELF));

			case 'hint':
				var hint:Prop = new Prop(startX - 8, startY - 8, HINT);
				hint.hintType = entity.values.hintType;
				propGrp.add(hint);

			case 'key':
				propGrp.add(new Prop(startX - 8, startY - 8, KEY));

			case 'barrier':
				propGrp.add(new Prop(startX, startY, BARRIER));

			case 'arrowU' | 'arrowL' | 'arrowD' | 'arrowR':
				var arrow:Prop = new Prop(startX, startY, ARROW);
				arrow.launchDirection = entity.name.charAt(5).toLowerCase();
				arrow.launchDistance = entity.values.launch;
				propGrp.add(arrow);

			default:
				FlxG.log.warn('Unrecognized actor type ' + entity.name);
		}
		add(propGrp);
	}

	static var stopCompleteSpam:Bool = false; // Stop people from breaking the level

	public static function completeLevel()
	{
		stopCompleteSpam = true;

		// TO THE NEXT LEVEL WOOOOOOOO
		CoolData.roomNumber += 1;

		// Fade to black and then figure out what to do
		FlxG.cameras.list[FlxG.cameras.list.length - 1].fade(FlxColor.BLACK, 0.1, false, function()
		{
			// Check to see if a file exists, and then go to the next level if it does
			if (Paths.fileExists('data/_gen/' + CoolData.roomNumber + '.txt'))
			{
				FlxG.resetState();
			}
			else
			{
				FlxG.sound.music.fadeOut(0.1, 0, function(twn:FlxTween)
				{
					FlxG.sound.music.stop();
					FlxG.switchState(new CompleteState());
				});
			}
		});
	}
}
