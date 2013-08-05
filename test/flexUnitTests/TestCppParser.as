package flexUnitTests
{
	import com.ismole.converter.core.CodeClass;
	import com.ismole.converter.core.CodeVariable;
	import com.ismole.converter.parser.cpp.CppParser;
	
	import flexunit.framework.Assert;

	public class TestCppParser
	{		
		private var code:String;
		private var cppParser:CppParser;
		private var cpClass:CodeClass;
		[Before]
		public function setUp():void
		{
			cppParser = new CppParser();
			cpClass = new CodeClass();
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[Test]
		public function testVariable():void
		{
			var variable:CodeVariable = cppParser.parseVariable("cocos::CCLayer *posNode;");
			Assert.assertEquals("变量名应该是posNode",variable.name,"*posNode");
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