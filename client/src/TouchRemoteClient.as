package
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	[SWF(width="768", height="1024", backgroundColor="#ffffff", frameRate="60")]
	
	public class TouchRemoteClient extends Sprite
	{
		public var client:Client;
		
		public function TouchRemoteClient()
		{
			this.stage ? initialize() : this.addEventListener(Event.ADDED_TO_STAGE, initialize);	
		}
		
		private function initialize(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//Logger
			setupLogger();
			
			//UI
			this.addChild(new BlobDisplayer());
			
			//Client
			client = new Client("192.0.0.128", 8686);
			client.onData = onData;
			client.start();
		}
		
		private function setupLogger():void
		{
			Logger.mode = 1;
			var output:TextField = Logger.textField;
			output.mouseEnabled = false;
			output.selectable = false;
			output.width = 768;
			output.height = 60;
			output.defaultTextFormat = new TextFormat("Arial", 12, 0x666666);
			output.backgroundColor = 0xffffcc;
			output.background = true;
			this.addChild(output);
		}
				
		private function onData(data:String):void
		{
			var blocks:Array = data.split("|");
			var num:int = blocks.length;
			for(var i:int=0; i<num; ++i)
			{
				var block:String = blocks[i];
				if(block && block != "")
				{
					var args:Array = block.split(",");
					
					var type:String = args[0];
					var id:int = parseInt( args[1] );
					var mx:int = parseInt( args[2] );
					var my:int = parseInt( args[3] );
					
					dispatchTouchEvent( getTarget(mx, my), type, id, mx, my);	
				}
			}
		}
				
		private var pt:Point = new Point();
		
		private function getTarget(x:Number, y:Number):DisplayObject
		{			
			var target:DisplayObject;
			pt.x = x;
			pt.y = y;
			var objects:Array = this.stage.getObjectsUnderPoint(pt);
			
			var i:int = objects.length;
			while(i--) {
				var obj:Object = objects[i];
				if(obj is InteractiveObject && !(obj is Blob)) {
					target = obj as DisplayObject;
					break;
				}
			}
			if(target == null) target = this.stage;
			return target;
		}
		
		private function dispatchTouchEvent(target:DisplayObject, eventType:String, pointID:int, stageX:int, stageY:int):void
		{
			var evt:TouchEvent = new TouchEvent(eventType, true, false, pointID);
			pt.x = stageX;
			pt.y = stageY;
			var localPoint:Point = target.globalToLocal(pt);
			evt.localX = localPoint.x;
			evt.localY = localPoint.y;
			//evt.stageX [ReadOnly]
			//evt.stageY [ReadOnly]
			target.dispatchEvent(evt);
		}
	}
}