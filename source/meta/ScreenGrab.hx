package meta;

#if SCREENSHOTS_ALLOWED
import flixel.FlxBasic;
import flixel.FlxG;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class ScreenGrab extends FlxBasic
{
	static var grabDir:String = './screenshots/';

	public static function grab()
	{
		var bounds:Rectangle = new Rectangle(0, 0, FlxG.stage.stageWidth, FlxG.stage.stageHeight);

		var bitmap:Bitmap = new Bitmap(new BitmapData(Math.floor(bounds.width), Math.floor(bounds.height), true, 0x0));

		var m:Matrix = new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y);

		var hideMouse = FlxG.mouse.visible;
		FlxG.mouse.visible = false;

		var hideFps = Main.fpsVar.visible;
		Main.fpsVar.visible = false;

		bitmap.bitmapData.draw(FlxG.stage, m);

		FlxG.mouse.visible = hideMouse;
		Main.fpsVar.visible = hideFps;

		var png:ByteArray = new ByteArray();
		bitmap.bitmapData.encode(bounds, new openfl.display.JPEGEncoderOptions(), png);

		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		var path:String = grabDir + "Rooms_" + dateNow + ".png";

		if (!FileSystem.exists(grabDir))
			FileSystem.createDirectory(grabDir);

		File.saveBytes(path, png);
		Sys.println('Screenshot saved at $path');

		FlxG.cameras.list[FlxG.cameras.list.length - 1].flash();
	}
}
#end
