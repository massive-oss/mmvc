package example.todo.view;

import example.core.View;
import example.todo.model.Todo;
import example.todo.model.TodoList;

class TodoListView extends DataView<TodoList>
{
	public function new(?data:TodoList)
	{
		#if js tagName = "ul"; #end
		super(data);
	}

	override public function dispatch(event:String, view:View)
	{
		switch(event)
		{
			case ViewEvent.ACTIONED:
			{
				var todoView = cast(view, TodoView);
				var data = todoView.data;
				data.done = !data.done;
				todoView.setData(data, true);
			}
			default:
			{
				super.dispatch(event, view);
			}
		}
	}

	override function dataChanged()
	{
		super.dataChanged();

		for(child in children)
		{
			removeChild(child);	
		}

		for(todo in data.getItems())
		{
			var view = new TodoView(todo);
			addChild(view);
		}
	}
}

#if js
import js.Dom;
#end

class TodoView extends DataView<Todo>
{
	var label:String;
	var done:Bool;

	#if flash
	var textField:flash.text.TextField;
	var icon:flash.display.Bitmap;
	#end

	public function new(?data:Todo)
	{
		#if js tagName = "li"; #end

		label = "";
		super(data);
	}

	override function dataChanged()
	{
		super.dataChanged();
		label = data != null ? data.name : "";
		done = data != null && data.done;
	}

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

	override function remove()
	{
		#if flash
			sprite.removeEventListener(flash.events.MouseEvent.CLICK, flash_onClick);
		#elseif js
			element.onclick = null;
		#end
		//override in sub class
	}

	override function update()
	{
		#if flash
			sprite.y = index*25;
			textField.text = label;

			var uri = "img/" + (done ? "done" : "none") + ".png";
			var loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, flash_onBitmapLoaderComplete);
			loader.load(new flash.net.URLRequest(uri));
			
		#elseif js
			element.innerHTML = label;
			element.className = type + (done? " done" : "");
		#else
			trace("ID: " + toString() + ", label: " + label + ", index: " + index);
		#end
	}

	#if flash

		function flash_onBitmapLoaderComplete (event:flash.events.Event)
		{
			var content = cast (event.target, flash.display.LoaderInfo).content;
		    icon.bitmapData = cast(content, flash.display.Bitmap).bitmapData;
		}

		function flash_onClick(event:flash.events.MouseEvent)
		{
			dispatch(ViewEvent.ACTIONED, this);
		}

	#elseif js

		function js_onClick(event:js.Event)
		{	
			dispatch(ViewEvent.ACTIONED, this);
		}

	#end
}