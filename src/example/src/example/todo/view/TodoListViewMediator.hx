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

class TodoListViewMediator extends mmvc.impl.Mediator<TodoListView>
{
	@inject public var loadTodoList:LoadTodoList;

	var list:TodoList;

	public function new()
	{
		super();
	}

	/**
	Dispatches loadTodoList on registration of mediator
	@see mmvc.impl.Mediator
	@see mmvc.base.MediatorBase.mediate()
	*/
	override function onRegister()
	{
		//using mediate() to store listeners for easy cleanup during removal
		mediate(view.signal.add(viewHandler));
		mediate(loadTodoList.completed.addOnce(loadCompleted));
		mediate(loadTodoList.failed.addOnce(loadFailed));

		loadTodoList.dispatch();
	}

	/**
	Override onRemove to remove any unmediated listeners
	@see mmvc.impl.Mediator
	*/
	override public function onRemove():Void
	{
		super.onRemove();
		//remove un mediated listeners
	}

	/**
	callback for successful load of TodoList
	@see example.todo.signal.LoadTodoList
	*/
	function loadCompleted(list:TodoList)
	{
		this.list = list;
		view.setData(list);
	}

	function loadFailed(error:Dynamic)
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