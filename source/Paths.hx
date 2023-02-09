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
	inline public static function getPath(file:String, ?library:Null<String> = null):String
	{
		if (library != null)
			return getLibraryPath(file, library);

		var sharedPath:String = getLibraryPathForce(file, 'shared');
		if (OpenFlAssets.exists(sharedPath))
			return sharedPath;

		return getPreloadPath(file);
	}

	inline public static function getLibraryPath(file:String, library:String = "preload"):String
	{
		if (library == "preload" || library == "default")
			return getPreloadPath(file);

		return getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String):String
	{
		return '$library:assets/$library/$file';
	}

	inline public static function getPreloadPath(file:String):String
	{
		return 'assets/$file';
	}

	/**
	 * Gets the path of a text file from the data folder.
	 * @param key The file title.
	 * @return The new path.
	 */
	inline static public function txt(key:String, ?library:String):String
	{
		return getPath('data/$key.txt', library);
	}

	/**
	 * Gets the path of a json file from the data folder.
	 * @param key The file title.
	 * @return The new path.
	 */
	inline static public function json(key:String, ?library:String):String
	{
		return getPath('$key.json', library);
	}

	/**
	 * Gets the path for a sound file and returns the `Sound`.
	 * @param key The file title.
	 * @return Returns the `Sound`.
	 */
	inline static public function sound(key:String, ?library:String):Sound
	{
		var sound:Sound = returnSound('sounds', key, library);
		return sound;
	}

	/**
	 * Gets the path for a music file and returns the `Sound`.
	 * @param key The file title.
	 * @return Returns the `Sound`.
	 */
	inline static public function music(key:String, ?library:String):Sound
	{
		var music:Sound = returnSound('music', key, library);
		return music;
	}

	/**
	 * Gets the path for an image file and returns the `FlxGraphic`.
	 * @param key The file title.
	 * @return Returns the `FlxGraphic`.
	 */
	inline static public function image(key:String, ?library:String):FlxGraphic
	{
		var returnAsset:FlxGraphic = returnGraphic(key, library);
		return (returnAsset);
	}

	/**
	 * Gets the path of a font file.
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
	 * Returns whether the file exists or not
	 * @param key The path to the file
	 * @return Does it exist?	
	**/
	inline static public function fileExists(key:String, ?library:String):Bool
	{
		if (OpenFlAssets.exists(getPath(key, library)))
		{
			return true;
		}
		return false;
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

	static function returnGraphic(key:String, ?library:String)
	{
		var path = getPath('images/$key.png', library);
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

	static function returnSound(path:String, key:String, ?library:String)
	{
		// oh the misery
		var gottenPath:String = getPath('$path/$key.$SOUND_EXT', library);
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
