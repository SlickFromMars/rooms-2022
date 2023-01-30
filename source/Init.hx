package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.Frame.FrameState;
#if polymod
import polymod.Polymod;
#end

class Init extends FrameState
{
	var precacheList:Map<String, String> = new Map<String, String>();

	var infoText:FlxText;

	override function create()
	{
		FlxG.mouse.visible = false;

		#if polymod
		// Get all directories in the mod folder
		var modDirectory:Array<String> = [];
		var mods:Array<String> = sys.FileSystem.readDirectory("mods");

		for (fileText in mods)
		{
			if (sys.FileSystem.isDirectory("mods/" + fileText))
			{
				modDirectory.push(fileText);
			}
		}
		// trace(modDirectory);

		// Handle mod errors
		var errors = (error:PolymodError) ->
		{
			trace(error.severity + ": " + error.code + " - " + error.message + " - ORIGIN: " + error.origin);
		};

		// Initialize polymod
		var modMetadata = Polymod.init({
			modRoot: "mods",
			dirs: modDirectory,
			errorCallback: errors,
			framework: OPENFL,
			ignoredFiles: Polymod.getDefaultIgnoreList(),
			frameworkParams: {
				assetLibraryPaths: ["data" => "data", "images" => "images", "music" => "music", "sounds" => "sounds"]
			}
		});

		// Display active mods
		var loadedMods = "";
		for (modData in modMetadata)
		{
			loadedMods += modData.title + "";
		}

		if (modMetadata.length > 0)
		{
			var modText = new FlxText(2, 12, 0, "", 8);
			modText.text = "Loaded Mods: " + loadedMods;
			modText.color = FlxColor.WHITE;
			add(modText);
		}
		#end

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
				FrameState.switchState(new meta.states.OpeningState());
			});
		});
	}
}
