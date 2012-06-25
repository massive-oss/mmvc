package example.todo.view;

import example.todo.signal.LoadTodoList;
import example.todo.model.TodoList;
import example.todo.model.Todo;
import example.todo.view.TodoListView;

import example.core.View;
/**
Mediator for TodoListView.

Loads default TodoList on registration.
Updates view when data has been loaded.

@see example.todo.view.TodoListView
@see example.todo.signal.LoadTodoList
*/

class TodoListViewMediator extends m.mvc.impl.Mediator<TodoListView>
{
	@inject public var loadTodoList:LoadTodoList;


	var list:TodoList;

	public function new()
	{
		super();
	}

	/**
	Dispatches loadTodoList on registration of mediator
	@see m.mvc.impl.Mediator
	*/
	override function onRegister()
	{
		view.signal.add(viewHandler);
		loadTodoList.completed.addOnce(completed);
		loadTodoList.failed.addOnce(failed);
		loadTodoList.dispatch();
	}

	/**
	callback for successful load of TodoList
	@see example.todo.signal.LoadTodoList
	*/
	function completed(list:TodoList)
	{
		this.list = list;
		view.setData(list);
	}

	function failed(error:Dynamic)
	{
		view.showError(Std.string(error));
	}

	/**
	Adds a new todo item to the model when CREATE_TODO event is dispatched
	*/
	function viewHandler(event:String, view:View)
	{
		if(event == TodoListView.CREATE_TODO)
		{
			list.add(new Todo());
		}
	}


}