package m.mvc.impl;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import m.mvc.api.IViewContainer;
import m.mvc.impl.support.TestContext;
import m.mvc.impl.support.ICommandTester;
import m.mvc.base.support.TestContextView;

class ContextTest implements ICommandTester
{
	var context:TestContext;
	var contextView:TestContextView;
	var commandExecuted:Bool;

	public function new(){}

	@Before
	public function before():Void
	{
		commandExecuted = true;
		contextView = new TestContextView();
	}
	
	@After
	public function after():Void
	{
		contextView = null;
	}
	
	@Test
	public function context_has_view_map():Void
	{
		var viewMap = context.viewMap;
		Assert.areEqual(viewMap, context.viewMap);
	}

	@Test
	public function autoStartupWithViewComponent():Void
	{
		context = new TestContext(contextView, true);
		Assert.isTrue(context.startupComplete);
	}
	
	@Test
	public function autoStartupWithLateViewComponent():Void
	{
		context = new TestContext(null, true);
		Assert.isFalse(context.startupComplete);
		context.contextView = contextView;
		Assert.isTrue(context.startupComplete);
	}
	
	@Test
	public function manualStartupWithViewComponent():Void
	{
		context = new TestContext(contextView, false);
		Assert.isFalse(context.startupComplete);
		context.startup();
		Assert.isTrue(context.startupComplete);
	}
	
	@Test
	public function manualStartupWithLateViewComponent():Void
	{
		context = new TestContext(null, false);
		Assert.isFalse(context.startupComplete);
		context.contextView = contextView;
		context.startup();
		Assert.isTrue(context.startupComplete);
	}

	@Test
	public function contextInitializationComplete():Void
	{
		context = new TestContext(contextView);
		Assert.isTrue(context.isInitialized);
	}

	@Test
	public function command_map_works():Void
	{
		context = new TestContext(contextView);
		context.injector.mapValue(ICommandTester, this);

		var signal = new m.mvc.base.support.TestSignal();
		context.commandMap.mapSignal(signal, m.mvc.base.support.TestCommand);
		signal.dispatch();

		Assert.isTrue(commandExecuted);
	}

	public function markCommandExecuted():Void
	{
		commandExecuted = true;
	}

	public function markCommand2Executed(param1:Int, param2:String){}

	public function resetCommandExecuted():Void
	{
		commandExecuted = false;
	}
}
