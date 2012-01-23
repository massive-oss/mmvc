package m.mvc.base;

import m.mvc.api.IMediator;
import m.signal.Slot;

/**
An abstract <code>IMediator</code> implementation
*/
class MediatorBase<T> implements IMediator
{
	/**
	 * Internal
	 *
	 * <p>This Mediator's View - used by the RobotLegs MVCS framework internally.
	 * You should declare a dependency on a concrete view component in your
	 * implementation instead of working with this property</p>
	 */
	public var view:T;
	
	/**
	 * Internal
	 *
	 * <p>In the case of deffered instantiation, onRemove might get called before
	 * onCreationComplete has fired. This here Bool helps us track that scenario.</p>
	 */
	var removed:Bool;
	
	/**
	 * Internal
	 * 
	 * <p>An array of slots to remove when the mediator is removed to ensure garbage 
	 * collection.</p>
	 **/
	var slots:Array<AnySlot>;

	/**
	 * Creates a new <code>Mediator</code> object
	 */
	public function new()
	{
		slots = [];
	}
	
	/**
	 * @inheritDoc
	 */
	public function preRegister():Void
	{
		removed = false;
		onRegister();
	}
	
	/**
	 * @inheritDoc
	 */
	public function onRegister():Void
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function preRemove():Void
	{
		removed = true;
		onRemove();
	}
	
	/**
	 * @inheritDoc
	 */
	public function onRemove():Void
	{
		for (slot in slots) slot.remove();
	}
	
	/**
	 * @inheritDoc
	 */
	public function getViewComponent():Dynamic
	{
		return view;
	}
	
	/**
	 * @inheritDoc
	 */
	public function setViewComponent(viewComponent:Dynamic):Void
	{
		view = viewComponent;
	}

	function mediate(slot:AnySlot)
	{
		slots.push(slot);
	}
}
