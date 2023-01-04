package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import lime.app.Application;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.UncaughtErrorEvent;

using StringTools;

#if !mobile
import openfl.display.FPS;
#end

class Main extends Sprite
{
	var gameWidth:Int = 320; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 240; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.

	public static var framerate:Int = 60; // How many frames per second the game should run at.

	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// Define the FPS counter variable
	#if !mobile
	public static var fpsVar:FPS;
	#end

	public function new()
	{
		super();

		// Create the FlxGame to run the whole thing in
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		#if debug
		FlxG.log.redirectTraces = true;
		#end

		// Initiate the FPS counter as long as you aren't on mobile
		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		#end

		#if html5
		FlxG.autoPause = false;
		#end

		// Add event listners
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		Application.current.window.onClose.add(onClose);
	}

	// Based off of code by squirra-rng
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "Uncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/BHS-TSA/video-game-design";
		Application.current.window.alert(errMsg, "Error!");
		onClose(); // save some things
		#if sys
		Sys.exit(1);
		#end
	}

	// do things when closing
	function onClose():Void
	{
		FlxG.save.data.fullscreen = FlxG.fullscreen;
		FlxG.save.flush();
	}
}
