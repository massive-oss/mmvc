package m.mvc.base;

import massive.munit.Assert;
import m.mvc.base.CommandMap;
import m.mvc.base.support.ManualCommand;
import m.mvc.base.support.TestSignal;
import m.mvc.api.ICommandMap;
import m.inject.IInjector;
import m.inject.IReflector;
import m.inject.Injector;
import m.inject.Reflector;
import m.mvc.impl.support.ICommandTester;

class CommandMapTest implements ICommandTester
{
	public function new(){}
	
	var commandExecuted:Bool;
	var commandMap:ICommandMap;
	var injector:IInjector;
	var reflector:IReflector;
	
	@Before
	public function setup():Void
	{
		commandExecuted = false;
		// injector = new Injector();
		// reflector = new Reflector();
		// commandMap = new CommandMap(injector);
		// injector.mapValue(ICommandTester, this);
	}
	
	@After
	public function tearDown():Void
	{
		// injector.unmap(ICommandTester);
		// resetCommandExecuted();
	}
	
	@Test
	public function noCommand():Void
	{
		// var signal = injector.getInstance(TestSignal);
		// signal.dispatch();
		Assert.isFalse(commandExecuted);
	}
	/*
	@Test
	public function hasCommand():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		var hasCommand:Bool = commandMap.hasEventCommand(CustomEvent.STARTED, EventCommand);
		Assert.isTrue(hasCommand);
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
	*/
	public function markCommandExecuted():Void
	{
		commandExecuted = true;
	}
	
	public function resetCommandExecuted():Void
	{
		commandExecuted = false;
	}
}
