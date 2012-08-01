/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

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