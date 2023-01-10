package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends FrameSubState
{
	var grpMenu:FlxTypedGroup<FlxText>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Options', 'Exit To Menu'];
	var optionItemsOG:Array<String> = ['Toggle Fullscreen', 'Toggle FPS Counter'];
	var curSelected:Int = 0;

	public function new()
	{
		super();

		#if debug
		menuItemsOG.insert(1, 'Skip Level');

		optionItemsOG.insert(2, 'Toggle Show Overlay');
		#end

		optionItemsOG.push('Back');

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.alpha = 0;
		add(bg);

		// tweens and cameras
		FlxTween.tween(bg, {alpha: 0.7}, 0.3);

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
		if (FlxG.keys.anyJustPressed(CoolData.backKeys))
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
		else if (FlxG.keys.anyJustPressed(CoolData.upKeys))
		{
			changeSelection(-1);
		}
		else if (FlxG.keys.anyJustPressed(CoolData.downKeys))
		{
			changeSelection(1);
		}
		else if (FlxG.keys.anyJustPressed(CoolData.confirmKeys))
		{
			if (stopSpam == false)
			{
				stopSpam = true;
				switch (menuItems[curSelected])
				{
					case 'Resume':
						close();
					case 'Options':
						regenMenu('Options');
					case 'Exit To Menu':
						FlxG.switchState(new TitleState());
					case 'Skip Level':
						PlayState.completeLevel();
					case 'Toggle Fullscreen':
						FlxG.fullscreen = !FlxG.fullscreen;
					case 'Toggle FPS Counter':
						Main.fpsVar.visible = !Main.fpsVar.visible;
					case 'Toggle Show Overlay':
						PlayState.overlay.visible = !PlayState.overlay.visible;
					case 'Back':
						regenMenu();
				}
			}
		}
		else if (!FlxG.keys.anyJustPressed(CoolData.confirmKeys) && stopSpam == true)
		{
			stopSpam = false;
		}
	}

	function regenMenu(type:String = 'Base')
	{
		trace('Loading $type menu');

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
