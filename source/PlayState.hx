package;

import RoomData.Room;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	public static var curRoom:Room;

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

		startRoom();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function startRoom()
	{
		roomNumber += 1;
		/*if (roomNumber > 100)
			{
				FlxG.switchState(new CompleteState());
			}
			else
			{
				var levelList:Array<String> = Paths.getText('_levels/$roomNumber.txt').split('\n');
				curRoom = RoomData.getRoom(levelList[Std.random(levelList.length)]);
		}*/
	}
}
