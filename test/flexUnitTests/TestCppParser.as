package flexUnitTests
{
	import com.ismole.converter.core.CodeClass;
	import com.ismole.converter.core.CodeFunction;
	import com.ismole.converter.core.CodeVariable;
	import com.ismole.converter.parser.cpp.CppParser;
	
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
			var file:File = new File(filePath);
			var stream:FileStream = new FileStream();
			stream.open(file,FileMode.READ);
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
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