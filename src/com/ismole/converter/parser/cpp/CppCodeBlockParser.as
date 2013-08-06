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
			this.str += str;
		}
		
		public function parse():String
		{
			if (str.indexOf("{") != 0)
			{
				return null;
			}
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