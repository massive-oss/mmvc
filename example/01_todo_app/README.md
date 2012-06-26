Todo App
============

This is a simple application demonstrating the main components of MMVC, running across JS, Flash and Neko targets.


Overview
-----------

This is a partially implemented Todo application, demonstrates the core elements of MMVC

* configuring application via a Context (`ApplicationContext`)
* loads a list of Todos from a file via a Command (`LoadTodoListCommand`)
* updating contents of a managed Model (`TodoList`) 
* triggering commands via a Signal and listens to responses (`LoadTodoList`)
* instanciating Mediators for registered Views (`ApplicationViewMediator`, `TodoListViewMediator`)

Application Structure
---------------------

The application source contains the following classes:


	src
		Main 	// Main entry point. Instanciates application view and context
		example
			app 	// main application module

				ApplicationContext 		// MMVC Context for application wiring 
				ApplicationView 		// main application view
				ApplicationViewMediator	// main application mediator

			core 	// bare-bones cross platform View classes

				View 		// Simple cross platform View class with concrete implementations for JS and Flash
				DataView	// View with typed data property (usefull for Views bound to a specific data object)

			todo 	// todo module
				command
					LoadTodoListCommand 	// MMVC Command for loading external TodoList
				model
					Todo 					// Todo data object
					TodoList 				// Collection of Todos
				signal
					LoadTodoList 			// Signal for loading TodoList and handling responses
				view
					TodoListView 			// View for TodoList
					TodoListViewMediator 	// MMVC Mediator for TodoList. Triggers call to LoadTodoList
					TodoView 				// View for inidividual Todo items
					TodoStatsView 			// Summary of current todo list + button to create new Todo
	
