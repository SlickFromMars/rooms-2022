package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import lime.app.Application;

class TitleState extends FrameState
{
	// UI variables
	var logo:FlxSprite; // The wacky logo
	var beginText:FlxText; // The prompt to press start
	var versionText:FlxText; // The version
	var screen:FlxSprite; // Funky gradient

	var emitterGrp:FlxTypedGroup<FlxEmitter>; // Particle group yaaaay
	var doParticles:Bool = true; // Just for testing

	override public function create()
	{
		// Hide the mouse if there is one
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		// Initiate the volume keys
		FlxG.sound.muteKeys = CoolData.muteKeys;
		FlxG.sound.volumeDownKeys = CoolData.volumeDownKeys;
		FlxG.sound.volumeUpKeys = CoolData.volumeUpKeys;

		// Setup the UI
		emitterGrp = new FlxTypedGroup<FlxEmitter>();

		logo = new FlxSprite();
		logo.loadGraphic(Paths.image('logo'));
		logo.antialiasing = true;
		logo.screenCenter();

		beginText = new FlxText(0, FlxG.height - 60, 0, Paths.getText('en_us/start.txt'), 8);
		beginText.alignment = CENTER;
		beginText.screenCenter(X);

		if (doParticles)
		{
			// Based off code from VSRetro, thanks guys
			for (i in 0...3)
			{
				var emitter:FlxEmitter = new FlxEmitter(0, FlxG.height);
				emitter.launchMode = FlxEmitterMode.SQUARE;
				emitter.velocity.set(-25, -75, 25, -100, -50, 0, 50, -50);
				emitter.scale.set(0.25, 0.25, 0.5, 0.5, 0.25, 0.25, 0.37, 0.37);
				emitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
				emitter.width = FlxG.width;
				emitter.alpha.set(0.7, 0.7, 0, 0);
				emitter.lifespan.set(1, 3);
				emitter.loadParticles(Paths.image('particles/P0'), 500, 16, true);

				emitter.start(false, FlxG.random.float(0.4, 0.5), 100000);
				emitterGrp.add(emitter);
			}
		}

		screen = FlxGradient.createGradientFlxSprite(FlxG.width, Std.int(FlxG.height * 0.2), [FlxColor.TRANSPARENT, FlxColor.WHITE]);
		screen.y = FlxG.height - screen.height;
		screen.alpha = 0.7;

		add(emitterGrp);
		add(screen);
		add(beginText);
		add(logo);

		#if debug
		versionText = new FlxText(0, 12, 0, Application.current.meta.get('version'), 8);
		versionText.x = FlxG.width - (versionText.width + 2);
		add(versionText);
		#end

		super.create();

		// Play some music
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music('november'), 0.7);
		}

		// Epic transition
		FlxG.camera.fade(FlxColor.BLACK, 3, true);
	}

	var stopSpam:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player has confirmed
		if (FlxG.keys.anyJustPressed(CoolData.confirmKeys) && stopSpam == false)
		{
			// Stop people from spamming the button
			stopSpam = true;

			// Do Funky Effects and then go to PlayState
			FlxG.sound.music.fadeOut(1.1);

			FlxFlicker.flicker(beginText, 1.1, 0.15, false, true, function(flick:FlxFlicker)
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
				{
					FlxG.switchState(new gameplay.PlayState());
				});
			});
		}
	}
}
