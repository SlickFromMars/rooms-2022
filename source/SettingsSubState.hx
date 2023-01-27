package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUICheckBox;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class SettingsSubState extends FrameSubState
{
	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var grpUI:FlxSpriteGroup; // the ui group

	public function new()
	{
		super();

		FlxG.mouse.visible = true;

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		grpUI = new FlxSpriteGroup();

		var titleText = new FlxText(0, 2, 0, "Settings", 10);
		titleText.alignment = CENTER;
		titleText.screenCenter(X);

		var check_fullscreen = new FlxUICheckBox(0, titleText.height + 7, null, null, 'Fullscreen', 100);
		check_fullscreen.checked = FlxG.fullscreen;
		check_fullscreen.callback = function()
		{
			FlxG.fullscreen = check_fullscreen.checked;
			// trace('CHECKED!');
		};

		#if !mobile
		var check_fps = new FlxUICheckBox(0, check_fullscreen.height + check_fullscreen.height + 5, null, null, 'Show FPS', 100);
		check_fps.checked = Main.fpsVar.visible;
		check_fps.callback = function()
		{
			Main.fpsVar.visible = check_fps.checked;
			// trace('CHECKED!');
		};
		#end

		grpUI.add(titleText);
		grpUI.add(check_fullscreen);
		#if !mobile
		grpUI.add(check_fps);
		#end
		grpUI.screenCenter();
		titleText.screenCenter(X);
		add(grpUI);

		// set alpha
		bg.alpha = 0;

		// tween things and cameras
		FlxTween.tween(bg, {alpha: 1}, 0.3);
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if (Controls.BACK)
		{
			FlxG.mouse.visible = false;
			close();
		}
	}
}
