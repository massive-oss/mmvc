package m.mvc.base.support;

import m.mvc.impl.support.ICommandTester;

class TestCommand1 implements m.mvc.api.ICommand
 {
	public function new(){}
	
	@inject public var testSuite:ICommandTester;
	
	public function execute():Void
	{
		testSuite.markCommandExecuted();
	}
}
