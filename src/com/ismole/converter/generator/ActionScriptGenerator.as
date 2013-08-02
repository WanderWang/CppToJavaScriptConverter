package com.ismole.converter.generator
{
	import com.ismole.converter.core.CodeArguments;
	import com.ismole.converter.core.CodeClass;
	import com.ismole.converter.core.CodeFunction;
	import com.ismole.converter.core.CodeGenerateTemplete;
	import com.ismole.converter.core.CodeVariable;
	import com.ismole.converter.core.ICode;
	import com.ismole.converter.core.KeyWords;
	import com.ismole.converter.core.Modifiers;
	
	public class ActionScriptGenerator extends CodeGenerateTemplete
	{
		public function ActionScriptGenerator()
		{
			super();
		}
		
		
		override protected function generateCodeArguments(code:CodeArguments):String
		{
			return code.name + ":" + code.type.toCode();
		}		
		
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
			var keyWord:String = code.isConst?KeyWords.KW_CONST:KeyWords.KW_VAR;
			return noteStr+metadataStr+code.getIndent()+code.modifierName+" "+staticStr+keyWord
				+" "+code.name+":"+code.type.toCode()+valueStr+";";
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
			
			var returnStr:String = noteStr+indentStr+overrideStr+code.modifierName+" "
				+staticStr+KeyWords.KW_FUNCTION+" "+code.name+"(";
			
			var isFirst:Boolean = true;
			index = 0;
			while(code.argumentBlock.length>index)
			{
				var arg:ICode = code.argumentBlock[index];
				if(isFirst)
				{
					returnStr += arg.toCode();
					isFirst = false;
				}
				else
				{
					returnStr += ","+arg.toCode();
				}
				index++;
			}
			returnStr += ")";
			if(code.returnType!="")
				returnStr += ":"+code.returnType;
			returnStr += "\n"+indentStr+"{\n";
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
		
		override protected function generateCodeClass(code:CodeClass):String
		{
			var isFirst:Boolean = true;
			var index:int = 0;
			var indentStr:String = code.getIndent();
			
			//打印包名
			var returnStr:String = KeyWords.KW_PACKAGE+" "+code.packageName+"\n{\n";
			
			//打印导入包
			index = 0;
			while(index<code.importBlock.length)
			{
				var importItem:String = code.importBlock[index];
				returnStr += indentStr+KeyWords.KW_IMPORT+" "+importItem+";\n";
				index ++;
			}
			returnStr += "\n";
			
			//打印注释
			if(code.notation!=null)
			{
				code.notation.indent = code.indent;
				returnStr += code.notation.toCode()+"\n";
			}
			returnStr += indentStr+code.modifierName+" "+KeyWords.KW_CLASS+" "+ code.className;
			
			//打印父类
			if(code.superClass!=null&&code.superClass!="")
			{
				returnStr += " "+KeyWords.KW_EXTENDS+" "+code.superClass;
			}
			
			//打印接口列表
			if(code.interfaceBlock.length>0)
			{
				returnStr += " "+KeyWords.KW_IMPLEMENTS+" ";
				
				index = 0;
				while(code.interfaceBlock.length>index)
				{
					isFirst = true;
					var interfaceItem:String = code.interfaceBlock[index];
					if(isFirst)
					{
						returnStr += interfaceItem;
						isFirst = false;
					}
					else
					{
						returnStr += ","+interfaceItem;
					}
					index++;
				}
			}
			returnStr += "\n"+indentStr+"{\n";
			
			//打印变量列表
			if(code.variableBlock.length>1)
				returnStr += 
					code.getIndent(code.indent+1)+"//==========================================================================\n"+
					code.getIndent(code.indent+1)+"//                                定义成员变量\n"+
					code.getIndent(code.indent+1)+"//==========================================================================\n";
			index = 0;
			while(code.variableBlock.length>index)
			{
				var variableItem:ICode = code.variableBlock[index];
				returnStr += variableItem.toCode()+"\n\n";
				index++;
			}
			returnStr += "\n";
			
			//打印构造函数
			returnStr += 
				code.getIndent(code.indent+1)+"//==========================================================================\n"+
				code.getIndent(code.indent+1)+"//                                定义构造函数\n"+
				code.getIndent(code.indent+1)+"//==========================================================================\n";
			returnStr +=code.getIndent(code.indent+1)+Modifiers.M_PUBLIC+" "+KeyWords.KW_FUNCTION+" "+code.className+"(";
			isFirst = true;
			index = 0;
			while(code.argumentBlock.length>index)
			{
				var arg:ICode = code.argumentBlock[index];
				if(isFirst)
				{
					returnStr += arg.toCode();
					isFirst = false;
				}
				else
				{
					returnStr += ","+arg.toCode();
				}
				index++;
			}
			returnStr += ")\n"+code.getIndent(code.indent+1)+"{\n";
			var indent2Str:String = code.getIndent(code.indent+2);
			if(code.superClass!=null&&code.superClass!="")
			{
				returnStr += indent2Str+"super();\n";
			}
			if(code.constructCode!=null)
			{
				var codes:Array = code.constructCode.toCode().split("\n");
				index = 0;
				while(codes.length>index)
				{
					var code1:String = codes[index];
					returnStr += indent2Str+code1+"\n";
					index++;
				}
			}
			returnStr += code.getIndent(code.indent+1)+"}\n\n\n";
			
			
			//打印函数列表
			if(code.functionBlock.length>1)
				returnStr += 
					code.getIndent(code.indent+1)+"//==========================================================================\n"+
					code.getIndent(code.indent+1)+"//                                定义成员方法\n"+
					code.getIndent(code.indent+1)+"//==========================================================================\n";
			index = 0;
			while(code.functionBlock.length>index)
			{
				var functionItem:ICode = code.functionBlock[index];
				returnStr += functionItem.toCode()+"\n\n";
				index++;
			}
			
			returnStr += indentStr+"}\n}";
			
			//不能移除完整包名，因为同目录下若出现同名类，这情况是无法判断的。
			//returnStr = removeImportStr(returnStr);
			
			return returnStr;
		}
		
	}
}