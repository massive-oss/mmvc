package mmvc.base.support;

import mmvc.impl.support.ICommandTester;

class TestCommand1 implements mmvc.api.ICommand
 {
	public function new(){}
	
	@inject public var testSuite:ICommandTester;
	
	public function execute():Void
	{
		testSuite.markCommandExecuted();
	}
}
