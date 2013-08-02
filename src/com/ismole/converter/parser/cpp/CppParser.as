package com.ismole.converter.parser.cpp
{
	import com.ismole.converter.StringUtil;
	import com.ismole.converter.core.CodeArguments;
	import com.ismole.converter.core.CodeClass;
	import com.ismole.converter.core.CodeFunction;
	import com.ismole.converter.core.CodeType;
	import com.ismole.converter.core.CodeVariable;
	import com.ismole.converter.core.Modifiers;
	import com.ismole.converter.parser.common.StringLineReader;
	import com.ismole.converter.parser.common.StringWordReader;

	public class CppParser
	{
		/**
		 * 解析规则：
		 * 多重继承的第一个类为基类，其他类会被忽略
		 * public: 后面必须有回车
		 * 
		 * 变量声明： HeroModel* m_var ，类型和变量名之间必须是“ ”（可以是多个空格，但是不能是\t
		 * 
		 */
		public function CppParser()
		{
		}
		
		private static const MODE_CLASS:String = "class";
		private static const MODE_STANDARD:String = "standard";
		
		
		public function parse(str:String):void
		{
			parseFile(str);
		}
		
		private function parseFile(str:String):void
		{
			var index:int = 0;
			var keywords:String = "";
			var bracesCount:int = 0;
			var mode:String = MODE_STANDARD;
			while (index <= str.length)
			{
				var char:String = str.charAt(index);
				
				if (mode == MODE_CLASS)
				{
					if (char == "{")
					{
						bracesCount++;
						keywords += char;
					}
					else if (char == "}")
					{
						bracesCount--;
						keywords += char;
					}
					else if (char == ";")
					{
						if (bracesCount == 0)
						{
							var cpClass:CodeClass = parseClass(keywords);
							if (cpClass != null)
							{
								trace (cpClass.toCode());
							}
							keywords = "";
							mode = MODE_STANDARD;
							
							//							var cp:CpClass = new CpClass();
							//							cp.className = keywords;
							//							cp.superClass
						}
						else
						{
							keywords += char;
						}
						
					}
					else
					{
						keywords += char;
					}
				}
				else if (mode == MODE_STANDARD)
				{
					if (char == "\n")
					{
						keywords = "";
					}
					else if (char == "\t")
					{
						keywords += "----";//temp
					}
					else if (char == " ")
					{
						if (keywords == "class")
						{
							mode = MODE_CLASS;
							keywords = "";
						}
						else
						{
							keywords += "-";//temp
						}
					}
					else
					{
						keywords += char;
					}
				}
				index++;
			}
		}
		
		private function parseClass(str:String):CodeClass
		{
			if (str.indexOf("{") == -1)
			{
				trace ("Ignore:" + str);
				return null;
			}
			var index:int = 0;
			var keywords:String = "";
			var bracesCount:int = 0;
			var mode:String = MODE_STANDARD;
			
			var classDefenitionStr:String = str.split("{")[0];
			var className:String = classDefenitionStr.split(":")[0];
			var superClassStr:String = classDefenitionStr.substring(className.length + 1);
			superClassStr = superClassStr.split(",")[0];
			var superClassName:String = StringUtil.trim(superClassStr);
			var cpClass:CodeClass = new CodeClass();
			cpClass.className = className;
			cpClass.superClass = new CodeType(superClassName);
			
			var classBodyStr:String = str.split("{")[1].split("}")[0];
			parseClassBody(cpClass,classBodyStr);
			trace ("====")
			return cpClass;
		}
		
		
		private function parseClassBody(cpClass:CodeClass,str:String):void
		{
			var reader:StringLineReader = new StringLineReader(str);
			var modifierFlag:String = "none";
			var codeBlock:String = "";
			while (reader.hasNext())
			{
				var line:String = reader.readLine();
				if (line.indexOf("public:") >= 0)
				{
					modifierFlag = Modifiers.M_PUBLIC;
				}
				else if (line.indexOf("protected:") >= 0)
				{
					modifierFlag = Modifiers.M_PROTECTED;
				}
				else if (line.indexOf("private:") >= 0)
				{
					modifierFlag = Modifiers.M_PRIVATE;
				}
				else //上面三个是标志，下面这个else里面是正文
				{
					codeBlock += line;
					if (codeBlock.indexOf(";") > -1)
					{
						codeBlock = StringUtil.trim(codeBlock);
						if (codeBlock.indexOf("(") >= 0)
						{
							if (codeBlock.indexOf(" ") >= codeBlock.indexOf("(") || codeBlock.indexOf(" ") == -1)
							{
								trace ("warning:构造函数、析构函数或者宏：" + codeBlock);
							}
							else
							{
								var reg:RegExp = new RegExp(/\ \*/gi); //todo 正则表达式bug  	var word:String = "Hello * World  * Hello;";
								for ( var i:int = 0 ; i <= 20 ; i++)
								{
									codeBlock = codeBlock.replace(reg,"*");
								}
								var wordReader:StringWordReader = new StringWordReader(codeBlock);
								var returnType:String = wordReader.readWord();
								if (returnType == "...")
								{
									trace ("可变参数，暂时不支持这种写法：" + codeBlock);
									break;
								}
								if (returnType == "virtual")
								{
									returnType = wordReader.readWord();
								}
								if (returnType == "static")
								{
									returnType = wordReader.readWord();
									cpVariable.isStatic = true;
								}
								var functionName:String = wordReader.readWord();
//								trace (returnType + " " + functionName + ":-->" + codeBlock);
								
								var cpFunction:CodeFunction = new CodeFunction();
								cpFunction.name = functionName;
								cpFunction.returnType = returnType;
								cpFunction.modifierName = modifierFlag;
								while (wordReader.hasNext())
								{
									var arg:CodeArguments = new CodeArguments();
									var argType:String = wordReader.readWord();
									if (argType == "")
									{
										break;
									}
									if (argType == "const")
									{
										argType = wordReader.readWord();
									}
									var argName:String = wordReader.readWord();
									arg.name = argName;
									arg.type = new CodeType(argType);
									cpFunction.addArgument(arg);
								}
								
								cpClass.addFunction(cpFunction);
							
							
							}
						}
						else
						{
							var cpVariable:CodeVariable = new CodeVariable();
							cpVariable.modifierName = modifierFlag;
						
							var wordReader:StringWordReader = new StringWordReader(codeBlock);
							var type:String = wordReader.readWord();
							if (type == "static")
							{
								type = wordReader.readWord();
								cpVariable.isStatic = true;
							}
							var varName:String =  wordReader.readWord();
							cpVariable.type = new CodeType(type);
							cpVariable.name = varName;
							cpClass.addVariable(cpVariable);
//							trace (cpVariable.toCode());
//							trace (codeBlock);
							
						}
						codeBlock = "";
					}
				}
			}
			
		}
	}
}