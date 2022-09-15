package;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	inline public static function getPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function txt(key:String)
	{
		return getPath('data/$key.txt');
	}

	inline static public function json(key:String)
	{
		return getPath('data/$key.json');
	}

	inline static public function sound(key:String)
	{
		return getPath('sounds/$key$SOUND_EXT');
	}

	inline static public function music(key:String)
	{
		return getPath('music/$key$SOUND_EXT');
	}

	inline static public function image(key:String)
	{
		return getPath('images/$key.png');
	}

	inline static public function font(key:String)
	{
		return getPath('fonts/$key.ttf');
	}
}
