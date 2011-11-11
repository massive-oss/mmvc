package m.app.injector.support.injectees;

class OrderedPostConstructInjectee
{
	public var loadedAsOrdered:Bool;
	
	var one:Bool;
	var two:Bool;
	var three:Bool;
	var four:Bool;
	
	public function new()
	{
		loadedAsOrdered = false;
		one = two = three = four = false;
	}
	
	@post(2)
	public function methodTwo():Void
	{
		two = true;
		loadedAsOrdered = loadedAsOrdered && one && two && !three && !four;
	}
	
	@post(4)
	public function methodFour():Void
	{
		four = true;
		loadedAsOrdered = loadedAsOrdered && one && two && three && four;
	}
	
	@post(3)
	public function methodThree():Void
	{
		three = true;
		loadedAsOrdered = loadedAsOrdered && one && two && three && !four;
	}
	
	@post(1)
	public function methodOne():Void
	{
		one = true;
		loadedAsOrdered = one && !two && !three && !four;
	}
}
