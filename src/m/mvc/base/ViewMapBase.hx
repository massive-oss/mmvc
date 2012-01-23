package m.mvc.base;

import m.inject.IInjector;
import m.mvc.api.IViewContainer;

/**
A base ViewMap implementation
*/
class ViewMapBase
{
	public var contextView(default, set_contextView):IViewContainer;
	public var enabled(default, set_enabled):Bool;
	
	/**
	 * Creates a new <code>ViewMap</code> object
	 *
	 * @param contextView The root view node of the context. The map will listen for ADDED_TO_STAGE events on this node
	 * @param injector An <code>IInjector</code> to use for this context
	 */
	public function new(contextView:IViewContainer, injector:IInjector)
	{
		viewListenerCount = 0;
		enabled = true;

		this.injector = injector;

		// this must come last, see the setter
		this.contextView = contextView;
	}

	public function set_contextView(value:IViewContainer):IViewContainer
	{
		if (value != contextView)
		{
			removeListeners();
			
			contextView = value;

			if (viewListenerCount > 0)
			{
				addListeners();
			}
		}
		
		return contextView;
	}

	public function set_enabled(value:Bool):Bool
	{
		if (value != enabled)
		{
			removeListeners();
			
			enabled = value;
			
			if (viewListenerCount > 0)
			{
				addListeners();
			}
		}

		return value;
	}

	//------------------------------------------------------------------ private

	var injector:IInjector;
	var viewListenerCount:Int;

	function addListeners():Void {}
	function removeListeners():Void {}
	function onViewAdded(view:Dynamic):Void {}
	function onViewRemoved(view:Dynamic):Void {}
}
