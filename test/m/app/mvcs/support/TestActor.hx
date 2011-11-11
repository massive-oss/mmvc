/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package m.app.mvcs.support;

import m.app.event.Event;
import m.app.mvcs.Actor;
import m.app.mvcs.ActorTest;

class TestActor extends Actor
{
	public function new()
	{
		super();
	}

	public function dispatchTestEvent():Void
	{
		eventDispatcher.dispatchEvent(new Event(ActorTest.TEST_EVENT));
	}
}
