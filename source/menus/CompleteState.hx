package menus;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class CompleteState extends FlxState
{
	var winText:FlxText;

	override function create()
	{
		winText = new FlxText();
		winText.text = 'To Be Continued... \n You have completed all avalible levels. \n Press Enter to play again.';
		winText.alignment = CENTER;
		winText.screenCenter();

		add(winText);

		super.create();

		FlxG.camera.fade(FlxColor.BLACK, 3, true);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
		{
			pressStart();
		}

		super.update(elapsed);
	}

	function pressStart()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			CoolData.roomNumber = 1;
			FlxG.switchState(new gameplay.PlayState());
		});
	}
}
