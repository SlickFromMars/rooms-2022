package gameplay;

import flixel.FlxSprite;

class Overlay extends FlxSprite
{
	public function new()
	{
		super(x, y);

		// Load the thingy
		loadGraphic(Paths.image('ui/overlay'));
	}

	override function update(elapsed:Float)
	{
		// Update the position
		if (PlayState.player != null)
		{
			x = PlayState.player.getScreenPosition().x - width / 2;
			y = PlayState.player.getScreenPosition().y - height / 2;
		}
		else
		{
			screenCenter();
		}
		visible = CoolData.overlayShown;

		super.update(elapsed);
	}
}
