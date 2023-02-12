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
#if discord_rpc
import meta.Discord.DiscordClient;
#end

class Main extends Sprite
{
	var gameWidth:Int = 320; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 240; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = Init; // The FlxState the game starts with.

	public static var framerate:Int = 60; // How many frames per second the game should run at.

	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// Define the FPS counter variable
	public static var fpsVar:FPS;

	public function new()
	{
		super();

		// Create the FlxGame to run the whole thing in
		addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));

		#if debug
		FlxG.log.redirectTraces = true;
		#end

		// Initiate the FPS counter as long as you aren't on mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		#if !debug
		Main.fpsVar.visible = false;
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		// Add event listners
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);

		#if discord_rpc
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
			+ "\nPlease report this error to the GitHub page: https://github.com/SlickFromMars/rooms-2022\n\n> Crash Handler written by: sqirra-rng";

		#if CRASH_LOGGER
		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
		#end

		Application.current.window.alert(errMsg, "Error!");
		#if discord_rpc
		DiscordClient.shutdown();
		#end
		#if CRASH_LOGGER
		Sys.exit(1);
		#end
	}
}
