package
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	public class BlobDisplayer extends Sprite
	{
		public function BlobDisplayer()
		{
			this.stage ? initialize() : this.addEventListener(Event.ADDED_TO_STAGE, initialize);	
		}
		
		private function initialize(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			this.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			this.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			this.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}
		
		protected function onTouchBegin(event:TouchEvent):void
		{
			var blob:Sprite = getBlob(event.touchPointID);
			if(blob) {
				blob.x = event.stageX;
				blob.y = event.stageY;
				this.addChild(blob);
			}
		}
		
		protected function onTouchMove(event:TouchEvent):void
		{
			var blob:Sprite = getBlob(event.touchPointID);
			if(blob) {
				blob.x = event.stageX;
				blob.y = event.stageY;
			}
		}
		
		protected function onTouchEnd(event:TouchEvent):void
		{			
			var blob:Sprite = getBlob(event.touchPointID);
			if(blob) {
				if(blob.stage) this.removeChild(blob);
				disposeBlob(event.touchPointID, blob);
			}
		}
		
		//------Object Pool------
		
		protected var _blobPool:Array = [];
		protected var _blobHash:Object = {};
		
		protected function getBlob(id:int):Sprite
		{
			var blob:Sprite = _blobHash[id.toString()];
			if(!blob) {
				blob = createBlob();
				_blobHash[id.toString()] = blob;
			}
			return blob;
		}
		
		protected function createBlob():Sprite
		{
			return _blobPool.pop() || new Blob(); 
		}
		
		protected function disposeBlob(id:int, blob:Sprite):void
		{
			_blobHash[id.toString()] = null;
			
			_blobPool.push(blob);
		}		
	}
}

