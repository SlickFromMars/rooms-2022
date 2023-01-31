package meta.subStates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameSubState;

class EasterEggSubstate extends FrameSubState
{
	var eggName:String;

	var sillySound:FlxSound;

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
				var spr = new FlxSprite();
				spr.loadGraphic(Paths.image('eggs/sillybird'));
				spr.screenCenter();
				eggGrp.add(spr);

				FlxG.camera.shake(0.1, 1);
				FlxG.sound.music.pause();
				sillySound = new FlxSound().loadEmbedded(Paths.sound('funni'));
				sillySound.play();

			case 'alex': // lean
				var spr = new FlxText(0, 0, 0, RoomsUtils.getText('data/_eggs/alex.txt'), 16);
				spr.alignment = CENTER;
				spr.color = 0xFF00F2;
				spr.screenCenter();
				eggGrp.add(spr);

				FlxG.sound.music.pause();
				sillySound = new FlxSound().loadEmbedded(Paths.sound('drip'), true);
				sillySound.play();

			case 'orange': // orange
				var spr = new FlxSprite();
				spr.loadGraphic(Paths.image('eggs/lethimcook'));
				spr.setGraphicSize(Std.int(FlxG.width * 0.8));
				spr.screenCenter();
				eggGrp.add(spr);

			default: // for lame people
				var paper = new FlxSprite().loadGraphic(Paths.image('hint/paper'));
				paper.screenCenter();
				eggGrp.add(paper);

				var spr = new FlxText(0, 0, 0, RoomsUtils.getText('data/_eggs/$name.txt'), 8);
				spr.alignment = CENTER;
				spr.color = 0x403C3C;
				spr.screenCenter();
				eggGrp.add(spr);
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
				case 'SILLYBIRD': // hehehehehe
					RoomsUtils.openURL('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
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
					if (!FlxG.sound.music.playing)
					{
						FlxG.sound.music.play();
					}
					if (sillySound.playing)
					{
						sillySound.stop();
					}
					close();
				}
			});
		}
	}
}
