package app.core
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class PolicyServer
	{
		private var _serverSocket:ServerSocket;
		private var _address:String;
		private var _port:int;
		private var _toPort:int;
		
		public function PolicyServer(address:String="0.0.0.0", port:int=843, toPort:int=8686)
		{
			_address = address;
			_port = port;
			
			_toPort = toPort;
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
			
			Logger.log("PolicyServer started " + _address + ":" + _port);
		}
		
		public function stop():void
		{
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
			
			Logger.log("Client request policy " + client.remoteAddress + ":" + client.remotePort);
		}
		
		private function onClientData(event:ProgressEvent):void
		{
			var client:Socket = event.currentTarget as Socket;
			
			var buffer:ByteArray = new ByteArray();
			client.readBytes( buffer, 0, client.bytesAvailable );
			
			//Logger.log("received: " + buffer.toString() +"\n\n");
			//received: <policy-file-request/>
			
			//send policy file
			var policyFile:String = '<cross-domain-policy><allow-access-from domain="*" to-ports="' + _toPort + '" /></cross-domain-policy>';
			this.send(client, policyFile);
		}
		
		public function send(client:Socket, message:String):void
		{
			try
			{
				if( client && client.connected )
				{
					client.writeUTFBytes( message );
					client.flush();
					
					//close
					client.removeEventListener(ProgressEvent.SOCKET_DATA, onClientData);
					try { client.close(); } catch(error:Error) {}
				}
			}
			catch ( error:Error )
			{
				Logger.log( error.message );
			}
		}
		
		public function get running():Boolean { return _serverSocket.listening; }
	}
}