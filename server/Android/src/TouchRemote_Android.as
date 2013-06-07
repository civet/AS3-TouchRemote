package
{
	import app.core.PolicyServer;
	import app.core.Server;
	import app.utils.INetworkUtil;
	import app.utils.NetworkUtil;
	
	import com.dreamana.air.SimpleTouchSimulator;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	[SWF(width="768", height="1024", backgroundColor="#000000", frameRate="60")]
	
	public class TouchRemote_Android extends Sprite
	{
		private var _server:Server;
		private var _policyServer:PolicyServer;
		private var _simulator:SimpleTouchSimulator;
		private var _initialized:Boolean;
		
		public function TouchRemote_Android()
		{
			setupLogger();
			
			showNetworkInfo();
			
			this.stage ? initialize() : this.addEventListener(Event.ADDED_TO_STAGE, initialize);	
		}
		
		private function initialize(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//handle activate & deactivate
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
			
			//multitouch
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, handleTouch);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, handleTouch);
			stage.addEventListener(TouchEvent.TOUCH_END, handleTouch);
			
			if(Multitouch.supportsTouchEvents) {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			}
			else {
				if(!_simulator) _simulator = new SimpleTouchSimulator(stage);
			}
			
			//server
			if(!_policyServer) _policyServer = new PolicyServer();
			_policyServer.start();
			
			if(!_server) _server = new Server();
			_server.start();
			
			_initialized = true;
		}
		
		private function finalize():void
		{
			//multitouch
			stage.removeEventListener(TouchEvent.TOUCH_BEGIN, handleTouch);
			stage.removeEventListener(TouchEvent.TOUCH_MOVE, handleTouch);
			stage.removeEventListener(TouchEvent.TOUCH_END, handleTouch);
			
			//server
			_policyServer.stop();
			_server.stop();
			
			_initialized = false;
		}
		
		private function setupLogger():void
		{
			Logger.mode = 1;
			
			var output:TextField = Logger.textField;
			output.defaultTextFormat = new TextFormat("Arial", 16, 0xffffff);
			output.mouseEnabled = false;
			output.selectable = false;
			output.width = 512;
			output.height = 512;
			this.addChild(output);
		}
		
		private function showNetworkInfo():void
		{
			var networkUtil:INetworkUtil;
			var os:String = Capabilities.os.toLowerCase();
			networkUtil = new NetworkUtil();
			
			Logger.log( networkUtil.getNetworkInfo() );
		}
		
		private function handleTouch(event:TouchEvent):void
		{
			//send touch data
			var data:String = event.type
				+ "," + event.touchPointID
				+ "," + event.stageX
				+ "," + event.stageY
				+ "|";
			_server.broadcast( data );
		}
		
		private function onDeactivate(event:Event):void
		{
			Logger.log("Deactivate.");
			
			finalize();
		}
		
		private function onActivate(event:Event):void
		{			
			Logger.log("Activate.");
			
			if(!_initialized) initialize();
		}
	}
}