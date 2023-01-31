package meta.states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.Frame.FrameState;
import meta.states.gameObjects.Player;
import meta.states.gameObjects.Prop;
#if discord_rpc
import meta.Discord;
#end

class PlayState extends FrameState
{
	// Camera stuff
	var camGame:FlxCamera;
	var camUI:FlxCamera;

	public var camFollowPos:FlxObject;

	var startTween:FlxTween;
	var startTween2:FlxTween;

	// The game variables
	public static var map:FlxOgmo3Loader;
	public static var walls:FlxTilemap;
	public static var walls2:FlxTilemap;
	public static var player:Player;
	public static var door:Prop;

	var propGrp:FlxTypedGroup<Prop>;
	var jumpEmitter:FlxEmitter;

	// The UI stuff
	var overlay:FlxSprite;
	var levelText:FlxText;
	var denyText:FlxText;
	var denyTween:FlxTween;
	var skipText:FlxText;

	// Conditions and things
	var localEndState:Bool = false;
	var localHideKey:Bool = false;

	public static var localDoingOpening:Bool = true;

	override public function create()
	{
		// Hide the mouse if there is one
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		#if discord_rpc
		// Updating Discord Rich Presence.
		var stateText:String = '';
		switch (RoomsData.roomNumber)
		{
			case 1:
				stateText = 'Learning How To Play';
			case 2:
				stateText = 'Finding A Key';
			case 3:
				stateText = 'Solving A Shape Puzzle';
			case 4:
				stateText = 'Crossing The Chasm';
			case 5:
				stateText = 'Approaching The Exit';
		}
		DiscordClient.changePresence('On Room ' + RoomsData.roomNumber, stateText);
		#end

		// Set up the cameras
		camGame = new FlxCamera();
		camUI = new FlxCamera();
		camUI.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camUI, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollowPos);
		camGame.follow(camFollowPos, LOCKON, 1);

		// UI stuffs
		overlay = new FlxSprite();
		overlay.loadGraphic(Paths.image('overlay'));
		overlay.cameras = [camUI];
		overlay.screenCenter();

		levelText = new FlxText(0, 5, 0, "- LEVEL ??? -", 10);
		levelText.alignment = CENTER;
		levelText.screenCenter(X);
		levelText.cameras = [camUI];

		denyText = new FlxText(0, FlxG.height * 0.8, 0, "Denied.", 10);
		denyText.alignment = CENTER;
		denyText.screenCenter(X);
		denyText.cameras = [camUI];
		denyText.alpha = 0;

		skipText = new FlxText(FlxG.width, FlxG.height, 0, 'Press ENTER To Skip', 8);
		skipText.x -= skipText.width;
		skipText.y -= skipText.height;
		skipText.cameras = [camUI];
		skipText.alpha = 0;

		levelText.text = '- Room ' + RoomsData.roomNumber + ' -';
		levelText.screenCenter(X);

		// Build the level
		var swagArray = RoomsUtils.getCoolText('data/_gen/' + Std.string(RoomsData.roomNumber) + '.txt');
		var swagItem:String = FlxG.random.getObject(swagArray);
		trace('Chose $swagItem from $swagArray');

		map = new FlxOgmo3Loader(Paths.getOgmo(), Paths.json('_levels/$swagItem'));
		walls = map.loadTilemap(Paths.image('tileset'), "walls");
		walls.follow(camGame, -5);
		walls2 = map.loadTilemap(Paths.image('tileset'), "no_collision");

		// Setup the collision
		for (i in 0...RoomsData.tileCount)
		{
			if (RoomsData.doTileCollision.contains(i))
			{
				walls.setTileProperties(i, ANY);
			}
			else
			{
				walls.setTileProperties(i, NONE);
			}
		}

		// Do the particles
		jumpEmitter = new FlxEmitter();
		jumpEmitter.launchMode = CIRCLE;
		jumpEmitter.scale.set(0.1);
		jumpEmitter.alpha.set(0.7, 0.7, 0, 0);
		jumpEmitter.lifespan.set(0.5, 1);
		jumpEmitter.loadParticles(Paths.image('particles/jump'), 25);

		// Finalize and add stuff
		add(walls);
		add(walls2);
		player = new Player();
		propGrp = new FlxTypedGroup<Prop>();
		map.loadEntities(placeEntities, "decor");
		map.loadEntities(placeEntities, "utils");
		add(jumpEmitter);
		add(player);
		add(overlay);
		add(levelText);
		add(denyText);
		add(skipText);

		super.create();
		stopCompleteSpam = false;
		if (RoomsData.roomNumber == 1)
		{
			localHideKey = true;
		}
		else
		{
			localHideKey = false;
		}
		localDoingOpening = true;

		// Play some music
		if (RoomsData.roomNumber == 1)
		{
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('november'), 0.7, true);
		}

		// Epic transition
		camUI.fade(FlxColor.BLACK, 0.1, true);

		if (RoomsData.roomNumber != 5)
		{
			camGame.zoom = 0.8;
			var dist = FlxMath.distanceBetween(door, player);
			var transTime = dist / 80;
			var delay = 1;
			// trace(dist);

			startTween = FlxTween.tween(camFollowPos, {x: player.x + player.width / 2, y: player.y + player.height / 2}, transTime, {
				startDelay: delay,
				onComplete: function(twn:FlxTween)
				{
					skipText.alpha = 0;
					localDoingOpening = false;
				}
			});
			startTween2 = FlxTween.tween(camGame, {zoom: 1}, transTime, {
				startDelay: delay
			});
		}
		else
		{
			localDoingOpening = false;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player needs help
		if (Controls.PAUSE)
		{
			openSubState(new meta.subStates.PauseSubState());
		}

		// Collision stuff
		checkPlayerCollision();

		// Update the camera position
		if (!localDoingOpening)
		{
			camFollowPos.x = player.x + player.width / 2;
			camFollowPos.y = player.y + player.height / 2;
		}
		else
		{
			if (FlxG.keys.anyJustPressed([SPACE]))
			{
				if (skipText.alpha == 0)
				{
					skipText.alpha = 1;
				}
				else
				{
					startTween.cancel();
					startTween2.cancel();
					skipText.alpha = 0;
					camGame.zoom = 1;
					localDoingOpening = false;
				}
			}
		}
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
			if (!RoomsData.allowPropCollision.contains(spr.my_type) && !player.lockMovement)
			{
				FlxG.collide(player, spr);
			}

			// Check for overlaps
			if (spr.my_type == FINALETRIP)
			{
				if (player.overlaps(spr) && !localEndState)
				{
					FlxG.sound.music.fadeOut(0.3, 0, function(twn:FlxTween)
					{
						FlxG.sound.music.stop();
						FlxG.sound.playMusic(Paths.music('littleplanet'), 0.7, true);
					});
				}
			}
			else if (spr.my_type == ARROW)
			{
				if (player.overlaps(spr) && !isTouching && !player.lockMovement)
				{
					isTouching = true;
					spr.animation.play(spr.launchDirection + '_sel');

					if (Controls.CONFIRM)
					{
						player.lockMovement = true;

						if (RoomsData.roomNumber == 5)
						{
							FlxG.cameras.list[FlxG.cameras.list.length - 1].fade(FlxColor.WHITE, 5, false, function()
							{
								new FlxTimer().start(2, function(tmr:FlxTimer)
								{
									completeLevel(true);
								});
							});
						}

						// smoothly set position and then do the thing
						FlxTween.tween(player, {x: spr.x + player.offset.x, y: spr.y + player.offset.y}, 0.05, {
							onComplete: function(twn:FlxTween)
							{
								player.animation.play(spr.launchDirection);

								// start the funky particles
								jumpEmitter.setPosition(spr.x + player.offset.x, spr.y + player.offset.y);
								jumpEmitter.start(true);

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
				if (player.overlaps(spr) && !door.isOpen && !player.lockMovement)
				{
					isTouching = true;
					spr.animation.play('hover');

					if (Controls.CONFIRM)
					{
						openSubState(new meta.subStates.ShapePuzzleSubstate());
					}
				}
				else
				{
					if (door.isOpen)
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
				if (player.overlaps(spr) && !player.lockMovement)
				{
					isTouching = true;
					spr.animation.play('hover');

					if (Controls.CONFIRM)
					{
						if (spr.hintType == 'items')
						{
							localHideKey = false;
						}
						openSubState(new meta.subStates.HintSubstate(spr.hintType));
					}
				}
				else
				{
					spr.animation.play('normal');
				}
			}
			else if (spr.my_type == KEY)
			{
				spr.visible = !localHideKey;
				if (player.overlaps(spr) && !door.isOpen && !player.lockMovement && !localHideKey)
				{
					isTouching = true;
					spr.animation.play('hover');

					if (Controls.CONFIRM)
					{
						door.isOpen = true;
						spr.kill();

						denyText.text = 'Door has been unlocked.';
						denyText.screenCenter(X);
						if (denyTween != null)
						{
							denyTween.cancel();
						}
						denyText.alpha = 1;
						denyTween = FlxTween.tween(denyText, {alpha: 0}, 2, {startDelay: 1});
					}
				}
				else
				{
					spr.animation.play('normal');
				}
			}
		});

		if (player.overlaps(door) && !isTouching)
		{
			if (door.isOpen)
			{
				door.animation.play('open_s');

				if (!stopCompleteSpam && Controls.CONFIRM)
				{
					completeLevel();
				}
			}
			else
			{
				door.animation.play('closed_s');

				if (Controls.CONFIRM)
				{
					denyText.text = 'This door is locked.';
					denyText.screenCenter(X);
					if (denyTween != null)
					{
						denyTween.cancel();
					}
					denyText.alpha = 1;
					denyTween = FlxTween.tween(denyText, {alpha: 0}, 2, {startDelay: 1});
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
				camFollowPos.x = door.x + door.width / 2;
				camFollowPos.y = door.y + door.height / 2;

			case 'torch':
				propGrp.add(new Prop(startX, startY, TORCH));

			case 'shapelock':
				propGrp.add(new Prop(startX - 8, startY, SHAPELOCK));
				meta.subStates.ShapePuzzleSubstate.shuffleCombo();

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

			case 'finaletrip':
				propGrp.add(new Prop(startX, startY, FINALETRIP));

			default:
				FlxG.log.warn('Unrecognized actor type ' + entity.name);
		}
		add(propGrp);
	}

	static var stopCompleteSpam:Bool = false; // Stop people from breaking the level

	public static function completeLevel(skipTrans:Bool = false)
	{
		stopCompleteSpam = true;

		// TO THE NEXT LEVEL WOOOOOOOO
		RoomsData.roomNumber += 1;

		if (skipTrans)
		{
			// Check to see if a file exists, and then go to the next level if it does
			if (Paths.fileExists('data/_gen/' + RoomsData.roomNumber + '.txt'))
			{
				FrameState.resetState();
			}
			else
			{
				FrameState.switchState(new CompleteState());
			}
		}
		else
		{
			// Fade to black and then figure out what to do
			FlxG.cameras.list[FlxG.cameras.list.length - 1].fade(FlxColor.BLACK, 0.1, false, function()
			{
				// Check to see if a file exists, and then go to the next level if it does
				if (Paths.fileExists('data/_gen/' + RoomsData.roomNumber + '.txt'))
				{
					FrameState.resetState();
				}
				else
				{
					FlxG.sound.music.fadeOut(0.1, 0, function(twn:FlxTween)
					{
						FlxG.sound.music.stop();
						FrameState.switchState(new CompleteState());
					});
				}
			});
		}
	}
}
