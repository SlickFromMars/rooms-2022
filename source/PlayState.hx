package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var roomNumber:Int = 0;
	var player:Player;

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		player = new Player(20, 20);

		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);

		super.create();

		startRoom();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function startRoom()
	{
		roomNumber += 1;
	}
}
