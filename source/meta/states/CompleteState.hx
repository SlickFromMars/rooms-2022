package meta.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import meta.Frame.FrameState;
#if discord_rpc
import meta.Discord.DiscordClient;
#end

class CompleteState extends FrameState
{
	// The UI varaibles
	var winText:FlxText; // the silly text
	var screen:FlxSprite; // Funky gradient

	var emitterGrp:FlxTypedGroup<FlxEmitter>; // Particle group yaaaay

	override function create()
	{
		// Hide the mouse if there is one
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		#if discord_rpc
		// Updating Discord Rich Presence.
		DiscordClient.changePresence('In The Completed Screen', null);
		#end

		// Setup the UI
		emitterGrp = new FlxTypedGroup<FlxEmitter>();

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

		winText = new FlxText(0, 0, FlxG.width, '', 8);
		updateUIText();
		winText.alignment = CENTER;
		winText.screenCenter(Y);
		winText.alpha = 0;

		add(emitterGrp);
		add(screen);
		add(winText);

		super.create();

		// Cool fade to make it smoother
		FlxG.camera.fade(FlxColor.WHITE, 5, true, function()
		{
			FlxTween.tween(winText, {alpha: 1}, 3, {startDelay: 1});
		});
	}

	override function update(elapsed:Float)
	{
		// Check to see if the player has confirmed
		if (Controls.CONFIRM && winText.alpha == 1)
		{
			pressStart();
		}

		super.update(elapsed);
	}

	function pressStart()
	{
		// Fade to black and then go to PlayState again
		FlxTween.tween(winText, {y: FlxG.height}, 1, {ease: FlxEase.quadIn});
		FlxG.sound.music.fadeOut(0.7);
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
		{
			RoomsData.roomNumber = 1;
			FrameState.switchState(new TitleState());
		});
	}

	override function updateUIText()
	{
		winText.text = 'To Be Continued...\nYou escaped the dungeon.\nPress ';
		switch (Controls.CONTROL_SCHEME)
		{
			case KEYBOARD:
				winText.text += 'ENTER';
			case GAMEPAD:
				winText.text += 'X';
		}
		winText.text += ' to return to the menu.';
	}
}
