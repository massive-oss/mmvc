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

class TodoView extends DataView<Todo>
{
	var label:String;

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
	}

	override function update()
	{
		#if flash
			sprite.removeChildren();
			sprite.y = index*25;
			var text = new flash.text.TextField();
			text.text = label;
			sprite.addChild(text);
		#elseif js
			element.innerHTML = label;
		#else
			trace("ID: " + toString() + ", label: " + label + ", index: " + index);
		#end
	}
}