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
		infoText = new FlxText(0, 0, FlxG.width, 'CACHING ASSETS', 16);
		infoText.screenCenter(Y);
		infoText.alignment = CENTER;

		// make the list
		precacheList.set('littleplanet', 'music');
		precacheList.set('newdawn', 'music');
		precacheList.set('november', 'music');

		super.create();

		add(infoText);

		// cache the stuff I think
		var cacheCount:Int = 0;
		for (key => type in precacheList)
		{
			cacheCount++;
			infoText.text = 'CACHING ASSETS ' + cacheCount + '/3';
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
			trace('Cached $key');
		}

		// trace(Paths.currentTrackedAssets.toString());
		// trace(Paths.currentTrackedSounds.toString());

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.1, false, function()
			{
				FrameState.switchState(new OpeningState());
			});
		});
	}
}
