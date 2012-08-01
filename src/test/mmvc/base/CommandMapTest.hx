package mmvc.base;

import massive.munit.Assert;
import mmvc.api.ICommandMap;
import mmvc.base.CommandMap;
import mmvc.impl.Command;
import mmvc.base.support.TestCommand;
import mmvc.base.support.TestCommand1;
import mmvc.base.support.TestCommand2;
import mmvc.base.support.TestSignal;
import mmvc.base.support.TestSignal2;
import mmvc.impl.support.ICommandTester;
import minject.Injector;
import minject.Injector;

class CommandMapTest implements ICommandTester
{
	var commandExecuted:Bool;
	var secondCommandExecuted:Bool;
	var commandMap:ICommandMap;
	var injector:Injector;
	var signal:TestSignal;
	var param1:Int;
	var param2:String;

	public function new(){}

	@Before
	public function before():Void
	{
		param1 = -1;
		param2 = null;
		secondCommandExecuted = commandExecuted = false;
		injector = new Injector();
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
	public function unmapped_signal_does_not_repeat():Void
	{
		commandMap.mapSignal(signal, TestCommand);

		signal.dispatch();
		Assert.isTrue(commandExecuted);

		resetCommandExecuted();
		commandMap.unmapSignal(signal, TestCommand);
		signal.dispatch();
		Assert.isFalse(commandExecuted);
	}
	
	@Test
	public function map_signal_class_configures_injector()
	{
		commandMap.mapSignalClass(TestSignal, TestCommand);
		var instance = injector.getInstance(TestSignal);
		Assert.isType(instance, TestSignal);
	}

	@Test
	public function unmap_signal_class_unconfigures_injector()
	{
		commandMap.mapSignalClass(TestSignal, TestCommand);
		commandMap.unmapSignalClass(TestSignal, TestCommand);
		var passed = false;

		try
		{
			var instance = injector.getInstance(TestSignal);
		}
		catch (e:Dynamic)
		{
			passed = true;
		}
		
		Assert.isTrue(passed);
	}

	@Test
	public function detain_release_does_nothing()
	{
		var command = new Command();
		commandMap.detain(command);
		commandMap.release(command);
		// check releasing unretained command fails silently
		commandMap.release(command);
		Assert.isType(command, Command);
	}

	@Test
	public function map_signal_to_two_commands_executes_both()
	{
		commandMap.mapSignal(signal, TestCommand);
		commandMap.mapSignal(signal, TestCommand1);
		signal.dispatch();

	}

	@Test
	public function dispatch_mapped_signal_with_params_injects_into_command()
	{
		var signal2 = new TestSignal2();
		commandMap.mapSignal(signal2, TestCommand2);
		signal2.dispatch(10, "foobar");
		Assert.areEqual(10, param1);
		Assert.areEqual("foobar", param2);
	}

	@Test
	public function unmap_non_existant_mapping_fails_silently()
	{
		commandMap.unmapSignal(signal, TestCommand);
		commandMap.mapSignal(signal, TestCommand);
		commandMap.unmapSignal(signal, TestCommand);
		commandMap.unmapSignal(signal, TestCommand);
		Assert.isTrue(true);
	}
	
	public function markCommandExecuted():Void
	{
		if (commandExecuted) secondCommandExecuted = true;
		commandExecuted = true;
	}

	public function markCommand2Executed(param1:Int, param2:String)
	{
		this.param1 = param1;
		this.param2 = param2;
	}

	public function resetCommandExecuted():Void
	{
		commandExecuted = false;
	}
}
