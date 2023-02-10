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

#if CHECK_FOR_UPDATES
class OutdatedState extends FrameState
{
	var leftState:Bool = false;

	public static var updateVersion:String = '';

	var emitterGrp:FlxTypedGroup<FlxEmitter>;
	var screen:FlxSprite;
	var warnText:FlxText;
	var sillySprite:FlxSprite;
	var sillyTween:FlxTween;

	override function create()
	{
		super.create();

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

		warnText = new FlxText(0, 0, FlxG.width, '', 14);
		warnText.alignment = CENTER;
		updateUIText();

		sillySprite = new FlxSprite(0, warnText.y + warnText.height - 30);
		sillySprite.loadGraphic(Paths.image('slickfrommars'));
		sillySprite.setGraphicSize(50);
		sillySprite.screenCenter(X);
		sillySprite.angle = -20;

		add(emitterGrp);
		add(screen);
		add(warnText);
		add(sillySprite);

		sillyTween = FlxTween.tween(sillySprite, {angle: 20}, 3, {type: PINGPONG, ease: FlxEase.quadInOut});

		FlxG.camera.fade(FlxColor.BLACK, 0.1, true);
	}

	override function update(elapsed:Float)
	{
		if (!leftState)
		{
			if (Controls.CONFIRM)
			{
				leftState = true;
				RoomsUtils.openURL("https://github.com/SlickFromMars/rooms-2022/releases/tag/v" + updateVersion);
			}
			else if (Controls.BACK)
			{
				leftState = true;
			}

			if (leftState)
			{
				sillyTween.cancel();
				FlxTween.tween(sillySprite, {y: FlxG.height, angle: 0}, 1, {ease: FlxEase.quadIn});
				FlxTween.tween(warnText, {alpha: 0}, 1, {ease: FlxEase.quadIn});
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FrameState.switchState(new meta.states.OpeningState());
				});
			}
		}
		super.update(elapsed);
	}

	override function updateUIText()
	{
		warnText.text = "Hey, looks like you're playing an\nold version of ROOMS ("
			+ Init.gameVersion
			+ "),\nplease update to "
			+ updateVersion
			+ "!\nPress ";

		switch (Controls.CONTROL_SCHEME)
		{
			case KEYBOARD:
				warnText.text += 'ESC';
			case GAMEPAD:
				warnText.text += 'B';
		}
		warnText.text += ' To Proceed';

		warnText.screenCenter(Y);
	}
}
#end
