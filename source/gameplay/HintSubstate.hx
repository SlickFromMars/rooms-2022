package gameplay;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class HintSubstate extends FrameSubState
{
	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var decorGrp:FlxSpriteGroup; // group for paper stuff

	public function new(hintType:String)
	{
		super();

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		var textColor:FlxColor = FlxColor.fromRGB(64, 60, 60);

		decorGrp = new FlxSpriteGroup(0, 0);
		add(decorGrp);

		var paper = new FlxSprite().loadGraphic(Paths.image('hint/paper'));
		paper.screenCenter();
		decorGrp.add(paper);

		switch (hintType)
		{
			case 'solution':
				var spr:FlxText = new FlxText(0, 0, 0, '', 26);
				for (i in ShapePuzzleSubstate.puzzleCombo)
				{
					spr.text += '$i-';
				}
				spr.text = spr.text.substring(0, spr.text.length - 1);
				spr.color = textColor;
				spr.screenCenter();
				decorGrp.add(spr);

			case 'shapes':
				for (i in 0...5)
				{
					var spr:FlxSprite = new FlxSprite();
					spr.loadGraphic(Paths.image('hint/paperequals'));
					spr.screenCenter(X);
					spr.y = (i * 34) + 32;
					decorGrp.add(spr);

					var spr2:PaperShapeKey = new PaperShapeKey(i);
					spr2.x = spr.x - 60;
					spr2.y = spr.y;
					decorGrp.add(spr2);

					var spr3:FlxText = new FlxText(0, 0, 0, Std.string(i), 26);
					spr3.color = textColor;
					spr3.x = spr.x + 80;
					spr3.y = spr.y + 3;
					decorGrp.add(spr3);
				}
			case 'shape_inst':
				var spr:FlxText = new FlxText(0, 0, 0, Paths.getLang('shapeInst'), 16);
				spr.color = textColor;
				spr.alignment = CENTER;
				spr.screenCenter();
				decorGrp.add(spr);

			case 'key_inst':
				var spr:FlxText = new FlxText(0, 0, 0, Paths.getLang('keyInst'), 20);
				spr.color = textColor;
				spr.alignment = CENTER;
				spr.screenCenter();
				decorGrp.add(spr);

			case 'game_inst':
				var spr:FlxText = new FlxText(0, 0, 0, Paths.getLang('gameInst'), 16);
				spr.color = textColor;
				spr.alignment = CENTER;
				spr.screenCenter();
				decorGrp.add(spr);

			default:
				trace('Couldnt find the hint :(');
		}

		// set alpha and position
		bg.alpha = 0;
		decorGrp.y = FlxG.height;

		// tween things and cameras
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		FlxTween.tween(bg, {alpha: 0.7}, 0.3);
		FlxTween.tween(decorGrp, {y: 0}, 0.3);
	}

	var stopSpam:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if (FlxG.keys.anyJustPressed(CoolData.backKeys) && stopSpam == false)
		{
			stopSpam = true;
			FlxTween.tween(decorGrp, {y: 0 - FlxG.height}, 0.3, {
				onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
		}
	}
}

class PaperShapeKey extends FlxSprite
{
	public function new(iteration:Int)
	{
		super(x, y);

		// load the sprites
		loadGraphic(Paths.image('hint/papershapes'), true, 32, 32);
		animation.add('0', [0], 1, true);
		animation.add('1', [1], 1, true);
		animation.add('2', [2], 1, true);
		animation.add('3', [3], 1, true);
		animation.add('4', [4], 1, true);

		animation.play(Std.string(iteration));
	}
}
