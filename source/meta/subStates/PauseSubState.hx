package meta.subStates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.Frame.FrameState;
import meta.Frame.FrameSubState;

class PauseSubState extends FrameSubState
{
	var grpMenu:FlxTypedGroup<FlxText>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Options', 'Exit To Menu'];
	var optionItemsOG:Array<String> = ['Toggle Fullscreen'];
	var curSelected:Int = 0;

	public function new()
	{
		super();

		optionItemsOG.insert(1, 'Toggle FPS Counter');

		#if debug
		menuItemsOG.insert(1, 'Skip Level');
		#end

		optionItemsOG.push('Back');

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.alpha = 0;
		add(bg);

		// tweens and cameras
		FlxTween.tween(bg, {alpha: 1}, 0.3);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		// final setup
		grpMenu = new FlxTypedGroup<FlxText>();
		add(grpMenu);

		regenMenu();
	}

	var stopSpam:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Key checking
		if (Controls.BACK)
		{
			if (menuItems.contains('Back'))
			{
				regenMenu();
			}
			else
			{
				close();
			}
		}
		else if (Controls.UI_UP)
		{
			changeSelection(-1);
		}
		else if (Controls.UI_DOWN)
		{
			changeSelection(1);
		}
		else if (Controls.CONFIRM)
		{
			if (!stopSpam)
			{
				stopSpam = true;
				switch (menuItems[curSelected])
				{
					case 'Resume':
						close();
					case 'Options':
						regenMenu('Options');
					case 'Exit To Menu':
						FlxG.sound.music.stop();
						FrameState.switchState(new meta.states.TitleState());
					case 'Skip Level':
						meta.states.PlayState.completeLevel();
					case 'Toggle Fullscreen':
						FlxG.fullscreen = !FlxG.fullscreen;
					case 'Toggle FPS Counter':
						Main.fpsVar.visible = !Main.fpsVar.visible;
					case 'Back':
						regenMenu();
				}
			}
		}
		else if (!Controls.CONFIRM && stopSpam)
		{
			stopSpam = false;
		}
	}

	function regenMenu(type:String = 'Base')
	{
		switch (type)
		{
			case 'Base':
				menuItems = menuItemsOG;
			case 'Options':
				menuItems = optionItemsOG;
		}

		for (i in 0...grpMenu.members.length)
		{
			var obj = grpMenu.members[0];
			obj.kill();
			grpMenu.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length)
		{
			var item:FlxText = new FlxText(0, (i * 30), 0, menuItems[i], 12);
			item.screenCenter(X);
			item.y += (FlxG.height - ((menuItems.length - 1) * 30)) / 2;
			grpMenu.add(item);
		}

		curSelected = 0;
		changeSelection();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		for (i in 0...grpMenu.members.length)
		{
			var obj = grpMenu.members[i];
			obj.alpha = 0.6;
			if (i == curSelected)
			{
				obj.alpha = 1;
			}
		}
	}
}
