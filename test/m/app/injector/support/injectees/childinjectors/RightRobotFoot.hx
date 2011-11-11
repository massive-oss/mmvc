/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.app.injector.support.injectees.childinjectors;

class RightRobotFoot extends RobotFoot
{
	@inject
	public function new(?toes:RobotToes=null)
	{
		super(toes);
	}
}
