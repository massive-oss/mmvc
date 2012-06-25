package example.todo.model;

/**
List of Todo items.

@see example.todo.model.Todo
@see m.data.ArrayList
*/

class TodoList extends m.data.ArrayList<Todo>
{
	public function new(?values:Array<Todo>=null)
	{
		super(values);
	}

	/**
	returns number of incomplete items (done == false)
	*/
	public function getRemaining():Int
	{
		var incomplete = this.filter(
		function(todo:Todo)
		{
			return todo.done;
		});

		return incomplete.size;
	}
}