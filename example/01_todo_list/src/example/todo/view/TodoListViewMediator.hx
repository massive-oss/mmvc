package example.todo.view;

import example.todo.signal.LoadTodoList;
import example.todo.model.TodoList;
import example.todo.model.Todo;

class TodoListViewMediator extends m.mvc.impl.Mediator<TodoListView>
{
	@inject public var loadTodoList:LoadTodoList;

	public function new()
	{
		super();
	}

	override function onRegister()
	{
		loadTodoList.completed.addOnce(completed);
		loadTodoList.failed.addOnce(failed);
		loadTodoList.dispatch();
	}

	function completed(list:TodoList)
	{
		view.setData(list);
	}

	function failed(error:Dynamic)
	{
		//
	}

}