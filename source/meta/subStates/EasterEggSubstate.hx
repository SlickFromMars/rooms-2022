package meta.subStates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameSubState;

using StringTools;

class EasterEggSubstate extends FrameSubState
{
	var eggName:String;
	var myLink:String = null; // the link thingy
	var skipNameList:Array<String> = ['sillybird', 'orange']; // things to ignore text searching

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

		var myText = '';
		if (Paths.fileExists('data/_eggs/$name.txt'))
		{
			myText = RoomsUtils.getText('data/_eggs/$name.txt');

			// I hate this code so much
			var lineArray = RoomsUtils.getCoolText('data/_eggs/$name.txt');
			if (lineArray[lineArray.length - 1].startsWith('LINK--'))
			{
				myLink = lineArray[lineArray.length - 1].split('LINK--')[1];
				myText = myText.split('\nLINK--')[0];
				trace('Has a link $myLink');
			}
		}
		else
		{
			if (!skipNameList.contains(name))
			{
				trace('There is no text file for egg $name');
				myText = 'Error finding file:\ndata/_eggs/$name.txt';
			}
		}

		if (Controls.CONTROL_SCHEME == GAMEPAD)
		{
			myText = myText.replace('ENTER', 'X');
		}

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
				var spr = new FlxText(0, 0, 0, myText, 16);
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

				var spr = new FlxText(0, 0, 0, myText, 8);
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
		if (Controls.CONFIRM && myLink != null)
		{
			RoomsUtils.openURL(myLink);
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
					if (sillySound != null)
					{
						sillySound.stop();
					}

					close();
				}
			});
		}
	}
}
