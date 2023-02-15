package meta;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import meta.Controls.ControlScheme;

class FrameState extends FlxState
{
	private var lastTextUpdate:ControlScheme;

	override function update(elapsed:Float)
	{
		// Check ui
		if (lastTextUpdate != Controls.CONTROL_SCHEME)
		{
			updateUIText();
		}

		// Check keys
		Controls.updateKeys();
		backgroundKeys();

		super.update(elapsed);
	}

	// for states with help tips
	public function updateUIText()
	{
		// trace('Updating UI');
	}

	public function quickBG()
	{
		// Setup the UI
		var emitterGrp:FlxTypedGroup<FlxEmitter> = new FlxTypedGroup<FlxEmitter>();

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
		var screen:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, Std.int(FlxG.height * 0.2), [FlxColor.TRANSPARENT, FlxColor.WHITE]);
		screen.y = FlxG.height - screen.height;
		screen.alpha = 0.7;

		add(emitterGrp);
		add(screen);
	}

	// Checking important keys for frame states
	public static function backgroundKeys()
	{
		if (Controls.FULLSCREEN)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}

	// Switch state function
	public static function switchState(nextState:FlxState)
	{
		var curState:FlxState = FlxG.state;
		if (curState == nextState)
		{
			FlxG.resetState();
		}
		else
		{
			FlxG.switchState(nextState);
		}
	}

	public static function resetState()
	{
		FrameState.switchState(FlxG.state);
	}
}

class FrameSubState extends FlxSubState
{
	private var lastTextUpdate:ControlScheme;

	override function update(elapsed:Float)
	{
		// Check ui
		if (lastTextUpdate != Controls.CONTROL_SCHEME)
		{
			updateUIText();
		}

		super.update(elapsed);

		// Check keys
		Controls.updateKeys();
		FrameState.backgroundKeys();
	}

	// for states with help tips
	function updateUIText()
	{
		// trace('Updating UI');
	}
}
