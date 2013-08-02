package com.ismole.converter.core
{
	import com.ismole.converter.generator.ActionScriptGenerator;
	import com.ismole.converter.generator.JavaScriptGenerator;

	public class CodeGenerateTemplete
	{
		public function CodeGenerateTemplete()
		{
		}
		
		private static var _instance:CodeGenerateTemplete;
		
		public static function getInstance():CodeGenerateTemplete
		{
			if (_instance == null)
			{
				_instance = new ActionScriptGenerator();
			}
			return _instance
		}
		
		public function generate(code:ICode):String
		{
			if (code is CodeArguments)
			{
				return generateCodeArguments(code  as CodeArguments);
			}
			else if (code is CodeVariable)
			{
				return generateCodeVariable(code as CodeVariable);
			}
			else if (code is CodeFunction)
			{
				return generateCodeFunction(code as CodeFunction);
			}
			else if (code is CodeClass)
			{
				return generateCodeClass(code as CodeClass);
			}
			return null;
		}
		
		protected function generateCodeFunction(code:CodeFunction):String
		{
			throw new Error("override");
			return null;
		}
		
		protected function generateCodeVariable(code:CodeVariable):String
		{
			throw new Error("override");
			return null;
		}
		
		protected function generateCodeArguments(code:CodeArguments):String
		{
			throw new Error("override");
			return null;
		}		
		
		protected function generateCodeClass(code:CodeClass):String
		{
			throw new Error("override");
			return null;
		}
		
	}
}