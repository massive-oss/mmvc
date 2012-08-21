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

package example.todo.view;

import example.core.View;
import example.core.DataView;

import example.todo.model.Todo;

#if js
import js.Dom;
#end

/**
View for a single Todo model.

@see example.core.DataView
*/
class TodoView extends DataView<Todo>
{
	var label:String;
	var done:Bool;

	#if flash
	var textField:flash.text.TextField;
	var icon:flash.display.Bitmap;
	#end

	/**
	Overrides constructor to set js tagName to list item (li)
	@param data  	default Todo model
	@see example.core.DataView
	*/
	public function new(?data:Todo)
	{
		#if js tagName = "li"; #end
		label = "";
		super(data);
	}

	/**
	Overrides dataChanged to update internal properties
	@see example.core.DataView
	*/
	override function dataChanged()
	{
		super.dataChanged();
		label = data != null ? data.name : "";
		done = data != null && data.done;
	}

	/**
	Overrides initialized to set click handlers and 
	to initialise sub views on flash target

	@see example.core.View
	*/
	override function initialize()
	{
		super.initialize();

		#if flash
			icon = new flash.display.Bitmap();
			sprite.addChild(icon);

			textField = new flash.text.TextField();
			textField.x = 20;
			sprite.addChild(textField);
			sprite.addEventListener(flash.events.MouseEvent.CLICK, flash_onClick);
		#elseif js
			element.onclick = js_onClick;
		#end
	}

	/**
	Overrides removed to clear event listeners
	@see example.core.View
	*/
	override function remove()
	{
		#if flash
			sprite.removeEventListener(flash.events.MouseEvent.CLICK, flash_onClick);
		#elseif js
			element.onclick = null;
		#end
	}

	/**
	Overrides update to set view specific properties in flash and js
	@see example.core.View
	*/
	override function update()
	{
		#if flash
			sprite.y = (index+1)*25;
			textField.text = label;

			var uri = "img/" + (done ? "done" : "none") + ".png";
			var loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, flash_onBitmapLoaderComplete);
			loader.load(new flash.net.URLRequest(uri));
			
		#elseif js
			element.innerHTML = label;
			element.className = className + (done? " done" : "");
		#elseif (sys||neko||cpp)
			if(index > -1)
			{
				var msg = label + (done ? " (completed)" : "");
				Sys.println("	" + (index) + ": " + msg);
			}
		#else
			trace("ID: " + toString() + ", label: " + label + ", index: " + index);
		#end

	}

	#if flash

		/**
		Flash only: updates icon bitmap on load of image
		*/
		function flash_onBitmapLoaderComplete (event:flash.events.Event)
		{
			var content = cast (event.target, flash.display.LoaderInfo).content;
		    icon.bitmapData = cast(content, flash.display.Bitmap).bitmapData;
		}

		/**
		Flash only: dispatches ACTIONED event on mouse click
		*/
		function flash_onClick(event:flash.events.MouseEvent)
		{
			dispatch(View.ACTIONED, this);
		}

	#elseif js

		/**
		JS only: dispatches ACTIONED event on mouse click
		*/
		function js_onClick(event:js.Event)
		{	
			dispatch(View.ACTIONED, this);
		}

	#end
}