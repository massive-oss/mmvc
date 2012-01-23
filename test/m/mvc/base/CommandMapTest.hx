package m.mvc.base;

import massive.munit.Assert;
import m.mvc.base.CommandMap;
import m.mvc.base.support.TestCommand;
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
	var signal:TestSignal;

	@Before
	public function before():Void
	{
		commandExecuted = false;
		injector = new Injector();
		reflector = new Reflector();
		commandMap = new CommandMap(injector);
		injector.mapValue(ICommandTester, this);
		signal = new TestSignal();
	}
	
	@After
	public function after():Void
	{
		injector.unmap(ICommandTester);
		resetCommandExecuted();
	}
	
	@Test
	public function unmapped_signal_does_nothing():Void
	{
		injector.mapClass(TestSignal, TestSignal);
		
		signal.dispatch();
		Assert.isFalse(commandExecuted);
	}
	
	@Test
	public function command_map_has_mapped_signal_instance():Void
	{
		commandMap.mapSignal(signal, TestCommand);
		var hasCommand = commandMap.hasSignalCommand(signal, TestCommand);
		Assert.isTrue(hasCommand);
	}
	
	@Test
	public function dispatched_signal_executes_mapped_command():Void
	{
		commandMap.mapSignal(signal, TestCommand);
		signal.dispatch();
		Assert.isTrue(commandExecuted);
	}
	
	@Test
	public function repeated_dispatch_repeats_command():Void
	{
		commandMap.mapSignal(signal, TestCommand);
		
		signal.dispatch();
		Assert.isTrue(commandExecuted);

		resetCommandExecuted();
		signal.dispatch();
		Assert.isTrue(commandExecuted);
	}
	
	@Test
	public function one_shot_command_does_not_repeat():Void
	{
		commandMap.mapSignal(signal, TestCommand, true);

		signal.dispatch();
		Assert.isTrue(commandExecuted);

		resetCommandExecuted();
		signal.dispatch();
		Assert.isFalse(commandExecuted);
	}
	
	@Test
	public function normalCommandRemoved():Void
	{
		commandMap.mapSignal(signal, TestCommand);

		signal.dispatch();
		Assert.isTrue(commandExecuted);

		resetCommandExecuted();
		commandMap.unmapSignal(signal, TestCommand);
		signal.dispatch();
		Assert.isFalse(commandExecuted);
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
