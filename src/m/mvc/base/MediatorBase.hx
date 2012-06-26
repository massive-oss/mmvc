package m.mvc.base;

import m.mvc.api.IMediator;
import m.signal.Slot;

/**
An abstract <code>IMediator</code> implementation
*/
class MediatorBase<T> implements IMediator
{
	/**
	This Mediator's View - used by the RobotLegs MVCS framework internally. You 
	should declare a dependency on a concrete view component in your 
	implementation instead of working with this property
	*/
	public var view:T;
	
	/*
	In the case of deffered instantiation, onRemove might get called before
	onCreationComplete has fired. This here Bool helps us track that scenario.
	*/
	var removed:Bool;
	
	/*
	An array of slots to remove when the mediator is removed to ensure garbage 
	collection.
	*/
	var slots:Array<AnySlot>;

	public function new()
	{
		slots = [];
	}
	
	public function preRegister():Void
	{
		removed = false;
		onRegister();
	}
	
	public function onRegister():Void
	{
	}
	
	public function preRemove():Void
	{
		removed = true;
		onRemove();
	}
	
	public function onRemove():Void
	{
		for (slot in slots) slot.remove();
	}
	
	public function getViewComponent():Dynamic
	{
		return view;
	}
	
	public function setViewComponent(viewComponent:Dynamic):Void
	{
		view = viewComponent;
	}

	/**
	Stores reference to any signal listeners, ensuring they are removed during onRemove

	Usage:
		mediate(something.completed.add(completed));
	*/
	function mediate(slot:AnySlot)
	{
		slots.push(slot);
	}
}
