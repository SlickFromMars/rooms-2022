package gameplay;

import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class HintSubstate extends FrameSubState
{
	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var bg2:FlxSprite; // The paper bg
	var decorGrp:FlxSpriteGroup; // group for paper stuff

	public function new(hintType:String)
	{
		super();

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		bg2 = new FlxSprite().loadGraphic(Paths.image('ui/paper'));
		bg2.scrollFactor.set();
		bg2.screenCenter();
		add(bg2);

		decorGrp = new FlxSpriteGroup();
		add(decorGrp);

		switch (hintType)
		{
			case 'solution':
				var spr:FlxText = new FlxText(0, 0, 0, '', 26);
				for (i in ShapePuzzleSubstate.puzzleCombo)
				{
					spr.text += i;
				}
				spr.color = FlxColor.fromRGB(64, 60, 60);
				spr.screenCenter();
				decorGrp.add(spr);

			case 'shapes':
				for (i in 0...5)
				{
					var spr:PaperEquals = new PaperEquals();
					spr.screenCenter(X);
					spr.y = (i * 34) + 32;
					decorGrp.add(spr);

					var spr2:PaperShapeKey = new PaperShapeKey(i);
					spr2.x = spr.x - 60;
					spr2.y = spr.y;
					decorGrp.add(spr2);

					var spr3:FlxText = new FlxText(0, 0, 0, Std.string(i), 26);
					spr3.color = FlxColor.fromRGB(64, 60, 60);
					spr3.x = spr.x + 80;
					spr3.y = spr.y + 3;
					decorGrp.add(spr3);
				}
		}

		// set alphas
		bg.alpha = 0;

		// tween things and cameras
		FlxTween.tween(bg, {alpha: 0.7}, 0.3);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if (FlxG.keys.anyJustPressed(CoolData.backKeys))
		{
			close();
		}
	}
}

class PaperShapeKey extends FlxSprite
{
	public function new(iteration:Int)
	{
		super(x, y);

		// load the sprites
		loadGraphic(Paths.image('ui/papershapes'), true, 32, 32);
		animation.add('0', [0], 1, true);
		animation.add('1', [1], 1, true);
		animation.add('2', [2], 1, true);
		animation.add('3', [3], 1, true);
		animation.add('4', [4], 1, true);

		animation.play(Std.string(iteration));
	}
}

class PaperEquals extends FlxSprite
{
	public function new()
	{
		super(x, y);

		loadGraphic(Paths.image('ui/paperequals'));
	}
}
