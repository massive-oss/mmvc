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



class ApplicationContext extends m.mvc.impl.Context
{
	public function new(?contextView:IViewContainer=null)
	{
		super(contextView);
	}

	override public function startup()
	{
		commandMap.mapSignalClass(LoadTodoList, LoadTodoListCommand);

		injector.mapSingleton(TodoList);

		mediatorMap.mapView(TodoListView, TodoListViewMediator);


		// main application view mediator
		mediatorMap.mapView(ApplicationView, ApplicationViewMediator);
		
	}

	override public function shutdown()
	{
		
	}
}