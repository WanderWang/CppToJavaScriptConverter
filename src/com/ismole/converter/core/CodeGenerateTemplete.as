package com.ismole.converter.core
{
	public class CodeGenerateTemplete
	{
		public function CodeGenerateTemplete()
		{
		}
		
		public function generate(code:ICode):void
		{
			if (code is CodeArguments)
			{
				generateCodeArguments(code  as CodeArguments);
			}
		}
		
		protected function generateCodeArguments(code:CodeArguments):void
		{
			
		}		
		
	}
}