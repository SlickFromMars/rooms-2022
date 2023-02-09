package meta.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import meta.Frame.FrameState;

using StringTools;

#if discord_rpc
import meta.Discord;
#end

class TitleState extends FrameState
{
	var playIntro:Bool;

	// UI variables
	var logo:FlxSprite; // The wacky logo
	var beginText:FlxText; // The prompt to press start
	var versionText:FlxText; // The version
	var screen:FlxSprite; // Funky gradient

	var emitterGrp:FlxTypedGroup<FlxEmitter>; // Particle group yaaaay

	#if EASTER_EGG
	var easterEggKeys:Array<String>;
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var easterEggKeysBuffer:String = '';
	#end

	public function new(?playIntro:Bool = false)
	{
		this.playIntro = playIntro;
		super();
	}

	override public function create()
	{
		// Hide the mouse if there is one
		FlxG.mouse.visible = false;

		#if EASTER_EGG
		// get this stuff
		easterEggKeys = RoomsUtils.getCoolText('data/eggList.txt');
		// trace('Loaded eggs ' + easterEggKeys);
		#end

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		// Setup the UI
		emitterGrp = new FlxTypedGroup<FlxEmitter>();

		logo = new FlxSprite();
		logo.loadGraphic(Paths.image('logo'));
		logo.antialiasing = true;
		logo.screenCenter();

		beginText = new FlxText(0, FlxG.height - 10, FlxG.width, '', 8);
		updateUIText();
		beginText.alignment = CENTER;
		beginText.alpha = 0;

		// Based off code from VSRetro, thanks guys
		for (i in 0...2)
		{
			var emitter:FlxEmitter = new FlxEmitter(0, FlxG.height + 50);
			emitter.launchMode = SQUARE;
			emitter.velocity.set(-25, -75, 25, -100, -50, 0, 50, -50);
			emitter.scale.set(0.25, 0.25, 0.5, 0.5, 0.25, 0.25, 0.37, 0.37);
			emitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
			emitter.width = FlxG.width;
			emitter.alpha.set(0.7, 0.7, 0, 0);
			emitter.lifespan.set(1.5, 3);
			emitter.loadParticles(Paths.image('particles/title$i'), 700, 16, true);
			emitter.start(false, FlxG.random.float(0.4, 0.5), 100000);
			emitterGrp.add(emitter);
		}
		screen = FlxGradient.createGradientFlxSprite(FlxG.width, Std.int(FlxG.height * 0.2), [FlxColor.TRANSPARENT, FlxColor.WHITE]);
		screen.y = FlxG.height - screen.height;
		screen.alpha = 0.7;

		add(emitterGrp);
		add(screen);
		add(beginText);
		add(logo);

		versionText = new FlxText(0, 12, 0, 'v' + Init.gameVersion, 8);
		versionText.x = FlxG.width - (versionText.width + 2);
		add(versionText);

		super.create();

		if (FlxG.sound.music == null)
		{
			// Play some music
			FlxG.sound.playMusic(Paths.music('newdawn'), 0.7);
		}

		// Epic transition
		if (playIntro)
		{
			FlxG.camera.fade(FlxColor.BLACK, 3, true);
			FlxTween.tween(beginText, {alpha: 1, y: beginText.y - beginText.height}, 3);
		}
		else
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.1, true);
			beginText.alpha = 1;
			beginText.y = beginText.y - beginText.height;
		}
	}

	var stopSpam:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		var pressedEnter = Controls.CONFIRM;
		if (Controls.CONTROL_SCHEME == GAMEPAD)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
			if (gamepad.justPressed.START)
			{
				pressedEnter = true;
			}
		}

		// Check keys
		if (Controls.CONFIRM_SECONDARY)
		{
			openSubState(new meta.subStates.InstructionsSubstate());
		}
		else if (Controls.CONFIRM_TERTIARY)
		{
			openSubState(new meta.subStates.SettingsSubState());
		}
		else if (pressedEnter && !stopSpam && beginText.alpha == 1)
		{
			// Stop people from spamming the button
			stopSpam = true;

			// Do Funky Effects and then go to PlayState
			FlxG.sound.music.fadeOut(1.1);

			FlxFlicker.flicker(beginText, 1.1, 0.15, false, true, function(flick:FlxFlicker)
			{
				FlxG.sound.music.stop();
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
				{
					FrameState.switchState(new PlayState());
				});
			});
		}
		#if EASTER_EGG
		else if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
		{
			var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
			var keyName:String = Std.string(keyPressed);
			if (allowedKeys.contains(keyName))
			{
				easterEggKeysBuffer += keyName;
				if (easterEggKeysBuffer.length >= 32)
				{
					easterEggKeysBuffer = easterEggKeysBuffer.substring(1);
				}
				// trace('EASTER EGG BUFFER ' + easterEggKeysBuffer);
			}
			else if (keyPressed == FlxKey.SEVEN)
			{
				for (wordRaw in easterEggKeys)
				{
					var word = wordRaw.toUpperCase();
					if (easterEggKeysBuffer.endsWith(word))
					{
						trace('$word is coolswag');
						// easterEggKeysBuffer = "";
						openSubState(new meta.subStates.EasterEggSubstate(wordRaw.toLowerCase()));
					}
				}
			}
		}
		#end
	}

	override function updateUIText()
	{
		lastTextUpdate = Controls.CONTROL_SCHEME;

		switch (Controls.CONTROL_SCHEME)
		{
			case KEYBOARD:
				beginText.text = 'Press ENTER to Begin\nPress TAB for Instructions\nPress SHIFT for Settings';
			case GAMEPAD:
				beginText.text = 'Press START to Begin\nPress Y for Instructions\nPress A for Settings';
		}
	}
}
