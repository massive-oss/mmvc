package m.mvc.impl.support;

import m.mvc.impl.Mediator;
import m.signal.Signal;

class TestContextViewMediator extends Mediator<Dynamic>
{
	public var registered(default, null):Signal0;
	
	public function new()
	{
		super();

		registered = new Signal0();
	}
	
	public override function onRegister():Void
	{
		registered.dispatch();
	}
}
