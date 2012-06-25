package example.app;

import example.core.View;

class ApplicationView extends View, implements m.mvc.api.IViewContainer
{
	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;

	public function new()
	{
		super();
	}

	public function createViews()
	{
		var todoView = new example.todo.view.TodoListView();
		addChild(todoView);
	}

	override public function dispatch(event:String, view:View)
	{
		//trace(event + ": " + view.toString());
		switch(event)
		{
			case ViewEvent.ADDED:
			{
				viewAdded(view);
			}
			case ViewEvent.REMOVED:
			{
				viewRemoved(view);
			}
			default:
			{
				super.dispatch(event, view);
			}
		}
	}

	public function isAdded(view:Dynamic):Bool
	{
		return true;
	}

	////

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