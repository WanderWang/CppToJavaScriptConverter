package flexUnitTests
{
	import com.ismole.converter.core.CodeClass;
	import com.ismole.converter.core.CodeFunction;
	import com.ismole.converter.core.CodeNotation;
	import com.ismole.converter.core.CodeVariable;
	import com.ismole.converter.parser.cpp.CppCodeBlockParser;
	import com.ismole.converter.parser.cpp.CppParser;
	import com.ismole.converter.utils.FileUtils;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import flexunit.framework.Assert;

	public class TestCppParser
	{		
		private var code:String;
		private var cppParser:CppParser;
		[Before]
		public function setUp():void
		{
			cppParser = new CppParser();
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[Test]
		public function testVariable():void
		{
			var variable:CodeVariable = cppParser.parseVariable("cocos::CCLayer *posNode;");
			Assert.assertEquals("变量名应该是posNode",variable.name,"posNode");
		}
		
		[Test]
		public function testFunction():void
		{
			var filePath:String = "file:///Users/apple/Desktop/123guo/Classes2/module/hero/HeroUpgradeLayer.h";
			var str:String = FileUtils.readTextFile(filePath);
			var cpClassList:Array = cppParser.parseFile(str);
			var cpClass:CodeClass = cpClassList[0];
			for each (var cpFunction:CodeFunction in cpClass.functionBlock)
			{
				if (cpFunction.name == "")
				{
					Assert.fail("方法名不能为空");
				}
			}
			Assert.assertTrue("全部方法名正确");
		}
		
		[Test]
		public function testCpp():void
		{
			var filePath:String = "file:///Users/apple/Desktop/123guo/Classes2/module/hero/HeroUpgradeLayer.h";
			cppParser.parse(new File(filePath));
		}
		
		[Test]
		public function testFunctionNotation():void
		{
			var func:CodeFunction = new CodeFunction();
			func.name = "helloworld";
			var codeBlock:CodeNotation = new CodeNotation("cpp code block");
			func.codeBlock = codeBlock;
		}
		
		
		/**
		 * 测试提取Cpp中的方法
		 * 
		 */
		[Test]
		public function testParseCppFunctionBody():void
		{
			var filePath:String = "file:///Users/apple/Desktop/123guo/Classes2/module/hero/HeroUpgradeLayer.cpp";
			var str:String = FileUtils.readTextFile(filePath);
			var cppBody:String = cppParser.parseCppFunctionBody(str,"HeroUpgradeLayer","onPressedUpgradeHandler");
			Assert.assertEquals("不计算 '{' 和 '}' ，应该有19行",cppBody.split("\n").length,19);
		}
		
		/**
		 * 测试当.h文件有注释的时候不应该被解析出来
		 */ 
		[Test]
		public function testParseFunctionWithNotation():void
		{
			var str:String = "//  virtual cocos2d::CCPoint __offsetFromIndex(unsigned int index);"
			var cpFunction:CodeFunction = cppParser.parseFunction(str);
			Assert.assertNull("由于有注释，这个方法应该返回null",cpFunction);
			
//			protected:
//			//  virtual cocos2d::CCPoint __offsetFromIndex(unsigned int index);
//			上面这个方法有个//，应该解析不出来，目前给解析成了
//				virtual : function(__offsetFromIndex , int , ){
		}
		
		[Test]
		public function testCodeBlock():void
		{
			var filePath:String = "file:///Users/apple/Desktop/123guo/Classes2/module/common/BaseSelectHeroLayer.cpp";
			var str:String = FileUtils.readTextFile(filePath);
			str = str.split("void BaseSelectHeroLayer::createTableView()\n")[1];//获取该方法的codeBlock
			var parser:CppCodeBlockParser = new CppCodeBlockParser();
			var code:String = parser.parse(str);
			var lineCount:int = code.split("\n").length;
			Assert.assertEquals("createTableView()这个方法应该有24行",lineCount,24);
			
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		
	}
}