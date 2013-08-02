package com.ismole.converter.parser.common
{
	public class StringWordReader
	{
		private var str:String;
		private var index:int;
		public function StringWordReader(str:String)
		{
			this.str = str;
		}
		
		public function readWord():String
		{
			var result:String = "";
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
			return char == "\n" || char == " " || char == "\t" || char == "(" || char == ")" || char == "," || char == ";";
		}
		
		public function hasNext():Boolean
		{
			return index < str.length;
		}
	}
}