package app.utils
{
	import com.adobe.nativeExtensions.Networkinfo.InterfaceAddress;
	import com.adobe.nativeExtensions.Networkinfo.NetworkInfo;
	import com.adobe.nativeExtensions.Networkinfo.NetworkInterface;
	
	public class NetworkUtil_iOS implements INetworkUtil
	{
		public function NetworkUtil_iOS()
		{
		}
		
		public function getNetworkInfo():String
		{
			var lines:Array = [];
			
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo;
			var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces(); 
			
			if( interfaces != null ) 
			{ 
				lines.push( "Interface count: " + interfaces.length ); 
				for each ( var interfaceObj:NetworkInterface in interfaces ) 
				{ 
					//lines.push( "\nname: "             + interfaceObj.name ); 
					lines.push( "display name: "     + interfaceObj.displayName ); 
					/*lines.push( "mtu: "                 + interfaceObj.mtu ); 
					lines.push( "active?: "             + interfaceObj.active ); 
					lines.push( "parent interface: " + interfaceObj.parent ); 
					lines.push( "hardware address: " + interfaceObj.hardwareAddress ); 
					if( interfaceObj.subInterfaces != null ) 
					{ 
					lines.push( "# subinterfaces: " + interfaceObj.subInterfaces.length ); 
					} 
					lines.push("# addresses: "     + interfaceObj.addresses.length ); 
					*/
					for each ( var address:InterfaceAddress in interfaceObj.addresses ) 
					{ 
						lines.push( "  type: "           + address.ipVersion ); 
						lines.push( "  address: "         + address.address ); 
						//lines.push( "  broadcast: "         + address.broadcast ); 
						//lines.push( "  prefix length: "     + address.prefixLength ); 
					} 
				}             
			}
			lines.push("------------------------");
			lines.push("");
			
			return lines.join('\n');
		}
	}
}