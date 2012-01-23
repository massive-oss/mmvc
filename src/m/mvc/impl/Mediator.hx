package m.mvc.impl;

import m.mvc.base.MediatorBase;
import m.mvc.api.IMediatorMap;
import m.mvc.api.IViewContainer;
import m.inject.IInjector;

/**
Abstract MVCS <code>IMediator</code> implementation
*/
class Mediator<T> extends MediatorBase<T>
{
	@inject public var injector:IInjector;
	
	@inject public var contextView:IViewContainer;
	
	@inject public var mediatorMap:IMediatorMap;
	
	public function new()
	{
		super();
	}
}
