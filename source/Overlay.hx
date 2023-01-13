package;

import flixel.FlxSprite;

class Overlay extends FlxSprite
{
	public function new()
	{
		super();
		loadGraphic(Paths.image('overlay'));
	}

	public function updateScreenPos()
	{
		if (PlayState.player != null)
		{
			x = PlayState.player.getScreenPosition().x - width / 2;
			y = PlayState.player.getScreenPosition().y - height / 2;
		}
		else
		{
			screenCenter();
		}
	}
}
