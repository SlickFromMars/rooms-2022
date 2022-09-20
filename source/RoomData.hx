package;

class Room
{
	public var name:String;

	public function new() {}
}

class RoomData
{
	public static function getRoom(key:String)
	{
		var myRoom:Room = new Room();

		myRoom.name = key.toLowerCase();
		return myRoom;
	}
}
