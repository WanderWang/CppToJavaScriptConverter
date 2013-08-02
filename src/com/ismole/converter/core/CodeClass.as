package com.ismole.converter.core
{
	

	/**
	 * 类定义
	 * 
	 */	
	public class CodeClass extends CodeBase
	{
		public function CodeClass()
		{
			super();
			indent = 1;
		}
		private var _argumentBlock:Array = [];
		/**
		 * 添加构造函数的参数
		 */		
		public function addArgument(argumentItem:CodeArguments):void
		{
			for each(var item:CodeArguments in _argumentBlock)
			{
				if(item==argumentItem)
				{
					return ;
				}
			}
			_argumentBlock.push(argumentItem);
		}
		/**
		 * 构造函数代码块 
		 */		
		public var constructCode:CodeBlock;
		/**
		 * 类名 
		 */		
		public var className:String = "CpClass";
		
		/**
		 * 包名 
		 */		
		public var packageName:String = "";
		
		/**
		 * 修饰符 
		 */		
		public var modifierName:String = Modifiers.M_PUBLIC;
		
		/**
		 * 父类类名 
		 */		
		public var superClass:CodeType = new CodeType();
		
		private var _interfaceBlock:Array = [];
		
		/**
		 * 添加接口
		 */		
		public function addInterface(interfaceName:String):void
		{
			if(interfaceName==null||interfaceName=="")
				return;
			for each(var item:String in _interfaceBlock)
			{
				if(item==interfaceName)
				{
					return ;
				}
			}
			_interfaceBlock.push(interfaceName);
		}
		private var _importBlock:Array = [];
		/**
		 * 导入包
		 */		
		public function addImport(importItem:String):void
		{
			if(importItem==null||importItem=="")
				return;

			for each(var item:String in _importBlock)
			{
				if(item==importItem)
				{
					return ;
				}
			}
			_importBlock.push(importItem);
		}
		
		/**
		 * 对变量列表进行排序
		 */		
		private function sortImport():void
		{
			var length:int = _importBlock.length;
			for(var i:int=0; i<length; i++)
			{
				var min:int = i;
				for(var j:int=i+1;j<length;j++)
				{
					if(_importBlock[j]<_importBlock[min])
						min = j;
				}
				if(min!=i)
				{
					var imp:String = _importBlock[min];
					_importBlock[min] = _importBlock[i];
					_importBlock[i] = imp;
				}
			}
		}
		
		private var _variableBlock:Array = [];
		
		/**
		 * 添加变量
		 */		
		public function addVariable(variableItem:ICode):void
		{
			for each(var item:ICode in _variableBlock)
			{
				if(item==variableItem)
				{
					return ;
				}
			}
			_variableBlock.push(variableItem);
		}
		/**
		 * 根据变量名获取变量定义
		 */		
		public function getVariableByName(name:String):CodeVariable
		{
			for each(var item:CodeVariable in _variableBlock)
			{
				if(item.name==name)
				{
					return item;
				}
			}
			return null;
		}
		/**
		 * 是否包含指定名称的变量
		 */		
		public function containsVar(name:String):Boolean
		{
			for each(var item:CodeVariable in _variableBlock)
			{
				if(item.name==name)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 对变量列表进行排序
		 */		
		private function sortVariable():void
		{
			var length:int = _variableBlock.length;
			for(var i:int=0; i<length; i++)
			{
				var min:int = i;
				for(var j:int=i+1;j<length;j++)
				{
					if(_variableBlock[j].name<_variableBlock[min].name)
						min = j;
				}
				if(min!=i)
				{
					var variable:CodeVariable = _variableBlock[min];
					_variableBlock[min] = _variableBlock[i];
					_variableBlock[i] = variable;
				}
			}
		}
		
		private var _functionBlock:Array = [];
		
		/**
		 * 添加函数
		 */		
		public function addFunction(functionItem:ICode):void
		{
			for each(var item:ICode in _functionBlock)
			{
				if(item==functionItem)
				{
					return ;
				}
			}
			_functionBlock.push(functionItem);
		}
		/**
		 * 是否包含指定名称的函数
		 */		
		public function containsFunc(name:String):Boolean
		{
			for each(var item:CodeFunction in _functionBlock)
			{
				if(item.name==name)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 对函数列表进行排序
		 */		
		private function sortFunction():void
		{
			var length:int = _functionBlock.length;
			for(var i:int=0; i<length; i++)
			{
				var min:int = i;
				for(var j:int=i+1;j<length;j++)
				{
					if(_functionBlock[j].name<_functionBlock[min].name)
						min = j;
				}
				if(min!=i)
				{
					var func:CodeFunction = _functionBlock[min];
					_functionBlock[min] = _functionBlock[i];
					_functionBlock[i] = func;
				}
			}
		}
		
		/**
		 * 类注释 
		 */		
		public var notation:CodeNotation;
		
		override public function toCode():String
		{
			//字符串排序
//			sortImport();
//			sortVariable();
//			sortFunction();
			return CodeGenerateTemplete.getInstance().generate(this);
		}
		/**
		 * 移除多余的导入包名
		 */		
		private function removeImportStr(returnStr:String):String
		{
			var sameStrs:Array = [];
			for(var i:int=0;i<_importBlock.length;i++)
			{
				var found:Boolean = false;
				var name:String = getClassName(_importBlock[i]);
				var j:int;
				for(j=i+1;j<_importBlock.length;j++)
				{
					if(name==getClassName(_importBlock[j]))
					{
						found = true;
						break;
					}
				}
				if(found)
				{
					sameStrs.push(_importBlock[i]);
					sameStrs.push(_importBlock[j]);
				}
			}
			
			var removeStrs:Array = _importBlock.concat();
			for(var index:int=0;index<removeStrs.length;index++)
			{
				var str:String = removeStrs[index];
				if(sameStrs.indexOf(str)!=-1)
				{
					removeStrs.splice(index,1);
					index--;
				}
			}
			
			for each(var impStr:String in removeStrs)
			{
				var className:String = getClassName(impStr);
				returnStr = replaceStr(returnStr,":"+impStr,":"+className);
				returnStr = replaceStr(returnStr,"new "+impStr,"new "+className);
				returnStr = replaceStr(returnStr,"extends "+impStr,"extends "+className);
			}
			return returnStr
		}
		/**
		 * 获取类名
		 */		
		private function getClassName(packageName:String):String
		{
			var lastIndex:int = packageName.lastIndexOf(".");
			return packageName.substr(lastIndex+1);
		}
		/**
		 * 替换字符串
		 */		
		private static function replaceStr(targetStr:String,p:String,rep:String):String
		{
			var arr:Array = targetStr.split(p);
			var returnStr:String = "";
			var isFirst:Boolean = true;
			for each(var str:String in arr)
			{
				if(isFirst)
				{
					returnStr = str;
					isFirst = false;
				}
				else
				{
					returnStr += rep+str;
				}
			}
			return returnStr;
		}

		/**
		 * 构造函数的参数列表 
		 */
		public function get argumentBlock():Array
		{
			return _argumentBlock;
		}

		/**
		 * 导入包区块 
		 */
		public function get importBlock():Array
		{
			return _importBlock;
		}

		/**
		 * 接口列表 
		 */
		public function get interfaceBlock():Array
		{
			return _interfaceBlock;
		}

		/**
		 * 变量定义区块 
		 */
		public function get variableBlock():Array
		{
			return _variableBlock;
		}

		/**
		 * 函数定义区块 
		 */
		public function get functionBlock():Array
		{
			return _functionBlock;
		}
		
		
	}
}