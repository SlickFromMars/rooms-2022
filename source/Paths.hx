package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.media.Sound;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	inline public static var SOUND_EXT:String = #if web "mp3" #else "ogg" #end;

	inline public static function getPath(file:String):String
	{
		return 'assets/$file';
	}

	inline static public function txt(key:String):String
	{
		return getPath('data/$key.txt');
	}

	inline static public function json(key:String):String
	{
		return getPath('data/$key.json');
	}

	inline static public function sound(key:String):Sound
	{
		var sound:Sound = returnSound('sounds', key);
		return sound;
	}

	inline static public function music(key:String):Sound
	{
		var music:Sound = returnSound('music', key);
		return music;
	}

	inline static public function image(key:String):FlxGraphic
	{
		// Asset streamlining
		var returnAsset:FlxGraphic = returnGraphic(key);
		return (returnAsset);
	}

	inline static public function font(key:String):String
	{
		return getPath('fonts/$key.ttf');
	}

	inline static public function getText(key:String):String
	{
		return OpenFlAssets.getText(getPath('data/$key'));
	}

	inline static public function getOgmo():String
	{
		return getPath('levels.ogmo');
	}

	inline static public function fileExists(key:String):Bool
	{
		if (OpenFlAssets.exists(getPath(key)))
		{
			return true;
		}
		return false;
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

	public static function returnGraphic(key:String)
	{
		var path = getPath('images/$key.png');
		if (OpenFlAssets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(path))
			{
				var graphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
				graphic.persist = true;
				currentTrackedAssets.set(path, graphic);
			}
			return currentTrackedAssets.get(path);
		}
		trace('null return waaaaaaaaaaaaah');
		return null;
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];

	public static function returnSound(path:String, key:String)
	{
		// oh the misery
		var gottenPath:String = getPath('$path/$key.$SOUND_EXT');
		if (OpenFlAssets.exists(gottenPath, SOUND))
		{
			if (!currentTrackedSounds.exists(gottenPath))
			{
				var sound = OpenFlAssets.getSound(gottenPath);
				currentTrackedSounds.set(gottenPath, sound);
			}
			return currentTrackedSounds.get(gottenPath);
		}
		trace('null return waaaaaaaaaaaaah');
		return null;
	}
}
