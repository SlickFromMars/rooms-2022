package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.media.Sound;
import openfl.utils.Assets as OpenFlAssets;

/**
 * `Paths` is the custom pathing system for ROOMS.
 * Has various inlined functions for getting assets easily.
 */
class Paths
{
	private inline static var SOUND_EXT:String = #if web "mp3" #else "ogg" #end;

	/**
	 * Just adds the basic prefix to the file (usually assets/)
	 * @param file The path of the file.
	 * @return The new path.
	 */
	inline public static function getPath(file:String):String
	{
		return 'assets/$file';
	}

	/**
	 * Gets the path of a text file from the data folder.
	 * @param key The file title.
	 * @return The new path.
	 */
	inline static public function txt(key:String):String
	{
		return getPath('data/$key.txt');
	}

	/**
	 * Gets the path of a json file from the data folder.
	 * @param key The file title.
	 * @return The new path.
	 */
	inline static public function json(key:String):String
	{
		return getPath('data/$key.json');
	}

	/**
	 * Gets the path for a sound file and returns the sound asset.
	 * @param key The file title.
	 * @return Returns the `Sound`.
	 */
	inline static public function sound(key:String):Sound
	{
		var sound:Sound = returnSound('sounds', key);
		return sound;
	}

	/**
	 * Gets the path for a music file and returns the sound asset.
	 * @param key The file title.
	 * @return Returns the `Sound`.
	 */
	inline static public function music(key:String):Sound
	{
		var music:Sound = returnSound('music', key);
		return music;
	}

	/**
	 * Gets the path for an image file and returns the `FlxGraphic`.
	 * @param key The file title.
	 * @return Returns the `FlxGraphic`.
	 */
	inline static public function image(key:String):FlxGraphic
	{
		var returnAsset:FlxGraphic = returnGraphic(key);
		return (returnAsset);
	}

	/**
	 * Gets the path of a font file from the data folder.
	 * Note: Uses .ttf filetype
	 * @param key The file title.
	 * @return The new path.
	 */
	inline static public function font(key:String):String
	{
		return getPath('fonts/$key.ttf');
	}

	/**
	 * Adds the prefix to a file using `getPath`.
	 * Returns the file text contents
	 * @param key The file path.
	 * @return The text from the file.
	**/
	inline static public function getText(key:String):String
	{
		return OpenFlAssets.getText(getPath('$key'));
	}

	inline static public function getCoolText(key:String):Array<String>
	{
		var daList:Array<String> = getText(key).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	/**
		Returns the path to the ogmo file
	**/
	inline static public function getOgmo():String
	{
		return getPath('levels.ogmo');
	}

	/**
	 * Adds the prefix to a file using `getPath`.
	 * Returns whether the file exists or not
	 * @param key The path to the file
	 * @return Does it exist?	
	**/
	inline static public function fileExists(key:String):Bool
	{
		if (OpenFlAssets.exists(getPath(key)))
		{
			return true;
		}
		return false;
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

	static function returnGraphic(key:String)
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
		FlxG.log.warn('Could not find image at $path');
		return null;
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];

	static function returnSound(path:String, key:String)
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
		FlxG.log.warn('Could not find sound at $gottenPath');
		return null;
	}
}
