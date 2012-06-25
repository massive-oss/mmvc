package example.app;

import example.todo.signal.LoadTodoList;
import example.todo.model.TodoList;
import example.todo.model.Todo;

class ApplicationViewMediator extends m.mvc.impl.Mediator<ApplicationView>
{
	public function new()
	{
		super();
	}

	override function onRegister()
	{
		view.createViews();
	}
}