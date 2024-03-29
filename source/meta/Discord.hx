package meta;

#if DISCORD_RPC
import Sys.sleep;
import discord_rpc.DiscordRpc;
import lime.app.Application;

class DiscordClient
{
	public static var isInitialized:Bool = false;

	public function new()
	{
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: '1055615959366385744',
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			// trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
	}

	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}

	static function onReady()
	{
		DiscordRpc.presence({
			details: "Preparing For Adventure",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "ROOMS"
		});
	}

	static function onError(_code:Int, _message:String)
	{
		Application.current.window.alert('$_code : $_message', "Error!");
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
		isInitialized = true;
	}

	public static function changePresence(details:String, state:Null<String>)
	{
		var tempImage:String = "icon";
		var tempTitle:String = "ROOMS";

		#if debug
		tempImage = "debug";
		tempTitle = "ROOMS - Debug Build";
		#end

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: tempImage,
			largeImageText: tempTitle
		});
	}
}
#end
