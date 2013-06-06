package
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	public class Blob extends Sprite
	{
		//public var id:int;
		
		public function Blob()
		{
			//this.id = id;
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
}