package meta.subStates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameSubState;

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
		bg.scrollFactor.set(0, 0);
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

				FlxG.camera.shake(0.3, 1);
				FlxG.sound.music.pause();
				FlxG.sound.play(Paths.sound('funni'));

			case 'alex': // lean
				var leanText = new FlxText(0, 0, 0, RoomsUtils.getText('data/_eggs/alex.txt'), 16);
				leanText.alignment = CENTER;
				leanText.color = 0xFF00F2;
				leanText.screenCenter();
				eggGrp.add(leanText);
				FlxG.camera.shake(0.05, 1);

			case 'orange': // orange
				var eggImage = new FlxSprite();
				eggImage.loadGraphic(Paths.image('lethimcook'));
				eggImage.setGraphicSize(Std.int(FlxG.width * 0.8));
				eggImage.screenCenter();
				eggGrp.add(eggImage);

			default: // for lame people
				var paper = new FlxSprite().loadGraphic(Paths.image('hint/paper'));
				paper.screenCenter();
				eggGrp.add(paper);

				var eggText = new FlxText(0, 0, 0, RoomsUtils.getText('data/_eggs/$name.txt'), 8);
				eggText.alignment = CENTER;
				eggText.color = 0x403C3C;
				eggText.screenCenter();
				eggGrp.add(eggText);
		}

		if (name != 'sillybird')
		{
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
					RoomsUtils.openURL('https://www.bensound.com/');
				case 'GITHUB':
					RoomsUtils.openURL('https://github.com/BHS-TSA/rooms-2022');
				case 'OGMO':
					RoomsUtils.openURL('https://ogmo-editor-3.github.io/');
				case 'PISKEL':
					RoomsUtils.openURL('https://www.piskelapp.com/');
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
					if (FlxG.sound.music.playing)
					{
						FlxG.sound.music.play();
					}
					close();
				}
			});
		}
	}
}
