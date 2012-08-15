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