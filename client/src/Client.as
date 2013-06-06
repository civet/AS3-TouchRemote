package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public class Client
	{
		private var _socket:Socket;
		private var _address:String;
		private var _port:int;
		
		public function Client(address:String, port:int)
		{
			_socket = new Socket();
			_address = address;
			_port = port;
		}
		
		public function start():void
		{
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.addEventListener(Event.CLOSE, onServerClose);
			_socket.connect(_address, _port);
		}
		
		private function onConnect(event:Event):void
		{
			Logger.log( "Connected!");
		}
		
		private function onSocketData(event:ProgressEvent):void
		{
			var message:String = _socket.readUTFBytes(_socket.bytesAvailable);
			
			//Logger.log( message );
			
			if(onData != null) onData( message );
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			Logger.log( event.text );
			
			Logger.log( "Reconnect after 5 sec...");
			setTimeout(_socket.connect, 5000, _address, _port);
		}
		
		private function onServerClose(event:Event):void
		{
			Logger.log( "Server closed." );
			Logger.log( "Reconnect after 5 sec..." );
			
			setTimeout(_socket.connect, 5000, _address, _port);
		}
		
		public function get connected():Boolean { return _socket.connected; }
		
		public var onData:Function;
	}
}