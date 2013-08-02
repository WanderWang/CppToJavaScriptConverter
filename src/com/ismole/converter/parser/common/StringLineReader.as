package com.ismole.converter.parser.common
{
	public class StringLineReader
	{
		private var str:String;
		private var index:int;
		public function StringLineReader(str:String)
		{
			this.str = str;
		}
		
		public function readLine():String
		{
			var result:String = "";
			while (index < str.length)
			{
				var char:String = str.charAt(index);
				index++;
				if (char == "\n")
				{
					return result;
				}
				result += char;
			}
			return result;
		}
		
		public function hasNext():Boolean
		{
			return index < str.length;
		}
	}
}