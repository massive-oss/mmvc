
package mmvc.impl.support;

class TestCommand
 {
	public function new(){}
	
	@inject
	public var testSuite:ICommandTester;
	
	public function execute():Void
	{
		testSuite.markCommandExecuted();
	}

}
