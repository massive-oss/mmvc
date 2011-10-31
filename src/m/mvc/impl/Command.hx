/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.mvc.impl;

import m.mvc.api.ICommandMap;
import m.inject.IInjector;
import m.mvc.api.ICommand;
import m.mvc.api.IMediatorMap;
import m.mvc.api.IViewContainer;

/**
 * Abstract MVCS command implementation
 */
class Command implements ICommand
{
	@inject
	public var contextView:IViewContainer;
	
	@inject
	public var commandMap:ICommandMap;
	
	@inject
	public var injector:IInjector;
	
	@inject
	public var mediatorMap:IMediatorMap;
	
	public function new()
	{
	}
	
	public function execute():Void
	{
	}
}
