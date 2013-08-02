package com.ismole.converter.core
{

	/**
	 * 参数定义
	 * 
	 */	
	public class CodeArguments extends CodeBase
	{
		public function CodeArguments(name:String = "",type:String = "")
		{
			super();
			this.name = name;
			this.type = type;
		}
		
		public var name:String = "";
		
		public var type:String = "";
		
		override public function toCode():String
		{
			return name+":"+type;
		}
	}
}