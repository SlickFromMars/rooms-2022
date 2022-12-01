package menus;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class InstructionsSubstate extends FrameSubState
{
	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var helpText:FlxText; // The text that teaches you things

	public function new()
	{
		super();

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		helpText = new FlxText(0, 0, 0, '', 8);
		helpText.alignment = CENTER;
		helpText.text = Paths.getText('instructions.txt');
		helpText.screenCenter();
		add(helpText);

		// set alphas
		bg.alpha = 0;
		helpText.alpha = 0;

		// tween things and cameras
		FlxTween.tween(bg, {alpha: 0.7}, 0.3);
		FlxTween.tween(helpText, {alpha: 1}, 0.3);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var stopSpam:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if (FlxG.keys.anyJustPressed(CoolData.backKeys) || FlxG.keys.anyJustPressed(CoolData.helpKeys))
		{
			close();
		}
	}
}
