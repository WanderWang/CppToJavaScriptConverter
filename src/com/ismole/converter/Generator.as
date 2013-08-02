package com.ismole.converter
{
	import com.ismole.converter.core.CodeArguments;
	import com.ismole.converter.core.CodeClass;
	import com.ismole.converter.core.CodeFunction;
	import com.ismole.converter.core.CodeNotation;
	import com.ismole.converter.core.Modifiers;

	public class Generator
	{
		public function Generator()
		{
		}
		
		public function generate():void
		{
			var cpClass:CodeClass = new CodeClass();
			cpClass.packageName = "com.ismole.test";
			
			cpClass.addImport("com.ismole.test.ui.MainView");
			var arg:CodeArguments = new CodeArguments("view","com.ismole.test.ui.MainView");
			cpClass.addArgument(arg);
			
			var func:CodeFunction = new CodeFunction();
			func.addArgument(arg);
			func.modifierName = Modifiers.M_PUBLIC;
			func.name = "addView";
			func.notation = new CodeNotation("@private addView");
			cpClass.addFunction(func);
			
			trace (cpClass.toCode());
		}
	}
}