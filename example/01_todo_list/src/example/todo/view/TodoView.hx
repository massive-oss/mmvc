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
		#elseif neko
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