package com.ismole.converter.core
{
	
	public class CodeVariable extends CodeBase
	{
		public function CodeVariable(name:String = "varName",modifierName:String="public",
			type:CodeType = null,defaultValue:String="",
			isStatic:Boolean = false,isConst:Boolean=false,metadata:String="")
		{
			super();
			indent = 2;
			this.name = name;
			this.modifierName = modifierName;
			this.type = ( type == null ) ? new CodeType() : type;
			this.isStatic = isStatic;
			this.isConst = isConst;
			this.defaultValue = defaultValue;
			this.metadata = metadata;
		}
		
		/**
		 * 变量之前的原标签声明 
		 */		
		public var metadata:String = "";
		/**
		 * 修饰符 
		 */		
		public var modifierName:String = Modifiers.M_PUBLIC;
		
		/**
		 * 是否是静态 
		 */		
		public var isStatic:Boolean = false;
		
		/**
		 * 是否是常量 
		 */		
		public var isConst:Boolean = false;
		
		/**
		 * 常量名 
		 */		
		public var name:String = "varName";
		/**
		 * 默认值 
		 */		
		public var defaultValue:String = "";
		
		/**
		 * 数据类型 
		 */		
		public var type:CodeType = new CodeType();
		
		/**
		 * 变量注释 
		 */		
		public var notation:CodeNotation;
		
		override public function toCode():String
		{
			return CodeGenerateTemplete.getInstance().generate(this);
		}
	}
}