package m.app.mvcs.support;

import m.app.event.Event;

class CustomEvent extends Event
{
	public static var STARTED:String = 'started';
	public static var STOPPED:String = 'stopped';
	public static var EVENT0:String = 'event0';
	public static var EVENT1:String = 'event1';
	public static var EVENT2:String = 'event2';
	public static var EVENT3:String = 'event3';
	
	public function new(type:String)
	{
		super(type);
	}
	
	public override function clone():Event
	{
		return new CustomEvent(type);
	}
}
