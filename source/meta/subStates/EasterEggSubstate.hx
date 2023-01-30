package meta.subStates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class EasterEggSubstate extends FrameSubState
{
	var eggName:String;

	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var eggGrp:FlxSpriteGroup; // The sprite group that contains all stuff

	public function new(name:String)
	{
		eggName = name;

		super();

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		eggGrp = new FlxSpriteGroup();
		add(eggGrp);

		switch (name)
		{
			case 'sillybird': // in case you wanted to be silly
				var eggImage = new FlxSprite();
				eggImage.loadGraphic(Paths.image('sillybird'));
				eggImage.screenCenter();
				eggGrp.add(eggImage);

				FlxG.camera.shake(0.5, 1);
			default:
				var eggText = new FlxText(0, 0, 0, Paths.getText('data/_eggs/$name.txt'), 8);
				eggText.alignment = CENTER;
				eggText.screenCenter();
				eggGrp.add(eggText);

				// set alphas
				bg.alpha = 0;
				eggGrp.alpha = 0;

				// tween things and cameras
				FlxTween.tween(bg, {alpha: 1}, 0.3);
				FlxTween.tween(eggGrp, {alpha: 1}, 0.3);
		}

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var stopSpam:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check stuff
		if (Controls.CONFIRM)
		{
			switch (eggName.toUpperCase())
			{
				case 'BENSOUND':
					FlxG.openURL('https://www.bensound.com/');
				case 'GITHUB':
					FlxG.openURL('https://github.com/BHS-TSA/rooms-2022');
				case 'OGMO':
					FlxG.openURL('https://ogmo-editor-3.github.io/');
				case 'PISKEL':
					FlxG.openURL('https://www.piskelapp.com/');
				default:
					trace('CONFIRMED ON $eggName');
			}
		}
		else if (Controls.BACK)
		{
			stopSpam = true;
			FlxTween.tween(eggGrp, {alpha: 0}, 0.3, {
				onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
		}
	}
}
