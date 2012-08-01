package mmvc.impl;

import mmvc.base.MediatorBase;
import mmvc.api.IMediatorMap;
import mmvc.api.IViewContainer;
import minject.Injector;

/**
Abstract MVCS <code>IMediator</code> implementation
*/
class Mediator<T> extends MediatorBase<T>
{
	@inject public var injector:Injector;
	
	@inject public var contextView:IViewContainer;
	
	@inject public var mediatorMap:IMediatorMap;
	
	public function new()
	{
		super();
	}
}
