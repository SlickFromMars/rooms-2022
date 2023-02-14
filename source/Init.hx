package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import meta.Frame.FrameState;
import meta.states.OpeningState;

using StringTools;

#if EASTER_EGG
import sys.FileSystem;
import sys.io.File;
#end
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

		#if EASTER_EGG
		if (!FileSystem.exists('./hints/'))
		{
			trace('Creating hints directory since it does not exist');
			FileSystem.createDirectory('./hints/');
		}

		hintPop('EGGHUNT',
			'In the menu, something is hidden.\nEnter combinations and press seven\nto access messages forbidden.\n\nThe following codes may be used:\n\n' +
			RoomsUtils.getText('data/eggList.txt'));
		#end

		super.create();

		#if CHECK_FOR_UPDATES
		if (mustUpdate)
			FrameState.switchState(new OutdatedState());
		else
			FrameState.switchState(new OpeningState());
		#else
		FrameState.switchState(new OpeningState());
		#end
	}

	#if EASTER_EGG
	function hintPop(file:String, content:String)
	{
		var path = 'hints/$file.txt';
		var exists = FileSystem.exists(path);
		File.saveContent(path, content);
		if (!exists)
		{
			Sys.command(FileSystem.absolutePath(path));
		}
	}
	#end
}
