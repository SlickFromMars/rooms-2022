package;

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

	inline static public function sound(key:String):String
	{
		return getPath('sounds/$key.$SOUND_EXT');
	}

	inline static public function music(key:String):String
	{
		return getPath('music/$key.$SOUND_EXT');
	}

	inline static public function image(key:String):String
	{
		return getPath('images/$key.png');
	}

	inline static public function font(key:String):String
	{
		return getPath('fonts/$key.ttf');
	}

	inline static public function character(key:String):String
	{
		return getPath('images/characters/$key');
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
}
