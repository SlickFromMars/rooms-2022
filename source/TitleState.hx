package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import lime.app.Application;

class TitleState extends FlxState
{
	var logo:FlxText;
	var versionText:FlxText;
	var playButton:FlxButton;

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		#end

		logo = new FlxText(0, 0, 0, "ROOMS", 100);
		logo.screenCenter();

		playButton = new FlxButton(0, FlxG.height - 100, "Play", clickPlay);
		playButton.screenCenter(X);

		versionText = new FlxText(12, FlxG.height - 24, 0, "v" + Application.current.meta.get('version'), 12);
		versionText.scrollFactor.set();
		versionText.setFormat(Paths.font('sans'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		add(versionText);

		add(playButton);
		add(logo);

		super.create();

		FlxG.camera.fade(FlxColor.BLACK, 3, true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function clickPlay()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			FlxG.switchState(new PlayState());
		});
	}
}
