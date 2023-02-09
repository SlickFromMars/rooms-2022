package;

import flixel.FlxG;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class RoomsUtils
{
	inline static public function getText(key:String, ?library:String):String
	{
		return OpenFlAssets.getText(Paths.getPath(key, library));
	}

	inline static public function getCoolText(key:String, ?library:String):Array<String>
	{
		var daList:Array<String> = getText(key, library).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function openURL(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}
