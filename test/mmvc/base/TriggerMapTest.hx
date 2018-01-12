/*
Copyright (c) 2015 Massive Interactive

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

package mmvc.base;

import massive.munit.Assert;

import mmvc.base.support.MockClass;
import mmvc.base.support.MockEnum;
import mmvc.base.support.MockResult;
import mmvc.base.support.TriggerCommand_EnumValue;
import mmvc.base.support.TriggerCommand_Instance;
import mmvc.base.support.TriggerCommand_Int;
import mmvc.base.support.TriggerCommand_MockClass;
import mmvc.base.support.TriggerCommand_String;
import mmvc.impl.Context;

class TriggerMapTest
{
	public function new(){}

	@Before
	public function before():Void
	{
	}
	
	@After
	public function after():Void
	{
	}

	@Test
	public function dispatched_triggers_command():Void
	{
		MockResult.result = null;
		MockResult.count = 0;
		var valueClass = new MockClass();
		var valueString = "asdwe8fw4f";
		var valueEnumValue = MockEnum.A;

		var context = new Context(new mmvc.base.support.TestContextView());
		context.triggerMap.map(MockClass, TriggerCommand_MockClass);
		context.triggerMap.unmap(MockClass, TriggerCommand_MockClass);
		context.triggerMap.map(MockClass, TriggerCommand_MockClass);
		context.triggerMap.map(MockClass, TriggerCommand_MockClass);

		context.triggerMap.map(valueString, TriggerCommand_String);
		context.triggerMap.unmap(valueString, TriggerCommand_String);
		context.triggerMap.map(valueString, TriggerCommand_String);
		context.triggerMap.map(valueString, TriggerCommand_String);

		context.triggerMap.map(valueEnumValue, TriggerCommand_EnumValue);
		context.triggerMap.unmap(valueEnumValue, TriggerCommand_EnumValue);
		context.triggerMap.map(valueEnumValue, TriggerCommand_EnumValue);
		context.triggerMap.map(valueEnumValue, TriggerCommand_EnumValue);

		context.triggerMap.dispatch(valueClass);
		Assert.areEqual(valueClass, MockResult.result);
		Assert.areEqual(2, MockResult.count);

		context.triggerMap.dispatch(valueString);
		Assert.areEqual(valueString, MockResult.result);
		Assert.areEqual(4, MockResult.count);

		context.triggerMap.dispatch(valueEnumValue);
		Assert.areEqual(valueEnumValue, MockResult.result);
		Assert.areEqual(6, MockResult.count);
	}

	@Test
	public function dispatched_class_triggers_command():Void
	{
		MockResult.result = null;
		var mockClass = new MockClass();
		
		var context = new Context(new mmvc.base.support.TestContextView());
		var triggerMap:TriggerMap = cast context.triggerMap;
		triggerMap.mapClass(MockClass, TriggerCommand_MockClass);
		triggerMap.dispatchClass(mockClass);
		
		Assert.areEqual(mockClass, MockResult.result);
	}

	@Test
	public function dispatched_string_triggers_command():Void
	{
		MockResult.result = null;
		var value = "hello world";
		
		var context = new Context(new mmvc.base.support.TestContextView());
		var triggerMap:TriggerMap = cast context.triggerMap;
		triggerMap.mapString(value, TriggerCommand_String);
		triggerMap.dispatchString(value);
		
		Assert.areEqual(value, MockResult.result);
	}

	@Test
	public function dispatched_enumValue_triggers_command():Void
	{
		MockResult.result = null;

		var context = new Context(new mmvc.base.support.TestContextView());
		var triggerMap:TriggerMap = cast context.triggerMap;
		triggerMap.mapEnumValue(MockEnum.A, TriggerCommand_EnumValue);
		triggerMap.dispatchEnumValue(MockEnum.A);

		Assert.areEqual(MockEnum.A, MockResult.result);
	}

	@Test
	public function dispatched_int_triggers_command():Void
	{
		MockResult.result = null;
		var value = 1;

		var context = new Context(new mmvc.base.support.TestContextView());
		var triggerMap:TriggerMap = cast context.triggerMap;
		triggerMap.mapInt(value, TriggerCommand_Int);
		triggerMap.dispatchInt(value);

		Assert.areEqual(value, MockResult.result);
	}

	@Test
	public function dispatched_instance_triggers_command():Void
	{
		MockResult.result = null;
		
		var value = new MockClass();
		
		var context = new Context(new mmvc.base.support.TestContextView());
		var triggerMap:TriggerMap = cast context.triggerMap;
		triggerMap.mapInstance(value, TriggerCommand_Instance);
		triggerMap.dispatchInstance(value);
		
		Assert.areEqual(value, MockResult.result);
	}
	
	@Test
	public function dispatched_invalid_trigger_type_throws_exception():Void
	{
		var context = new Context(new mmvc.base.support.TestContextView());
		var triggerMap:TriggerMap = cast context.triggerMap;
		var myDynamic:Dynamic = 1;
		var isError:Bool;
		
		isError = false;
		try
		{
			triggerMap.dispatch(MockClass);
		}
		catch(error:Dynamic)
		{
			isError = true;
		}
		Assert.isTrue(isError);
		
		isError = false;
		try
		{
			triggerMap.dispatch(MockEnum);
		}
		catch(error:Dynamic)
		{
			isError = true;
		}
		Assert.isTrue(isError);
		
		isError = false;
		try
		{
			triggerMap.dispatchInstance("a");
		}
		catch(error:Dynamic)
		{
			isError = true;
		}
		Assert.isTrue(isError);
		
		isError = false;
		try
		{
			triggerMap.dispatchInstance(myDynamic);
		}
		catch(error:Dynamic)
		{
			isError = true;
		}
		Assert.isTrue(isError);
		
		isError = false;
		try
		{
			triggerMap.dispatchInstance(MockClass);
		}
		catch(error:Dynamic)
		{
			isError = true;
		}
		Assert.isTrue(isError);
		
		isError = false;
		try
		{
			triggerMap.dispatchInstance(MockEnum);
		}
		catch(error:Dynamic)
		{
			isError = true;
		}
		Assert.isTrue(isError);
	}
}
