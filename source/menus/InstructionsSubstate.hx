package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class InstructionsSubstate extends FrameSubState
{
	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var helpMaster:FlxSpriteGroup; // The sprite group that contains all stuff
	var helpText:FlxText; // The text that teaches you things

	public function new()
	{
		super();

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		helpMaster = new FlxSpriteGroup(0, 0);
		add(helpMaster);

		helpText = new FlxText(0, 0, 0, Paths.getText('en_us/keybinds.txt'), 8);
		helpText.alignment = CENTER;
		helpText.screenCenter();
		helpMaster.add(helpText);

		// set alphas
		bg.alpha = 0;
		helpMaster.alpha = 0;

		// tween things and cameras
		FlxTween.tween(bg, {alpha: 0.7}, 0.3);
		FlxTween.tween(helpMaster, {alpha: 1}, 0.3);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var stopSpam:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if (FlxG.keys.anyJustPressed(CoolData.backKeys) || FlxG.keys.anyJustPressed(CoolData.helpKeys))
		{
			stopSpam = true;
			FlxTween.tween(helpMaster, {alpha: 0}, 0.3, {
				onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
		}
	}
}
