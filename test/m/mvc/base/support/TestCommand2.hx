package m.mvc.base.support;

import m.mvc.impl.support.ICommandTester;

class TestCommand2 implements m.mvc.api.ICommand
 {
	public function new(){}
	
	@inject public var testSuite:ICommandTester;
	
	@inject public var param1:Int;
	@inject public var param2:String;

	public function execute():Void
	{
		testSuite.markCommand2Executed(param1, param2);
	}
}
