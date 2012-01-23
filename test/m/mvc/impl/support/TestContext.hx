package m.mvc.impl.support;

import m.inject.IInjector;
import m.mvc.api.IViewContainer;
import m.mvc.impl.Context;

class TestContext extends Context
{
	public var isInitialized(getIsInitialized, null):Bool;
	public var startupComplete:Bool ;
	
	public function new(?contextView:IViewContainer=null, ?autoStartup:Bool=true)
	{
		startupComplete = false;
		super(contextView, autoStartup);
	}
	
	public override function startup():Void
	{
		startupComplete = true;
		super.startup();
	}
	
	public function getInjector():IInjector
	{
		return this.injector;
	}
	
	public function getIsInitialized():Bool
	{
		var initialized:Bool = true;
		initialized = (commandMap != null && initialized);
		initialized = (mediatorMap != null && initialized);
		return initialized;
	}
}
