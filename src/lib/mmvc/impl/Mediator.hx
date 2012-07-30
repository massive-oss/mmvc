package mmvc.impl;

import mmvc.base.MediatorBase;
import mmvc.api.IMediatorMap;
import mmvc.api.IViewContainer;
import minject.IInjector;

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
