AS3-TouchRemote
===============
  It's a pain to compile the IPA file using Adobe AIR SDK (the compile time is too long). We have <strong>Interpreter Mode</strong> since AIR 2.7, but performance is not good when running the App under this mode.
  So I made this program to turn mobile device into input device for MultiTouch project development.
  
  WARNING: Lagging a little using network to transmit touch data :(
  
  TODO: support AccelerometerEvents?

Build
===============
<ul>
  <li><a href="http://labs.adobe.com/downloads/air.html" target="_blank">AIR 3.8 SDK</a> required.</li>
  <li>we need <a href="http://www.adobe.com/devnet/air/native-extensions-for-air/extensions/networkinfo.html" target="_blank">this ANE</a> to implement NetworksInfo API on iOS.</li>
</ul>

License
===============
  Copyright © 2013 civet, dreamana.com.  
  This program is released under <a href="http://opensource.org/licenses/mit-license.php" target="_blank">MIT License</a>.
