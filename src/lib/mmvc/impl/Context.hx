package mmvc.impl;

import mmvc.base.CommandMap;
import mmvc.base.MediatorMap;
import mmvc.base.ViewMap;
import mmvc.api.ICommandMap;
import mmvc.api.IContext;
import minject.IInjector;
import mmvc.api.IMediatorMap;
import minject.IReflector;
import mmvc.api.IViewMap;
import mmvc.api.IViewContainer;
import minject.Injector;
import minject.Reflector;
import mmvc.api.IViewContainer;

/**
Dispatched by the <code>startup()</code> method when it finishes 
executing.

<p>One common pattern for application startup/bootstrapping makes use of 
the <code>startupComplete</code> event. In this pattern, you do the 
following:</p>
<ul>
  <li>Override the <code>startup()</code> method in your Context 
      subclass and set up application mappings in your 
      <code>startup()</code> override as you always do in Robotlegs.</li>
  <li>Create commands that perform startup/bootstrapping operations
      such as loading the initial data, checking for application updates,
      etc.</li>
  <li><p>Map those commands to the <code>ContextEvent.STARTUP_COMPLETE</code>
      event:</p>
      <listing>commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadInitialDataCommand, ContextEvent, true):</listing>
      </li>
  <li>Dispatch the <code>startupComplete</code> (<code>ContextEvent.STARTUP_COMPLETE</code>)
      event from your <code>startup()</code> override. You can do this
      in one of two ways: dispatch the event yourself, or call 
      <code>super.startup()</code>. (The Context class's 
      <code>startup()</code> method dispatches the 
      <code>startupComplete</code> event.)</li>
</ul>

@eventType mmvc.base.ContextEvent.STARTUP_COMPLETE

@see #startup()
*/

/**
Abstract MVCS <code>IContext</code> implementation
*/
class Context implements IContext
{
	var autoStartup:Bool;

	public var contextView(default, set_contextView):IViewContainer;
	
	public var commandMap(get_commandMap, null):ICommandMap;

	public var injector(get_injector, null):IInjector;
	
	public var mediatorMap(get_mediatorMap, null):IMediatorMap;
	
	public var reflector(get_reflector, null):IReflector;
	
	public var viewMap(get_viewMap, null):IViewMap;
	
	/**
	Abstract Context Implementation
	
	<p>Extend this class to create a Framework or Application context</p>
	
	@param contextView The root view node of the context. The context will 
	listen for ADDED_TO_STAGE events on this node
	@param autoStartup Should this context automatically invoke it's 
	<code>startup</code> method when it's <code>contextView</code> arrives 
	on Stage?
	*/
	public function new(?contextView:IViewContainer=null, ?autoStartup:Bool=true)
	{
		this.autoStartup = autoStartup;
		this.contextView = contextView;
	}
	
	/**
	The startup hook. Override this in your Application context.
	*/
	public function startup():Void {}
	
	/**
	The Startup Hook. Override this in your Application context.
	*/
	public function shutdown():Void {}
	
	public function set_contextView(value:IViewContainer):IViewContainer
	{
		if (contextView != value)
		{
			contextView = value;
			// Hack: We have to clear these out and re-map them
			commandMap = null;
			mediatorMap = null;
			viewMap = null;

			mapInjections();
			checkAutoStartup();
		}

		return value;
	}
	
	/**
	The <code>IInjector</code> for this <code>IContext</code>
	*/
	function get_injector():IInjector
	{
		if (injector == null)
		{
			return createInjector();
		}

		return injector;
	}
	
	/**
	The <code>IReflector</code> for this <code>IContext</code>
	*/
	function get_reflector():IReflector
	{
		if (reflector == null)
		{
			reflector = new Reflector();
		}

		return reflector;
	}
	
	/**
	The <code>ICommandMap</code> for this <code>IContext</code>
	*/
	function get_commandMap():ICommandMap
	{
		if (commandMap == null)
		{
			commandMap = new CommandMap(createChildInjector());
		}

		return commandMap;
	}
	
	/**
	The <code>IMediatorMap</code> for this <code>IContext</code>
	*/
	function get_mediatorMap():IMediatorMap
	{
		if (mediatorMap == null)
		{
			mediatorMap = new MediatorMap(contextView, createChildInjector(), reflector);
		}

		return mediatorMap;
	}
	
	/**
	The <code>IViewMap</code> for this <code>IContext</code>
	*/
	function get_viewMap():IViewMap
	{
		if (viewMap == null)
		{
			viewMap = new ViewMap(contextView, injector);
		}

		return viewMap;
	}
	
	/**
	Injection Mapping Hook
	
	<p>Override this in your Framework context to change the default configuration</p>
	
	<p>Beware of collisions in your container</p>
	*/
	function mapInjections():Void
	{
		injector.mapValue(IReflector, reflector);
		injector.mapValue(IInjector, injector);
		injector.mapValue(IViewContainer, contextView);
		injector.mapValue(ICommandMap, commandMap);
		injector.mapValue(IMediatorMap, mediatorMap);
		injector.mapValue(IViewMap, viewMap);
	}
	
	function checkAutoStartup():Void
	{
		if (autoStartup && contextView != null)
		{
			startup();
		}
	}
	
	function createInjector():IInjector
	{
		injector = new Injector();
		return injector;
	}
	
	function createChildInjector():IInjector
	{
		return injector.createChildInjector();
	}
}
