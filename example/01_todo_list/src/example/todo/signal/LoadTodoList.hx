package example.todo.signal;

import m.signal.Signal;

import example.todo.model.TodoList;

class LoadTodoList extends m.signal.Signal0
{
	public var completed:Signal1<TodoList>;
	public var failed:Signal1<Dynamic>;
	
	public function new()
	{
		super();
		completed = new Signal1<TodoList>(TodoList);
		failed = new Signal1<Dynamic>(Dynamic);
	}
}