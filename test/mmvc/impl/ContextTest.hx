/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

package mmvc.impl;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mmvc.api.IViewContainer;
import mmvc.impl.support.TestContext;
import mmvc.impl.support.ICommandTester;
import mmvc.base.support.TestContextView;

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

		var signal = new mmvc.base.support.TestSignal();
		context.commandMap.mapSignal(signal, mmvc.base.support.TestCommand);
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
