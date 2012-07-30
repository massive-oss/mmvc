package mmvc.impl.support;

import mmvc.impl.Mediator;
import msignal.Signal;

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
