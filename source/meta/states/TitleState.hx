package meta.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameState;

using StringTools;

#if DISCORD_RPC
import meta.Discord;
#end

class TitleState extends FrameState
{
	var playIntro:Bool;

	// UI variables
	var logo:FlxSprite; // The wacky logo
	var logoTween:FlxTween; // silly tween
	var beginText:FlxText; // The prompt to press start
	var versionText:FlxText; // The version

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

		#if DISCORD_RPC
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		// Setup the UI
		quickBG();

		logo = new FlxSprite();
		logo.loadGraphic(Paths.image('logo'));
		logo.antialiasing = true;
		logo.angle = -3;
		logo.screenCenter();

		beginText = new FlxText(0, FlxG.height - 10, FlxG.width, '', 8);
		updateUIText();
		beginText.alignment = CENTER;
		beginText.alpha = 0;

		// Based off code from VSRetro, thanks guys
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

		// Epic stuff
		logoTween = FlxTween.tween(logo, {angle: 3}, 3, {type: PINGPONG, ease: FlxEase.quadInOut});
		logoTween.start();

		if (playIntro)
		{
			FlxG.camera.fade(FlxColor.BLACK, 3, true, function()
			{
				stopSpam = false;
			});
			FlxTween.tween(beginText, {alpha: 1, y: beginText.y - beginText.height}, 3);
		}
		else
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, true, function()
			{
				stopSpam = false;
			});
			beginText.alpha = 1;
			beginText.y = beginText.y - beginText.height;
		}
	}

	var stopSpam:Bool = true;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		var pressedEnter = (Controls.CONTROL_SCHEME == KEYBOARD && FlxG.keys.justPressed.ENTER)
			|| (Controls.CONTROL_SCHEME == GAMEPAD && Controls.CONFIRM);
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

			// Do Funky Effects and then go
			FlxG.sound.music.fadeOut(1.1);

			FlxFlicker.flicker(beginText, 1.1, 0.15, true, true, function(flick:FlxFlicker)
			{
				// DO COOL STUFF!
				logoTween.cancel();

				FlxTween.tween(versionText, {y: -versionText.height}, 0.5, {ease: FlxEase.quadIn});
				FlxTween.tween(logo, {angle: 0}, 0.5, {ease: FlxEase.quadIn});
				FlxTween.tween(beginText, {y: FlxG.height}, 1, {startDelay: 0.5, ease: FlxEase.quadIn});
				FlxTween.tween(logo, {y: FlxG.height}, 1.5, {startDelay: 2, ease: FlxEase.quadIn});

				FlxG.sound.music.fadeOut(3, 0, function(twn:FlxTween)
				{
					FlxG.sound.music.stop();
					FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
					{
						FrameState.switchState(new meta.states.PlayState());
					});
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
