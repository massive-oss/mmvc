package example.todo.command;

import example.todo.signal.LoadTodoList;
import example.todo.model.TodoList;
import example.todo.model.Todo;

import m.loader.Loader;
import m.loader.JSONLoader;

/**
Loads an existing todo list from the file system,

Dispatches LoadTodoList.completed or failed signal based on result of loader.

@see example.todo.signal.LoadTodoList
@see m.loader.JSONLoader
*/
class LoadTodoListCommand extends m.mvc.impl.Command
{
	@inject
	public var list:TodoList;

	@inject
	public var signal:LoadTodoList;

	var loader:JSONLoader;

	public function new()
	{
		super();
	}

	/**
	loads a json file
	*/
	override public function execute():Void
	{
		loader = new JSONLoader();
		loader.completed.addOnce(completed);
		loader.failed.addOnce(failed);
		loader.load("data/data.json");
	}

	/**
	Converts the raw json object into Todo items
	Dispatches completed signal on completion.

	@param data 	raw json object
	*/
	function completed(data:Dynamic)
	{
		loader.failed.remove(failed);

		var items:Array<Dynamic> = cast data.items;

		for(item in items)
		{
			var todo = new Todo(item.name);
			todo.done = item.done == true;
			list.add(todo);
		}

		signal.completed.dispatch(list);
	}

	/**
	Dispatches failed signal if JSONLoader is unsuccessful
	*/
	function failed(error:LoaderError)
	{
		loader.completed.remove(completed);

		signal.failed.dispatch(Std.string(error));
	}
}