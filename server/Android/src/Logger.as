package
{
	import flash.text.TextField;
	
	public class Logger
	{
		public static const DEBUG:int = 0;
		public static const INFO:int = 1;
		public static const WARN:int = 2;
		public static const ERROR:int = 3;
		
		public static var labels:Array = ["debug", "info", "warn", "error"];
		public static var mode:int = 0;
		public static var textField:TextField = new TextField();
		
		public static function log(msg:String, level:int=0):void
		{
			msg = "[" + labels[level] + "] " + msg;
			
			if(mode == 0) {
				trace(msg);
			}
			else if(mode == 1) {
				textField.appendText(msg + "\n");
				textField.scrollV = textField.maxScrollV;
			}
			else if(mode == 2) {
				//TODO:
			}
		}
		
	}
}