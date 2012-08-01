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
import example.todo.model.TodoList;

#if js
import js.Dom;
#end

/**
Provides summary information on the current TodoList

@see example.core.DataView
@see example.todo.model.TodoList
*/
class TodoStatsView extends DataView<String>
{
	#if flash
	var textField:flash.text.TextField;
	var button:flash.display.Sprite;
	#elseif js
	var label:HtmlDom;
	var button:HtmlDom;
	#end

	/**
	Overrides constructor to set js tag name to unordered list (ul)

	@param data 	default TodoList
	@see example.core.DataView
	*/
	public function new(?data:String)
	{
		super(data);
	}

	/**
	Overrides initialized to initialise sub views on flash target

	@see example.core.View
	*/
	override function initialize()
	{
		super.initialize();

		#if flash
			textField = new flash.text.TextField();
			textField.text = data != null ? data : "Loading items...";
			textField.width = 180;
			sprite.addChild(textField);

			button = new flash.display.Sprite();
			button.graphics.beginFill(0xCCCCCC);
			button.graphics.lineStyle(1, 0xAAAAAA);
			button.graphics.drawRect(0, 0, 100, 25);
			button.x = 200;
			button.y = 5;
			sprite.addChild(button);


			sprite.graphics.beginFill(0xCCCCCC);
			sprite.graphics.drawRect(0, 0, 320, 35);

			var buttonText = new flash.text.TextField();
			buttonText.text = "New Item";
			button.addChild(buttonText);
			button.addEventListener(flash.events.MouseEvent.CLICK, flash_onClick);


		#elseif js
			label = js.Lib.document.createElement("label");
			label.innerHTML = data != null ? data : "Loading items...";
			element.appendChild(label);

			button = js.Lib.document.createElement("a");
			button.innerHTML = "New item";
			button.onclick = js_onClick;
			element.appendChild(button);
		#end
	}

	override function remove()
	{
		super.remove();
		#if js
		button.onclick = null;
		#end
	}

	/**
	Overrides update to set view specific properties in flash and js
	@see example.core.View
	*/
	override function update()
	{
		if(data != null)
		{
			#if flash
				textField.text = data;
			#elseif js
				label.innerHTML = data;
			#elseif neko

				Sys.println(data);
			#else
				trace("ID: " + toString() + ", data: " + data);
			#end
		}
	}


	#if flash
	/**
	Flash only: dispatches ACTIONED event on mouse click
	*/
	function flash_onClick(event:flash.events.MouseEvent)
	{
		dispatch(View.ACTIONED, this);
	}


	#elseif js
	function js_onClick(event:js.Event)
	{	
		dispatch(View.ACTIONED, this);
	}
	#end
}
