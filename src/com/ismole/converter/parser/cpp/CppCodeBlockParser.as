package com.ismole.converter.parser.cpp
{
	public class CppCodeBlockParser
	{
		private var str:String = "";
		private var index:int = 0;
		private var bracesCount:int = 0;
		public function CppCodeBlockParser()
		{
		}
		
		public function add(str:String):void
		{
			if (this.str.length == 0 && str.indexOf("{") == -1) return;
			this.str += str;
		}
		
		public function parse():String
		{
			if (str == "")
			{
				return null;
			}
			while (index < str.length)
			{
				var char:String = str.charAt(index);
				if (char == ";")
				{
					var x:int;
				}
				if (char == "{")
				{
					bracesCount++;
				}
				else if (char == "}")
				{
					bracesCount--;
				}
				if (bracesCount == 0)
				{
					str = str.substr(0,index + 1);
					var strArr:Array = str.split("\n");
					var temp:String = "";
					while (temp.indexOf("}") == -1)
					{
						temp = strArr.pop();
					}
					strArr.shift();
					return strArr.join("\n");
				}
				index++;
			}
			return null;

		}
	}
}