package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class CacheState extends FrameState
{
	var precacheList:Map<String, String> = new Map<String, String>();

	var infoText:FlxText;

	override function create()
	{
		FlxG.mouse.visible = false;

		infoText = new FlxText(0, 0, FlxG.width, 'CACHING ASSETS', 16);
		infoText.screenCenter(Y);
		infoText.alignment = CENTER;

		// make the list
		precacheList.set('player', 'image');
		precacheList.set('tileset', 'image');
		precacheList.set('littleplanet', 'music');
		precacheList.set('newdawn', 'music');
		precacheList.set('november', 'music');

		super.create();

		add(infoText);

		// cache the stuff I think
		var cacheCap:Int = 0;
		for (i in precacheList)
		{
			cacheCap++;
		}
		var cacheCount:Int = 0;
		for (key => type in precacheList)
		{
			cacheCount++;
			infoText.text = 'CACHING ASSETS ' + cacheCount + '/' + cacheCap;
			// trace('Key $key is type $type');
			switch (type)
			{
				case 'image':
					Paths.image(key);
				case 'sound':
					Paths.sound(key);
				case 'music':
					Paths.music(key);
			}
		}

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.1, false, function()
			{
				FrameState.switchState(new OpeningState());
			});
		});
	}
}
