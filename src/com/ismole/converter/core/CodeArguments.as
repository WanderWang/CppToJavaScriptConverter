package com.ismole.converter.core
{

	/**
	 * 参数定义
	 * 
	 */	
	public class CodeArguments extends CodeBase
	{
		public function CodeArguments(name:String = "",type:CodeType = null)
		{
			super();
			this.name = name;
			this.type = type == null ? new CodeType() : type;
		}
		
		public var name:String = "";
		
		public var type:CodeType = new CodeType();
		
		override public function toCode():String
		{
			return CodeGenerateTemplete.getInstance().generate(this);
		}
	}
}