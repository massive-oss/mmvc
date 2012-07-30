package example.todo.signal;

import msignal.Signal;

import example.todo.model.TodoList;

/**
Application signal for loading an existing external Todo list.

Includes sub signals for completed/failed handlers once list is loaded.

@see example.todo.command.LoadTodoListCommand
@see msignal.Signal

*/
class LoadTodoList extends msignal.Signal0
{
	/**
	dispatched once TodoList has been loaded
	*/
	public var completed:Signal1<TodoList>;

	/**
	Dispatched if application unable to load TodoList
	*/
	public var failed:Signal1<Dynamic>;
	
	public function new()
	{
		super();
		completed = new Signal1<TodoList>(TodoList);
		failed = new Signal1<Dynamic>(Dynamic);
	}
}