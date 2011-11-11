/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package m.app.mvcs.support;

interface ICommandTester
{
	function resetCommandExecuted():Void;
	function markCommandExecuted():Void;
}
