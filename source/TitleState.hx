package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class TitleState extends FlxState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	var logo:FlxText;
	var beginText:FlxText;

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		#end

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;

		logo = new FlxText(0, 0, 0, "ROOMS", 30);
		logo.screenCenter();

		beginText = new FlxText(0, FlxG.height - 60, 0, "PRESS ENTER TO BEGIN", 8);
		beginText.screenCenter(X);
		add(beginText);

		add(beginText);
		add(logo);

		super.create();

		FlxG.camera.fade(FlxColor.BLACK, 3, true);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed([ENTER]))
		{
			pressStart();
		}

		super.update(elapsed);
	}

	function pressStart()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			FlxG.switchState(new PlayState());
		});
	}
}
