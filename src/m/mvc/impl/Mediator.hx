/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.mvc.impl;

import m.mvc.base.MediatorBase;
import m.mvc.api.IMediatorMap;
import m.mvc.api.IViewContainer;

/**
 * Abstract MVCS <code>IMediator</code> implementation
 */
class Mediator<T> extends MediatorBase<T>
{
	@inject
	public var contextView:IViewContainer;
	
	@inject
	public var mediatorMap:IMediatorMap;
	
	public function new()
	{
		super();
	}
}
