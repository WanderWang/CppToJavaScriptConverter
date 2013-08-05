package com.ismole.converter.core
{
	public class CodeType extends CodeBase
	{
		public var name:String = DataType.DT_OBJECT;
		public function CodeType(name:String = "Object")
		{
			this.name = name.replace("*","");
			super();
		}
		
		override public function toCode():String
		{
			return CodeGenerateTemplete.getInstance().generate(this);
		}
		
	}
}