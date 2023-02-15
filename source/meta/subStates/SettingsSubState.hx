package meta.subStates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUICheckBox;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameSubState;

class SettingsSubState extends FrameSubState
{
	var menuItems:Array<String> = ['Fullscreen', 'Show FPS'];
	var menuHold:Int = 5;

	// UI STUFF
	var bg:FlxSprite; // The bg for the state
	var grpUI:FlxSpriteGroup; // the ui group

	public function new()
	{
		super();

		#if debug
		menuItems.push('Retro Mode');
		#end

		FlxG.mouse.visible = true;

		// setup the UI
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		grpUI = new FlxSpriteGroup();

		var titleText = new FlxText(0, 2, 0, "Settings", 10);
		titleText.alignment = CENTER;
		titleText.screenCenter(X);

		var startY = 5 + titleText.y + titleText.height;
		for (item in menuItems)
		{
			var spr:FlxUICheckBox = new FlxUICheckBox(0, startY, null, null, item, 100);
			switch (item)
			{
				case 'Fullscreen':
					spr.checked = FlxG.fullscreen;
					spr.callback = function()
					{
						FlxG.fullscreen = spr.checked;
					}

				case 'Show FPS':
					spr.checked = Preferences.showFPS;
					spr.callback = function()
					{
						Preferences.showFPS = spr.checked;
						Preferences.savePrefs();
					}

				case 'Retro Mode':
					spr.checked = Preferences.retroMode;
					spr.callback = function()
					{
						Preferences.retroMode = spr.checked;
						Preferences.savePrefs();
					}
			}
			spr.screenCenter(X);
			grpUI.add(spr);
			startY += spr.height + 5;
		}

		grpUI.add(titleText);
		if (menuItems.length <= menuHold)
			grpUI.screenCenter(Y);
		add(grpUI);

		// set alpha
		bg.alpha = 0;

		// tween things and cameras
		FlxTween.tween(bg, {alpha: 1}, 0.3, {
			onComplete: function(twn:FlxTween)
			{
				allowConfirm = true;
			}
		});
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var allowConfirm:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if ((Controls.BACK || Controls.CONFIRM_TERTIARY) && allowConfirm)
		{
			FlxG.mouse.visible = false;
			Preferences.savePrefs();
			close();
		}
	}
}
