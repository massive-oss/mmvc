Todo App
============

This is a simple application demonstrating the main components of MMVC, running 
across JS, Flash and Neko targets.

> This application requires Haxe 3.0 or greater.

Overview
-----------

This is a partially implemented Todo application, demonstrating the core 
elements of MMVC

* configuring application via a Context (`ApplicationContext`)
* loads a list of Todos from a file via a Command (`LoadTodoListCommand`)
* updating contents of a managed Model (`TodoList`) 
* triggering commands via a Signal and listens to responses (`LoadTodoList`)
* instanciating Mediators for registered Views (`ApplicationViewMediator`, 
  `TodoListViewMediator`)


Building the app
----------------

Compile the js, flash and neko targets via the hxml file:

	haxe build.hxml


Application Structure
---------------------

The application source contains the following classes:

	Main.hx // main entry point, instanciates application view and context

	/example

		/app // main application module

			ApplicationContext.hx       // application Context
			ApplicationView.hx          // application View
			ApplicationViewMediator.hx	// application Mediator

		/core // bare-bones cross platform View classes

			View.hx  // simple cross platform View class with concrete implementations for JS and Flash
			DataView // View with typed data property (useful for Views bound to a specific data object)

		/todo

			/command
				LoadTodoListCommand.hx 	// MMVC Command for loading external TodoList
			/model
				Todo.hx                 // todo data object
				TodoList.hx             // collection of todos
			/signal
				LoadTodoList.hx         // signal for loading TodoList and handling responses
			/view
				TodoListView.hx         // View for TodoList
				TodoListViewMediator.hx // Mediator for TodoList. Triggers call to LoadTodoList
				TodoView.hx             // View for inidividual Todo items
				TodoStatsView.hx        // Summary of current todo list + button to create new Todo
	
