package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import meta.Frame.FrameState;
import meta.states.OpeningState;

using StringTools;

#if CHECK_FOR_UPDATES
import meta.states.OutdatedState;
#end
#if polymod
import polymod.Polymod;
#end

class Init extends FrameState
{
	public static var gameVersion:String;

	var mustUpdate:Bool = false;
	var precacheList:Map<String, CacheFileType> = new Map<String, CacheFileType>(); // file name, then type

	var infoText:FlxText;

	override function create()
	{
		FlxG.mouse.visible = false;

		// Initiate the volume keys
		FlxG.sound.muteKeys = [NUMPADZERO, ZERO];
		FlxG.sound.volumeDownKeys = [NUMPADMINUS, MINUS];
		FlxG.sound.volumeUpKeys = [NUMPADPLUS, PLUS];

		// do the save stuff
		if (FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}

		gameVersion = Application.current.meta.get('version');

		#if CHECK_FOR_UPDATES
		trace('Checking for update.');
		var http = new haxe.Http("https://raw.githubusercontent.com/SlickFromMars/rooms-2022/main/gitVersion.txt");

		http.onData = function(data:String)
		{
			OutdatedState.updateVersion = data.split('\n')[0].trim();
			var curVersion:String = Init.gameVersion;
			trace('version online: ' + OutdatedState.updateVersion + ', your version: ' + curVersion);

			if (OutdatedState.updateVersion != curVersion)
			{
				trace('versions arent matching!');
				mustUpdate = true;
			}
		}

		http.onError = function(error)
		{
			trace('error: $error');
		}

		http.request();
		#end

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
				assetLibraryPaths: [
					"data" => "data",
					"images" => "images",
					"music" => "music",
					"sounds" => "sounds",
					"levels" => "levels",
					"shared" => "shared"
				]
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
		precacheList.set('logo', IMAGE);
		precacheList.set('player', IMAGE);
		precacheList.set('tileset', IMAGE);
		precacheList.set('hint/paper', IMAGE);
		precacheList.set('littleplanet', MUSIC);
		precacheList.set('newdawn', MUSIC);
		precacheList.set('november', MUSIC);

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
				case IMAGE:
					Paths.image(key);
				case MUSIC:
					Paths.music(key);
			}
		}

		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.1, false, function()
			{
				#if CHECK_FOR_UPDATES
				if (mustUpdate)
					FrameState.switchState(new OutdatedState());
				else
					FrameState.switchState(new OpeningState());
				#else
				FrameState.switchState(new OpeningState());
				#end
			});
		});
	}
}

enum CacheFileType
{
	IMAGE;
	MUSIC;
}
