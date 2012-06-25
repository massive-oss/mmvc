package example.app;

import example.todo.signal.LoadTodoList;
import example.todo.model.TodoList;
import example.todo.model.Todo;

/**
Main application view mediator.

Responsible for triggering sub view creation once application is wired up to the context

@see ApplicationView
*/
class ApplicationViewMediator extends m.mvc.impl.Mediator<ApplicationView>
{
	public function new()
	{
		super();
	}

	/**
	Context has now been initialized. Time to create the rest of the main views in the application
	*/
	override function onRegister()
	{
		view.createViews();
	}
}