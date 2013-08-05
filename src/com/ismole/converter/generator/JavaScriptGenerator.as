package com.ismole.converter.generator
{
	import com.ismole.converter.core.CodeArguments;
	import com.ismole.converter.core.CodeClass;
	import com.ismole.converter.core.CodeFunction;
	import com.ismole.converter.core.CodeGenerateTemplete;
	import com.ismole.converter.core.CodeType;
	import com.ismole.converter.core.CodeVariable;
	import com.ismole.converter.core.KeyWords;
	import com.ismole.converter.core.Modifiers;
	
	public class JavaScriptGenerator extends CodeGenerateTemplete
	{
		/**
		 * JavaScript生成器目前不支持包和命名空间 
		 * 
		 */
		public function JavaScriptGenerator()
		{
			super();
		}
		
		override protected function generateCodeClass(code:CodeClass):String
		{
			var indentStr:String = code.getIndent();
			
			
			//打印包和命名空间
			
			//打印注释
			if(code.notation!=null)
			{
				code.notation.indent = code.indent;
				returnStr += code.notation.toCode()+"\n";
			}
			
			var returnStr:String = "var {className} = {superclassName}.extend({\n{var}\n{function}\n});";
			returnStr = returnStr.replace("{className}",code.className);
			trace ("==========" + code.superClass.toCode())
			returnStr = returnStr.replace("{superclassName}",code.superClass.toCode());
			
			var varStr:String = "";
			for each (var codeVar:CodeVariable in code.variableBlock)
			{
				varStr += codeVar.toCode() + "\n";
			}
			returnStr = returnStr.replace("{var}",varStr);
			
			var funcStr:String = "";
			var functionList:Array = [];
			for each (var codeFunc:CodeFunction in code.functionBlock)
			{
				functionList.push(codeFunc.toCode());
			}
			funcStr = functionList.join(",\n\n");
			
			returnStr = returnStr.replace("{function}",funcStr);
			
			
			return returnStr;
		}
		
		/**
		 *  生成变量 
		 * @param code
		 * @return 
		 * 
		 */
		override protected function generateCodeVariable(code:CodeVariable):String
		{
			var noteStr:String = "";
			if(code.notation!=null)
			{
				code.notation.indent = code.indent;
				noteStr = code.notation.toCode()+"\n";
			}
			var metadataStr:String = "";
			if(code.metadata!=""&&code.metadata!=null)
			{
				metadataStr = code.getIndent()+"["+code.metadata+"]\n";
			}
			var staticStr:String = code.isStatic?Modifiers.M_STATIC+" ":"";
			var valueStr:String = "";
			if(code.defaultValue!=""&&code.defaultValue!=null)
			{
				valueStr = " = "+code.defaultValue;
			}
			else
			{
				valueStr = " : null"; 
			}
			
			
			var varName:String = code.name;
			varName = varName.replace("m_","_");
			
			return noteStr+metadataStr+code.getIndent()+staticStr+varName + valueStr + ",";
		}
		
		override protected function generateCodeArguments(code:CodeArguments):String
		{
			return "" + code.name + "";
		}		
		
		override protected function generateCodeFunction(code:CodeFunction):String
		{
			var index:int = 0;
			var indentStr:String = code.getIndent();
			var overrideStr:String = code.isOverride?KeyWords.KW_OVERRIDE+" ":"";
			var staticStr:String = code.isStatic?Modifiers.M_STATIC+" ":"";
			var noteStr:String = "";
			if(code.notation!=null)
			{
				code.notation.indent = code.indent;
				noteStr = code.notation.toCode()+"\n";
			}
			if (code.isStatic)
			{
				trace ("warning:尚不支持static")
//				throw new Error("not support");
			}
			var returnStr:String = code.getIndent() + "{functionName} : function({functionArg})";
			returnStr = returnStr.replace("{functionName}",code.name);

			var tempList:Array = [];
			for each (var argCode:CodeArguments in code.argumentBlock)
			{
				tempList.push(argCode.toCode());
			}
			var functionArg:String = tempList.join(" , ");
			returnStr = returnStr.replace("{functionArg}",functionArg);
			
			returnStr += ""+"{\n";
			if(code.codeBlock!=null)
			{
				var lines:Array = code.codeBlock.toCode().split("\n");
				var codeIndent:String = code.getIndent(code.indent+1);
				index = 0;
				while(lines.length>index)
				{
					var line:String = lines[index];
					returnStr += codeIndent+line+"\n";
					index ++;
				}
			}
			
			returnStr += indentStr+"}";
			return returnStr;
		}
		
		
		override protected function generateCodeType(code:CodeType):String
		{
			if (code.name.indexOf("cocos2d::CC") > -1)
			{
				return code.name.replace("cocos2d::CC","cc.");
			}
			else if (code.name.indexOf("cocos2d::extension::CC") > -1)
			{
				return code.name.replace("cocos2d::extension::CC","cc.");
			}
			else
			{
				return code.name;
			}
		}
	}
}