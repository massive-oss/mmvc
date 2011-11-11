package m.app.mvcs.support;

import m.app.event.Event;

import m.app.mvcs.Mediator;

class TestContextViewMediator extends Mediator
{
	public static var MEDIATOR_IS_REGISTERED:String = "MediatorIsRegistered";
	
	public function new()
	{
		super();
	}
	
	public override function onRegister():Void
	{
		eventDispatcher.dispatchEvent(new Event(MEDIATOR_IS_REGISTERED));
	}
}
