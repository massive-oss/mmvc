package example.app;

import example.core.View;

/**
Main Application View.

Implements IViewContainer to provide view added/removed events back to the Context.mediatorMap

Extends core view class for basic event bubbling across platforms

@see example.core.View
@see mmvc.api.IViewContainer
*/

class ApplicationView extends View, implements mmvc.api.IViewContainer
{
	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;

	public function new()
	{
		super();
	}

	/**
	Called by ApplicationViewMediator once application is wired up to the context
	@see ApplicationViewMediator.onRegister;
	*/
	public function createViews()
	{
		var todoView = new example.todo.view.TodoListView();
		addChild(todoView);
	}

	/**
	Overrides signal bubbling to trigger view added/removed handlers for IViewContainer
	@param event 	a string event type
	@param view 	instance of view that originally dispatched the event
	*/
	override public function dispatch(event:String, view:View)
	{
		switch(event)
		{
			case View.ADDED:
			{
				viewAdded(view);
			}
			case View.REMOVED:
			{
				viewRemoved(view);
			}
			default:
			{
				super.dispatch(event, view);
			}
		}
	}

	/**
	Required by IViewContainer
	*/
	public function isAdded(view:Dynamic):Bool
	{
		return true;
	}

	/**
	Overrides View.initialize to add to top level platform specific sprite/element
	*/
	override function initialize()
	{
		super.initialize();
		#if flash
			flash.Lib.current.addChild(sprite);
		#elseif js
			js.Lib.document.body.appendChild(element);
		#end
	}
}