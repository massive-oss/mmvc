package example.app;

import m.mvc.api.IViewContainer;


// Main Application
import example.app.ApplicationView;
import example.app.ApplicationViewMediator;

// TODO Module
import example.todo.signal.LoadTodoList;
import example.todo.command.LoadTodoListCommand;
import example.todo.model.TodoList;
import example.todo.view.TodoListView;
import example.todo.view.TodoListViewMediator;


/**
Application wide context.
<p>Provides mapping of following classes:
<ul>
	<li>Signals to commands</li>
	<li>Models</li>
	<li>Views to ViewMediators</li>
</ul> 
</p>
@see m.mvc.impl.Context
*/
class ApplicationContext extends m.mvc.impl.Context
{
	public function new(?contextView:IViewContainer=null)
	{
		super(contextView);
	}

	/**
	Overrides startup to configure all context commands, models and mediators
	@see m.mvc.impl.Context
	*/
	override public function startup()
	{
		// wiring for todo model
		commandMap.mapSignalClass(LoadTodoList, LoadTodoListCommand);

		injector.mapSingleton(TodoList);
		
		mediatorMap.mapView(TodoListView, TodoListViewMediator);

		// wiring for main application module
		mediatorMap.mapView(ApplicationView, ApplicationViewMediator);
	}

	/**
	Overrides shutdown to remove/cleanup mappings
	@see m.mvc.impl.Context
	*/
	override public function shutdown()
	{
		
	}
}