package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import lime.app.Application;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.UncaughtErrorEvent;

using StringTools;

#if CRASH_LOGGER
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
#end
#if DISCORD_RPC
import meta.Discord.DiscordClient;
#end

class Main extends Sprite
{
	var initialState:Class<FlxState> = Init; // The FlxState the game starts with.

	// FPS stuff
	public static var fpsVar:FPS; // the counter ui
	public static var framerate:Int = 60; // How many frames per second the game should run at.

	public function new()
	{
		super();

		// Create the FlxGame to run the whole thing in
		addChild(new FlxGame(320, 240, initialState, framerate, framerate, false, false));

		#if debug
		FlxG.log.redirectTraces = true;
		#end

		// Initiate the FPS counter as long as you aren't on mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		fpsVar.visible = false;
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		// Add event listners
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);

		Application.current.window.onClose.add(function()
		{
			RoomsData.saveData();
		});

		#if DISCORD_RPC
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			Application.current.window.onClose.add(function()
			{
				DiscordClient.shutdown();
			});
		}
		#end
	}

	// Based off of code by squirra-rng
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		#if CRASH_LOGGER
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "Rooms_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}
		#end

		errMsg += "\nUncaught Error: "
			+ e.error
			+ "\nPlease report this error to the GitHub page: https://github.com/SlickFromMars/rooms-2022 \n\n> Crash Handler written by: sqirra-rng";

		#if CRASH_LOGGER
		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
		#end

		Application.current.window.alert(errMsg, "Error!");
		#if DISCORD_RPC
		DiscordClient.shutdown();
		#end
		RoomsData.saveData();
		#if CRASH_LOGGER
		Sys.exit(1);
		#end
	}
}
