package app.core
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class Server
	{
		private var _serverSocket:ServerSocket;
		private var _address:String;
		private var _port:int;
		private var _clients:Array = [];
		
		public function Server(address:String="0.0.0.0", port:int=8686)
		{
			_address = address;
			_port = port;
		}
		
		public function start():void
		{
			if(_serverSocket == null) {
				_serverSocket = new ServerSocket();
			}
			
			try {
				_serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onClientConnect);
				_serverSocket.bind(_port, _address);
				_serverSocket.listen();
			}
			catch(e:Error) {
				Logger.log(e.message);	
			}
			
			Logger.log("Server started " + _address + ":" + _port);
		}
		
		public function stop():void
		{
			var client:Socket;
			var i:int = _clients.length;
			while(i--) {
				client = _clients[i];
				
				client.removeEventListener(ProgressEvent.SOCKET_DATA, onClientData);
				try { client.close(); } catch(error:Error) {}
			}
			_clients.length = 0;
			
			try {
				_serverSocket.removeEventListener(ServerSocketConnectEvent.CONNECT, onClientConnect);
				_serverSocket.close();
				_serverSocket = null;
			}
			catch(e:Error) {
				Logger.log(e.message);
			}
		}
		
		private function onClientConnect(event:ServerSocketConnectEvent):void
		{
			var client:Socket = event.socket;
			client.addEventListener(ProgressEvent.SOCKET_DATA, onClientData);
			
			_clients.push( client );
			
			Logger.log("Client joined " + client.remoteAddress + ":" + client.remotePort);
		}
		
		private function onClientData(event:ProgressEvent):void
		{
			var client:Socket = event.currentTarget as Socket;
			
			var buffer:ByteArray = new ByteArray();
			client.readBytes( buffer, 0, client.bytesAvailable );
			
			Logger.log("Client Data Received: " + buffer.toString());
		}
		
		public function broadcast(message:String):void
		{
			var client:Socket;
			var i:int = _clients.length;
			while(i--) {
				client = _clients[i];
				
				this.send(client, message);
			}	
		}
		
		public function send(client:Socket, message:String):void
		{
			try
			{
				if( client && client.connected )
				{
					client.writeUTFBytes( message );
					client.flush();
				}
				else {
					//kick it					
					var index:int = _clients.indexOf(client);
					if(index >= 0) _clients.splice(index, 1);
					
					client.removeEventListener(ProgressEvent.SOCKET_DATA, onClientData);
					try { client.close(); } catch(error:Error) {}
				}
			}
			catch ( error:Error )
			{
				Logger.log( error.message );
			}
		}
		
		public function get clients():Array { return _clients; }
		
		public function get running():Boolean { return _serverSocket.listening; }
	}
}