/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.app.injector.support.injectees.childinjectors;

class RobotFoot
{
	public var toes:RobotToes;
	
	@inject
	public function new(?toes:RobotToes=null)
	{
		this.toes = toes;
	}
}
