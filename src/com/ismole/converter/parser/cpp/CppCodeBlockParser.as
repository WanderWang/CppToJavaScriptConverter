package com.ismole.converter.parser.cpp
{
	public class CppCodeBlockParser
	{
		private var str:String = "";
		public function CppCodeBlockParser()
		{
		}
		
		public function add(str:String):void
		{
			this.str += str;
		}
		
		public function parse():String
		{
			if (str.indexOf("{") != 0)
			{
				return null;
			}
			var index:int = 0;
			var keywords:String = "";
			var bracesCount:int = 0;
			while (index <= str.length)
			{
				var char:String = str.charAt(index);
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
					return str.substr(0,index);
				}
				index++;
			}
			return null;

		}
	}
}