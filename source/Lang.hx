package;

import openfl.utils.Assets as OpenFlAssets;

class Lang
{
	public static var localization:String = 'en_us';
	public static var currentTrackedLang:Map<String, String> = [];

	/**
	 * Finds the path of a language file and returns the text.
	 * @param key The file title.
	 * @return The text in the file.	
	 */
	inline static public function text(key:String):String
	{
		var path = 'lang/$localization/$key.txt';
		if (OpenFlAssets.exists(Paths.getPath(path)))
		{
			if (!currentTrackedLang.exists(path))
			{
				var data = Paths.getText(path);
				currentTrackedLang.set(path, data);
			}
			return (currentTrackedLang.get(path));
		}
		trace('Could not find $path');
		return path; // use this as a placeholder
	}
}
