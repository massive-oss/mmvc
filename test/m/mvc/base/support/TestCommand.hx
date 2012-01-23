/*
* Copyright (c) 2010 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package m.mvc.base.support;

import m.mvc.impl.support.ICommandTester;

class TestCommand implements m.mvc.api.ICommand
 {
	public function new(){}
	
	@inject
	public var testSuite:ICommandTester;
	
	public function execute():Void
	{
		testSuite.markCommandExecuted();
	}
}
