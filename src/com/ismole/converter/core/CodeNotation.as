package com.ismole.converter.core
{

	public class CodeNotation extends CodeBase
	{
		private var type:int;
		public function CodeNotation(notation:String = "",type:int = 0)
		{
			super();
			this.notation = notation;
			this.type = type;
		}
		
		public var notation:String = "";
		
		override public function toCode():String
		{
			var returnStr:String = "";
			var lines:Array = notation.split("\n");
			var line:String;
			switch (type)
			{
				case 0:
					var firstIndent:String = getIndent();
					var secondIndent:String = firstIndent+" ";
					returnStr = firstIndent+"/**\n";
					while(lines.length>0)
					{
						line = lines.shift();
						returnStr += secondIndent + "* "+line+"\n";
					}
					returnStr += secondIndent +"*/";
					break;
				case 1:
					var intent:String = getIndent();
					returnStr += "\n";
					while(lines.length>0)
					{
						line = lines.shift();
						returnStr += intent +"//"+line+"\n";
					}
					break;
					
			}
			return returnStr;
			
			
		}
	}
}