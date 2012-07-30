
package mmvc.base.support;

class TestView implements ITestView
{
	@inject("injectionName")
	public var injectionPoint:String;
	
	public function new()
	{
	}
}
