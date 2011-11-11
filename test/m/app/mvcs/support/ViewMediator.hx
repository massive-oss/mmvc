/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.app.mvcs.support;

import m.app.mvcs.Mediator;

class ViewMediator extends Mediator
{
	@inject
	public var view:ViewComponent;
	
	public function new()
	{
		super();
	}
	
	public override function onRegister():Void
	{
	
	}
	
	public override function onRemove():Void
	{
	
	}
}
