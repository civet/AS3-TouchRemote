package com.dreamana.air
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class SimpleTouchSimulator
	{
		private var stage:Stage;
		private var pointID:int = 1;
		
		public function SimpleTouchSimulator(stage:Stage)
		{
			this.stage = stage;
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		
		
		private function onMouseDown(e:MouseEvent):void
		{
			if(e.target is Blob) return;
			
			var id:int = pointID++
			
			//TOUCH_BEGIN
			var target:DisplayObject = e.target as DisplayObject;
			this.dispatch(target, TouchEvent.TOUCH_BEGIN, id);
			
			var blob:Sprite = new Blob(id);
			blob.x = stage.mouseX;
			blob.y = stage.mouseY;
			stage.addChild(blob);
			blob.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
		}
		
		private var draggingBlob:Blob;
		private function onDrag(e:MouseEvent):void
		{
			var blob:Blob = e.currentTarget as Blob;
			
			if(e.shiftKey) {
				this.stage.removeChild(blob);
				
				//TOUCH_END
				var target:DisplayObject = this.getTarget(blob.x, blob.y);
				this.dispatch(target, TouchEvent.TOUCH_END, blob.id);
			}
			else {
				draggingBlob = blob;
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);            
			}
		}
		
		private function onMove(e:MouseEvent):void
		{
			draggingBlob.x = stage.mouseX;
			draggingBlob.y = stage.mouseY;
			
			//TOUCH_MOVE
			var target:DisplayObject = this.getTarget(draggingBlob.x, draggingBlob.y);
			this.dispatch(target, TouchEvent.TOUCH_MOVE, draggingBlob.id);
		}
		
		private function onDrop(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SPACE) {
				var i:int = this.stage.numChildren;
				while(i--) {
					var child:DisplayObject = this.stage.getChildAt(i);
					if(child is Blob) {
						var blob:Blob = child as Blob;
						this.stage.removeChild(blob);
						
						//TOUCH_END
						var target:DisplayObject = this.getTarget(blob.x, blob.y);
						this.dispatch(target, TouchEvent.TOUCH_END, blob.id);
					}
				}
			}
		}
		
		private function getTarget(x:Number, y:Number):DisplayObject
		{
			var target:DisplayObject;
			var objects:Array = this.stage.getObjectsUnderPoint(new Point(x, y));
			
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
		
		private function dispatch(target:DisplayObject, eventType:String, pointID:int):void
		{
			var evt:TouchEvent = new TouchEvent(eventType, true, false, pointID);
			evt.localX = target.mouseX;
			evt.localY = target.mouseY;
			/*
			var localPoint:Point = new Point(target.mouseX, target.mouseY);
			var globalPoint:Point = target.localToGlobal(localPoint);
			evt.localX = localPoint.x;
			evt.localY = localPoint.y;
			evt.stageX = globalPoint.x;//readOnly
			evt.stageY = globalPoint.y;//readOnly
			*/
			target.dispatchEvent(evt);
		}
	}
}

import flash.display.Sprite;
import flash.filters.GlowFilter;

class Blob extends Sprite
{
	public var id:int;
	public function Blob(id:int)
	{
		this.id = id;
		this.graphics.beginFill(0x0, 0);
		this.graphics.drawCircle(0, 0, 20);
		
		this.graphics.endFill();
		this.graphics.beginFill(0xffffff);//0x00aeff
		this.graphics.drawCircle(0, 0, 20);
		this.graphics.drawCircle(0, 0, 15);
		this.graphics.endFill();
		this.filters = [new GlowFilter(0x0, 1.0, 4, 4, 1)];
	}
}

/*
import flash.events.Event;

class TouchEvent extends Event
{
	public static const TOUCH_BEGIN:String = "touchBegin";
	public static const TOUCH_MOVE:String = "touchMove";
	public static const TOUCH_END:String = "touchEnd";
	
	public var touchPointID:int;
	public var localX:Number;
	public var localY:Number;
	public var stageX:Number;
	public var stageY:Number;
	public function TouchEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, touchPointID:int=0)
	{
		this.touchPointID = touchPointID;
		super(type, bubbles, cancelable);
	}
}*/