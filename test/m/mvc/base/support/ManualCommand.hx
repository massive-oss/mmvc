/*
* Copyright (c) 2010 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package m.mvc.base.support;

import m.mvc.impl.support.ICommandTester;

class ManualCommand
 {
	public function new(){}
	
	@inject
	public var testSuite:ICommandTester;
	
	@inject
	public var payload:Dynamic;
	
	public function execute():Void
	{
		testSuite.markCommandExecuted();
	}
}
