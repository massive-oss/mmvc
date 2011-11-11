/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package m.app.mvcs;

import m.app.event.Event;
import m.app.event.IEventDispatcher;
import m.app.core.IInjector;
import m.app.core.IViewContainer;
import m.app.mvcs.support.TestActor;
import m.app.mvcs.support.TestContext;
import m.app.base.support.TestContextView;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class ActorTest
 {
 	public static var TEST_EVENT = "testEvent";

	var context:TestContext;
	var contextView:IViewContainer;
	var actor:TestActor;
	var injector:IInjector;
	var eventDispatcher:IEventDispatcher;
	var dispatched:Bool;
	
	public function new(){}
	
	@Before
	public function before():Void
	{
		dispatched = false;
		contextView = new TestContextView();
		context = new TestContext(contextView);
		actor = new TestActor();
		injector = context.getInjector();
		injector.injectInto(actor);
	}
	
	@After
	public function after():Void
	{
	}

	@Test
	public function passingTest():Void
	{
		Assert.isTrue(true);
	}
	
	@Test
	public function hasEventDispatcher():Void
	{
		Assert.isNotNull(actor.eventDispatcher);
	}
	
	@Test
	public function canDispatchEvent():Void
	{
		context.addEventListener(TEST_EVENT, handleEventDispatch);
		actor.dispatchTestEvent();
		Assert.isTrue(dispatched);
	}
	
	function handleEventDispatch(event:Event):Void
	{
		dispatched = (event.type == TEST_EVENT);
	}
}
