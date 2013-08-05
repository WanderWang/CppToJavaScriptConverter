package com.ismole.converter.parser.common
{
	public class StringWordReader
	{
		private var str:String;
		private var index:int;
		private var result:String = "";
		public function StringWordReader(str:String)
		{
			this.str = str;
		}
		
		public function readWord():String
		{
			result = "";
			var hasWordFlag:Boolean = false;
			while (index < str.length)
			{
				var char:String = str.charAt(index);
				index++;

				if (isSepreter(char))
				{
					if (hasWordFlag)
					{
						return result;
					}
					else
					{
						continue;
					}
//					return result;
				}
				else
				{
					hasWordFlag = true;
					result += char;
				}
			}
			return result;
		}
		
		private function isSepreter(char:String):Boolean
		{
			if (char == "\n" || char == " " || char == "\t" || char == "(" || char == ")" || char == "," || char == ";")
			{
				return true;
			}
			if (char == ":")
			{
				var nextChar:String = str.charAt(index);
				if (nextChar != ":")
				{
					return true;
				}
				else
				{
					result += nextChar;
					index++;
					return false;
				}
			}
			return false;
			return 
		}
		
		public function hasNext():Boolean
		{
			return index < str.length;
		}
	}
}