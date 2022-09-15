package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class TitleState extends FlxState
{
	var logo:FlxText;
	var playButton:FlxButton;

	override public function create()
	{
		logo = new FlxText(0, 0, 0, "ROOMS", 100);
		logo.screenCenter();

		playButton = new FlxButton(0, FlxG.height - 100, "Play", clickPlay);
		playButton.screenCenter(X);

		add(playButton);
		add(logo);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}
}
