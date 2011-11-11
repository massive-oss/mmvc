/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.app.base;

import m.app.event.Event;
import m.app.event.EventDispatcher;
import m.app.event.IEventDispatcher;

import massive.munit.Assert;
import m.app.base.EventMap;
import m.app.core.IEventMap;
import m.app.mvcs.support.CustomEvent;

class EventMapTest
 {
	public function new(){}
	
	var eventDispatcher:IEventDispatcher;
	var eventMap:IEventMap;
	var listenerExecuted:Bool;
	var listenerExecutedCount:Int;
	
	@Before
	public function runBeforeEachTest():Void
	{
		eventDispatcher = new EventDispatcher();
		eventMap = new EventMap(eventDispatcher);
		listenerExecutedCount = 0;
		listenerExecuted = false;
	}
	
	@After
	public function runAfterEachTest():Void
	{
		resetListenerExecuted();
		resetListenerExecutedCount();
	}
	
	@Test
	public function noListener():Void
	{
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(listenerExecuted);//'Listener should NOT have reponded to event'
	}
	
	@Test
	public function mapListenerNormal():Void
	{
		eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
		eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
		Assert.isTrue(listenerExecuted);//'Listener should have reponded to plain event'
		resetListenerExecuted();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(listenerExecuted);//'Listener should have reponded to strong event'
	}
	
	@Test
	public function mapListenerStrong():Void
	{
		eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
		eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
		Assert.isFalse(listenerExecuted);//'Listener should NOT have reponded to plain event'
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(listenerExecuted);//'Listener should have reponded to strong event'
	}
	
	@Test
	public function mapListenerTwice():Void
	{
		eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, mapListenerTwiceListener, CustomEvent);
		eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, mapListenerTwiceListener, CustomEvent);

		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.areEqual(1, listenerExecutedCount);//'Listener should have only responded once'
		
		eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, mapListenerTwiceListener, CustomEvent);
		resetListenerExecutedCount();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.areEqual(0, listenerExecutedCount);//'Listener should NOT have responded'
	}
	
	@Test
	public function unmapListenerNormal():Void
	{
		eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
		eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener);

		eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
		Assert.isFalse(listenerExecuted);//'Listener should NOT have reponded to plain event'

		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(listenerExecuted);//'Listener should NOT have reponded to strong event'
	}
	
	@Test
	public function unmapListenerStrong():Void
	{
		// Map to a concrete Event Class
		eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
		// Unmap, but not the concrete Event Class
		eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener);
		// Dispatch Event of concrete type
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		// Should still respond
		Assert.isTrue(listenerExecuted);//'Listener should have reponded to strong event'
		// Reset
		resetListenerExecuted();
		// Unmap, but this time specifiy the Event Class
		eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
		// Dispatch Event of concrete type
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		// Should no longer respond
		Assert.isFalse(listenerExecuted);//'Listener should NOT have reponded to strong event'
	}
	
	@Test
	public function unmapListeners():Void
	{
		eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
		eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
		eventMap.unmapListeners();
		eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
		Assert.isFalse(listenerExecuted);//'Listener should NOT have reponded to plain event'
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(listenerExecuted);//'Listener should NOT have reponded to strong event'
	}
	
	// helper
	
	function listener(e:Event):Void
	{
		listenerExecuted = true;
	}
	
	function resetListenerExecuted():Void
	{
		listenerExecuted = false;
	}
	
	function mapListenerTwiceListener(e:Event):Void
	{
		listenerExecutedCount++;
	}
	
	function resetListenerExecutedCount():Void
	{
		listenerExecutedCount = 0;
	}
}
