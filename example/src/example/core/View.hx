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

package example.core;

#if flash
import flash.display.Sprite;
#elseif js
import js.Lib;
import js.Browser;
import js.html.Element;
#end
import msignal.Signal;

/**
Simple implementation of a cross platform View class that composes a
native element/sprite depending on platform.

Contains a basic display lifecycle (initialize, update, remove)
Contains a basic display hierachy (addChild, removeChild)
Contains basic dispatching and bubbling via a Signal (dispatch)

Each target has a platform specific element for accessing the raw display API (flash: sprite, js: element)

@see msignal.Signal
@see DataView

*/
class View
{
	/**
	Event type dispatched when view is added to stage
	@see View.addChild()
	*/
	inline public static var ADDED:String = "added";

	/**
	Event type dispatched when view is removed from stage
	@see View.removeChild()
	*/
	inline public static var REMOVED:String = "removed";

	/**
	Event type dispatched when view is actioned (e.g. clicked)
	*/
	inline public static var ACTIONED:String = "actioned";

	/**
	private counter to maintain unique identifieds for created views
	*/
	static var idCounter:Int = 0;

	/**
	Unique identifier (viewXXX);
	*/
	public var id(default, null):String;
	
	/**
	reference to parent view (if available)
	@see View.addChild()
	@see View.removeChild()
	*/
	public var parent(default, null):View;

	/**
	reference to the index relative to siblings
	defaults to -1 when view has no parent 
	@see View.addChild()
	*/
	public var index(default, set):Int;


	/**
	Signal used for dispatching view events
	Usage:
		view.addListener(viewHandler);
		...
		function viewHandler(event:String, view:View);
	*/
	public var signal(default, null):Signal2<String, View>;

	#if flash

		/**
		native flash sprite representing this view in the display list
		*/
		public var sprite(default, null):Sprite;

	#elseif js

		/**
		native html element representing this view in the DOM
		*/
		public var element(default, null):Element;
		
		/**
		Optional tag name to use when creating element via Lib.document.createElement
		defaults to 'div'
		*/
		var tagName:String;
	#end

	/**
	Contains all children currently added to view
	*/
	var children:Array<View>;

	/**
	String representation of unqualified class name
	(e.g. example.core.View.className == "View");
	*/
	var className:String;

	public function new()
	{
		//create unique identifier for this view
		id = "view" + (idCounter ++);

		//set default index without triggering setter
		Reflect.setField(this, "index", -1);

		className = Type.getClassName(Type.getClass(this)).split(".").pop();
		
		children = [];
		signal = new Signal2<String, View>();
		
		initialize();
	}

	public function toString():String
	{
		return className + "(" + id + ")";
	}

	/**
	dispatches a view event via the signal
	@param event 	string event type
	@param view 	originating view object
	*/
	public function dispatch(event:String, view:View)
	{
		if (view == null) view = this;
		signal.dispatch(event, view);
	}


	/**
	Adds a child view to the display heirachy.
	
	Dispatches an ADDED event on completion.

	@param view 	child to add
	*/
	public function addChild(view:View)
	{
		view.signal.add(this.dispatch);
		view.parent = this;
		view.index = children.length;

		children.push(view);

		#if flash
		sprite.addChild(view.sprite);
		#elseif js
		element.appendChild(view.element);
		#end

		dispatch(ADDED, view);
	}


	/**
	Removes an existing child view from the display heirachy.
	
	Dispatches an REMOVED event on completion.

	@param view 	child to remove
	*/
	public function removeChild(view:View)
	{
		var removed = children.remove(view);

		if (removed)
		{
			var oldIndex = view.index;

			view.remove();
			view.signal.remove(this.dispatch);
			view.parent = null;
			view.index = -1;

			#if flash
			sprite.removeChild(view.sprite);
			#elseif js
			element.removeChild(view.element);
			#end

			for(i in oldIndex...children.length)
			{
				var view = children[i];
				view.index = i;
			}

			dispatch(REMOVED, view);
		}
	}

	///// internal //////

	/**
	Initializes platform specific properties and state
	*/
	function initialize()
	{
		#if flash
		sprite = new Sprite();
		#elseif js
		if (tagName == null) tagName = "div";
		element = Browser.document.createElement(tagName);
		element.setAttribute("id", id);
		element.className = className;
		#end
	}

	/**
	Removes platform specific properties and state
	*/
	function remove()
	{
		//override in sub class
	}

	/**
	Updates platform specific properties and state
	*/
	function update()
	{
		//override in sub class
	}

	/**
	Sets index and triggers an update when index changes
	@param value 	target index
	*/
	function set_index(value:Int):Int
	{
		if (index != value)
		{
			index = value;
			update();
		}
		
		return index;
	}

}
