package com.ismole.converter.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileUtils
	{
		public static function readTextFile(filePath:String):String
		{
			var file:File = new File(filePath);
			var stream:FileStream = new FileStream();
			stream.open(file,FileMode.READ);
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			return str;
		}
	}
}