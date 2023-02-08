package meta.subStates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUICheckBox;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.Frame.FrameSubState;

class SettingsSubState extends FrameSubState
{
	var menuItems:Array<String> = ['Fullscreen', 'Show FPS', 'Retro Mode'];
	var menuHold:Int = 5;

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

		#if debug
		menuItems.push('Redirect Traces');
		#end

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
					spr.checked = Main.fpsVar.visible;
					spr.callback = function()
					{
						Main.fpsVar.visible = spr.checked;
					}

				case 'Retro Mode':
					spr.checked = RoomsData.retroMode;
					spr.callback = function()
					{
						RoomsData.retroMode = spr.checked;
					}

				case 'Redirect Traces':
					spr.checked = FlxG.log.redirectTraces;
					spr.callback = function()
					{
						FlxG.log.redirectTraces = spr.checked;
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
		FlxTween.tween(bg, {alpha: 1}, 0.3);
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			allowConfirm = true;
		});
	}

	var allowConfirm:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check to see if the player wants to exit
		if ((Controls.BACK || Controls.CONFIRM_TERTIARY) && allowConfirm)
		{
			FlxG.mouse.visible = false;
			close();
		}
	}
}
