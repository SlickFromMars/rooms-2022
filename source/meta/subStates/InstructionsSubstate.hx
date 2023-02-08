package meta.subStates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameSubState;

class InstructionsSubstate extends FrameSubState
{
	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var helpText:FlxText; // The sprite group that contains all stuff

	public function new()
	{
		super();

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		helpText = new FlxText(0, 0, FlxG.width, '', 8);
		helpText.alignment = CENTER;
		updateUIText();
		add(helpText);

		// set alphas
		bg.alpha = 0;
		helpText.alpha = 0;

		// tween things and cameras
		FlxTween.tween(bg, {alpha: 1}, 0.3);
		FlxTween.tween(helpText, {alpha: 1}, 0.3);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var stopSpam:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if (Controls.BACK || Controls.CONFIRM_SECONDARY)
		{
			stopSpam = true;
			FlxTween.tween(helpText, {alpha: 0}, 0.3, {
				onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
		}
	}

	override function updateUIText()
	{
		switch (Controls.CONTROL_SCHEME)
		{
			case KEYBOARD:
				helpText.text = RoomsUtils.getText('data/keybinds.txt');
			case GAMEPAD:
				helpText.text = RoomsUtils.getText('data/gamepad.txt');
		}

		helpText.screenCenter(Y);
	}
}
