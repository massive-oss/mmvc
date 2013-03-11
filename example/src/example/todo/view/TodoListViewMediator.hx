/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

package example.todo.view;

import example.todo.signal.LoadTodoList;
import example.todo.model.TodoList;
import example.todo.model.Todo;
import example.todo.view.TodoListView;
import src.example.todo.signal.TestSignal;
import example.todo.model.TestData;

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
	
	@inject public var testSignal:TestSignal;

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
			testSignal.dispatch({name:"Jim", age:12}, TestEnum.SomeString("Hi THere"));

			list.add(new Todo());
		}
	}
}