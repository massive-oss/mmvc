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

package mmvc.base;

import haxe.ds.EnumValueMap;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

import minject.Injector;

import mmvc.api.ICommand;
import mmvc.api.ITriggerMap;
import mmvc.impl.TriggerCommand;

class TriggerMap implements ITriggerMap
{
	var injector:Injector;
	var classToCommand:StringMap<Array<Class<ICommand>>>;
	var stringToCommand:StringMap<Array<Class<ICommand>>>;
	var enumValueToCommand:EnumValueMap<EnumValue, Array<Class<ICommand>>>;
	var instanceToCommand:ObjectMap<Dynamic, Array<Class<ICommand>>>;

	public function new(injector:Injector)
	{
		this.injector = injector;
	}

	public function map(trigger:Dynamic, command:Class<ICommand>)
	{
		if (isClass(trigger))
			return mapClass(trigger, command);
		if (isString(trigger))
			return mapString(trigger, command);
		if (isEnumValue(trigger))
			return mapEnumValue(trigger, command);
		throw "Mapping type " + Std.string(Type.typeof(trigger)) + " is not supported.";
	}
	
	public function unmap(trigger:Dynamic, command:Class<ICommand>)
	{
		if (isClass(trigger))
			return unmapClass(trigger, command);
		if (isString(trigger))
			return unmapString(trigger, command);
		if (isEnumValue(trigger))
			return unmapEnumValue(trigger, command);
		throw "Unmapping type " + Std.string(Type.typeof(trigger)) + " is not supported.";
	}

	public function dispatch(trigger:Dynamic)
	{
		if (isEnumValue(trigger))
			return dispatchEnumValue(trigger);
		if (isString(trigger))
			return dispatchString(trigger);
		if (isClassInstance(trigger))
			return dispatchClass(trigger);
		throw "Unmapping type " + Std.string(Type.typeof(trigger)) + " is not supported.";
	}

	public function mapClass(trigger:Class<Dynamic>, command:Class<ICommand>)
	{
		if (classToCommand == null)
			classToCommand = new StringMap<Array<Class<ICommand>>>();
		var key = Type.getClassName(trigger);
		var list = classToCommand.get(key);
		(list == null) ? classToCommand.set(key, [command]) : list.push(command);
	}

	public function unmapClass(trigger:Class<Dynamic>, command:Class<ICommand>)
	{
		if (classToCommand == null)
			return;
		var key = Type.getClassName(trigger);
		var list = classToCommand.get(key);
		if (list != null)
			list.remove(command);
	}

	public function dispatchClass(trigger:{})
	{
		if (classToCommand == null)
			return;
		var triggerClass = Type.getClass(trigger);
		var key = Type.getClassName(triggerClass);
		var list = classToCommand.get(key);
		if (list != null)
			for(commandClass in list)
				invokeCommand(trigger, triggerClass, commandClass);
	}

	public function mapString(trigger:String, command:Class<ICommand>)
	{
		if (stringToCommand == null)
			stringToCommand = new StringMap<Array<Class<ICommand>>>();
		var list = stringToCommand.get(trigger);
		(list == null) ? stringToCommand.set(trigger, [command]) : list.push(command);
	}

	public function unmapString(trigger:String, command:Class<ICommand>)
	{
		if (stringToCommand == null)
			return;
		var list = stringToCommand.get(trigger);
		if (list != null)
			list.remove(command);
	}

	public function dispatchString(trigger:String)
	{
		if (stringToCommand == null)
			return;
		var list = stringToCommand.get(trigger);
		if (list != null)
			for(commandClass in list)
				invokeCommand(trigger, String, commandClass);
	}

	public function mapEnumValue(trigger:EnumValue, command:Class<ICommand>)
	{
		if (enumValueToCommand == null)
			enumValueToCommand = new EnumValueMap<EnumValue, Array<Class<ICommand>>>();
		var list = enumValueToCommand.get(trigger);
		(list == null) ? enumValueToCommand.set(trigger, [command]) : list.push(command);
	}

	public function unmapEnumValue(trigger:EnumValue, command:Class<ICommand>)
	{
		if (enumValueToCommand == null)
			return;
		var list = enumValueToCommand.get(trigger);
		if (list != null)
			list.remove(command);
	}

	public function dispatchEnumValue(trigger:EnumValue)
	{
		if (enumValueToCommand == null)
			return;
		var triggerClass = Type.getClass(trigger);
		var list = enumValueToCommand.get(trigger);
		if (list != null)
			for(commandClass in list)
				invokeCommand(trigger, triggerClass, commandClass);
	}

	public function mapInstance(trigger:{}, command:Class<ICommand>)
	{
		if (!isClassInstance(trigger))
			throw "Trigger " + Std.string(trigger) + " is not an object.";
		if (instanceToCommand == null)
			instanceToCommand = new ObjectMap<Dynamic, Array<Class<ICommand>>>();
		var list = instanceToCommand.get(trigger);
		(list == null) ? instanceToCommand.set(trigger, [command]) : list.push(command);
	}

	public function unmapInstance(trigger:{}, command:Class<ICommand>)
	{
		if (!isClassInstance(trigger))
			throw "Trigger " + Std.string(trigger) + " is not an object.";
		if (instanceToCommand == null)
			return;
		var list = instanceToCommand.get(trigger);
		if (list != null)
			list.remove(command);
	}

	public function dispatchInstance(trigger:{})
	{
		if (!isClassInstance(trigger))
			throw "Trigger " + Std.string(trigger) + " is not an object.";
		if (instanceToCommand == null)
			return;
		var triggerClass = Type.getClass(trigger);
		var list = instanceToCommand.get(trigger);
		if (list != null)
			for(commandClass in list)
				invokeCommand(trigger, triggerClass, commandClass);
	}

	function invokeCommand(trigger:Dynamic, triggerClass:Class<Dynamic>, commandClass:Class<ICommand>)
	{
		if (commandClass == null)
			return;

		var command = injector.instantiate(commandClass);
		if (Std.is(command, TriggerCommand))
		{
			var triggerCommand:TriggerCommand<Dynamic> = cast command;
			triggerCommand.trigger = trigger;
		}
		command.execute();
	}

	function isClass(source:Dynamic):Bool
	{
		return Std.is(source, Class);
	}
	
	function isString(source:Dynamic):Bool
	{
		return Std.is(source, String);
	}
	
	function isEnumValue(source:Dynamic):Bool
	{
		return Reflect.isEnumValue(source);
	}
	
	function isClassInstance(source:Dynamic):Bool
	{
		return Type.getClass(source) != null && !Std.is(source, String) && Math.isNaN(source);
	}
}
