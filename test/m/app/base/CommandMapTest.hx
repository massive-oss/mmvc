/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.app.base;

import massive.munit.Assert;
import m.app.event.EventDispatcher;
import m.app.event.IEventDispatcher;
import m.app.base.CommandMap;
import m.app.base.support.ManualCommand;
import m.app.core.ICommandMap;
import m.app.core.IInjector;
import m.app.core.IReflector;
import m.app.injector.Injector;
import m.app.injector.Reflector;
import m.app.mvcs.support.CustomEvent;
import m.app.mvcs.support.EventCommand;
import m.app.mvcs.support.ICommandTester;

class CommandMapTest implements ICommandTester
{
	public function new(){}
	
	var eventDispatcher:IEventDispatcher;
	var commandExecuted:Bool;
	var commandMap:ICommandMap;
	var injector:IInjector;
	var reflector:IReflector;
	
	@Before
	public function setup():Void
	{
		eventDispatcher = new EventDispatcher();
		commandExecuted = false;
		injector = new Injector();
		reflector = new Reflector();
		commandMap = new CommandMap(eventDispatcher, injector, reflector);
		injector.mapValue(ICommandTester, this);
	}
	
	@After
	public function tearDown():Void
	{
		injector.unmap(ICommandTester);
		resetCommandExecuted();
	}
	
	@Test
	public function noCommand():Void
	{
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(commandExecuted);//'Command should not have reponded to event'
	}
	
	@Test
	public function hasCommand():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		var hasCommand:Bool = commandMap.hasEventCommand(CustomEvent.STARTED, EventCommand);
		Assert.isTrue(hasCommand);//'Command Map should have Command'
	}
	
	@Test
	public function normalCommand():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);//'Command should have reponded to event'
	}
	
	@Test
	public function normalCommandRepeated():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);//'Command should have reponded to event'

		resetCommandExecuted();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);//'Command should have reponded to event again'
	}
	
	@Test
	public function oneshotCommand():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand, null, true);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);//'Command should have reponded to event'

		resetCommandExecuted();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(commandExecuted);//'Command should NOT have reponded to event'
	}
	
	@Test
	public function normalCommandRemoved():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);//'Command should have reponded to event'

		resetCommandExecuted();
		commandMap.unmapEvent(CustomEvent.STARTED, EventCommand);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(commandExecuted);//'Command should NOT have reponded to event'
	}
	
	@Test
	public function unmapEvents():Void
	{
		commandMap.mapEvent(CustomEvent.EVENT0, EventCommand);
		commandMap.mapEvent(CustomEvent.EVENT1, EventCommand);
		commandMap.mapEvent(CustomEvent.EVENT2, EventCommand);
		commandMap.mapEvent(CustomEvent.EVENT3, EventCommand);
		commandMap.unmapEvents();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT0));
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT1));
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT2));
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT3));
		Assert.isFalse(commandExecuted);//'Command should NOT have reponded to event'
	}
	
	@Test
	public function manuallyExecute():Void
	{
		commandMap.execute(ManualCommand, {});
		Assert.isTrue(commandExecuted);//'Command should have executed with custom payload'
	}
	
	@Test
	public function mappingNonCommandClassShouldFail():Void
	{
		var passed = false;

		try
		{
			commandMap.mapEvent(CustomEvent.STARTED, Dynamic);
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, ContextError);
		}

		Assert.isTrue(passed);
	}
	
	@Test
	public function mappingSameThingTwiceShouldFail():Void
	{
		var passed = false;

		try
		{
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, ContextError);
		}

		Assert.isTrue(passed);
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
