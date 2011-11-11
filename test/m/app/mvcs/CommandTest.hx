/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package m.app.mvcs;

import m.app.event.Event;
import m.app.event.EventDispatcher;
import m.app.event.IEventDispatcher;

import massive.munit.Assert;
import m.app.injector.Injector;
import m.app.injector.Reflector;
import m.app.base.CommandMap;
import m.app.core.ICommandMap;
import m.app.core.IInjector;
import m.app.core.IReflector;
import m.app.mvcs.support.ICommandTester;
import m.app.mvcs.support.TestCommand;

class CommandTest implements ICommandTester
{
	public static var TEST_EVENT = "testEvent";

	var eventDispatcher:IEventDispatcher;
	var commandExecuted:Bool;
	var commandMap:ICommandMap;
	var injector:IInjector;
	var reflector:IReflector;
	
	public function new(){}
	
	@Before
	public function before():Void
	{
		eventDispatcher = new EventDispatcher();
		injector = new Injector();
		reflector = new Reflector();
		commandMap = new CommandMap(eventDispatcher, injector, reflector);
		injector.mapValue(ICommandTester, this);
		commandExecuted = false;
	}
	
	@After
	public function after():Void
	{
		injector.unmap(ICommandTester);
		resetCommandExecuted();
	}
	
	@Test
	public function commandIsExecuted():Void
	{
		Assert.isFalse(commandExecuted);//"Command should NOT have executed"
		commandMap.mapEvent(TEST_EVENT, TestCommand);
		eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
		Assert.isTrue(commandExecuted);//"Command should have executed"
	}
	
	public function markCommandExecuted():Void
	{
		commandExecuted = true;
	}
	
	public function resetCommandExecuted():Void
	{
		commandExecuted = false;
	}
}
