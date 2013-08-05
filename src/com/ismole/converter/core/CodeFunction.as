package com.ismole.converter.core
{
	public class CodeFunction extends CodeBase
	{
		public function CodeFunction()
		{
			super();
			indent = 2
		}
		
		/**
		 * 修饰符 ,默认Modifiers.M_PRIVATE
		 */		
		public var modifierName:String = Modifiers.M_PRIVATE;

		/**
		 * 代码块 
		 */		
		public var codeBlock:ICode;
		
		/**
		 * 是否是静态 ，默认false
		 */		
		public var isStatic:Boolean = false;
		
		/**
		 * 是否覆盖父级方法 ，默认false
		 */		
		public var isOverride:Boolean = false;
		private var _argumentBlock:Array = [];
		/**
		 * 添加参数
		 */		
		public function addArgument(argumentItem:ICode):void
		{
			for each(var item:CodeArguments in _argumentBlock)
			{
				if(item==argumentItem)
				{
					return;
				}
			}
			_argumentBlock.push(argumentItem);
		}
		
		/**
		 * 函数注释 
		 */		
		public var notation:CodeNotation;
		/**
		 * 函数名 
		 */		
		public var name:String = "";
		
		public var returnType:String = DataType.DT_VOID;
		
		override public function toCode():String
		{
			return CodeGenerateTemplete.getInstance().generate(this);
		}

		/**
		 *参数列表 
		 */
		public function get argumentBlock():Array
		{
			return _argumentBlock.concat();
		}

	}
}