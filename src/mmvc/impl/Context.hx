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

import mmvc.api.ICommandMap;
import mmvc.api.IContext;
import mmvc.api.IMediatorMap;
import mmvc.api.ITriggerMap;
import mmvc.api.IViewContainer;
import mmvc.api.IViewMap;
import mmvc.base.CommandMap;
import mmvc.base.MediatorMap;
import mmvc.base.TriggerMap;
import mmvc.base.ViewMap;
import minject.Injector;
import minject.Reflector;

/**
	Abstract MVCS `IContext` implementation
**/
class Context implements IContext
{
	var autoStartup:Bool;

	public var contextView(default, set):IViewContainer;
	
	public var commandMap(get, null):ICommandMap;

	public var injector(get, null):Injector;
	
	public var mediatorMap(get, null):IMediatorMap;
	
	public var reflector(get, null):Reflector;
	
	public var viewMap(get, null):IViewMap;
	
	public var triggerMap(get, null):ITriggerMap;
	
	/**
		Abstract Context Implementation
		
		Extend this class to create a Framework or Application context.
		
		@param contextView The root view node of the context.
		@param autoStartup Should this context automatically invoke it's `startup` method when it's 
			`contextView` arrives on Stage
	**/
	public function new(?contextView:IViewContainer=null, ?autoStartup:Bool=true)
	{
		this.autoStartup = autoStartup;
		this.contextView = contextView;
	}
	
	/**
		The startup hook. Override this in your Application context.
	**/
	public function startup():Void {}
	
	/**
		The shutdown hook. Override this in your Application context.
	**/
	public function shutdown():Void {}
	
	public function set_contextView(value:IViewContainer):IViewContainer
	{
		if (contextView != value)
		{
			contextView = value;
			commandMap = null;
			mediatorMap = null;
			viewMap = null;
			triggerMap = null;

			mapInjections();
			checkAutoStartup();
		}

		return value;
	}
	
	/**
		The `Injector` for this `IContext`
	**/
	public function get_injector():Injector
	{
		if (injector == null)
		{
			return createInjector();
		}

		return injector;
	}
	
	/**
		The `Reflector` for this `IContext`
	**/
	function get_reflector():Reflector
	{
		if (reflector == null)
		{
			reflector = new Reflector();
		}

		return reflector;
	}
	
	/**
		The `ICommandMap` for this `IContext`
	**/
	function get_commandMap():ICommandMap
	{
		if (commandMap == null)
		{
			commandMap = new CommandMap(createChildInjector());
		}

		return commandMap;
	}
	
	/**
		The `IMediatorMap` for this `IContext`
	**/
	function get_mediatorMap():IMediatorMap
	{
		if (mediatorMap == null)
		{
			mediatorMap = new MediatorMap(contextView, createChildInjector(), reflector);
		}

		return mediatorMap;
	}
	
	/**
		The `IViewMap` for this `IContext`
	**/
	function get_viewMap():IViewMap
	{
		if (viewMap == null)
		{
			viewMap = new ViewMap(contextView, injector);
		}

		return viewMap;
	}
	
	/**
		The `ITriggerMap` for this `IContext`
	**/
	function get_triggerMap():ITriggerMap
	{
		if (triggerMap == null)
		{
			triggerMap = new TriggerMap(injector);
		}

		return triggerMap;
	}
	
	/**
		Injection Mapping Hook
		
		Override this in your application context to change the default configuration
		
		> Beware of collisions in your container
	**/
	function mapInjections():Void
	{
		injector.mapValue(Reflector, reflector);
		injector.mapValue(Injector, injector);
		injector.mapValue(IViewContainer, contextView);
		injector.mapValue(ICommandMap, commandMap);
		injector.mapValue(IMediatorMap, mediatorMap);
		injector.mapValue(IViewMap, viewMap);
		injector.mapValue(ITriggerMap, triggerMap);
	}
	
	function checkAutoStartup():Void
	{
		if (autoStartup && contextView != null)
		{
			startup();
		}
	}
	
	function createInjector():Injector
	{
		injector = new Injector();
		return injector;
	}
	
	function createChildInjector():Injector
	{
		return injector.createChildInjector();
	}
}
