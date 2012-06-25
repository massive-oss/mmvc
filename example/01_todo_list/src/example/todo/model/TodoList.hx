package example.todo.model;

class TodoList
{
	public var items(default, null):Array<Todo>;
	public var length(get_length, null):Int;

	public function new(?items:Array<Todo>=null)
	{
		if(items == null) items = [];
		this.items = items;
	}

	public function add(todo:Todo)
	{
		items.push(todo);
	}

	public function remove(todo:Todo)
	{
		items.remove(todo);
	}

	public function getRemaining():Int
	{
		var count = 0;
		for(todo in items)
		{
			if(!todo.done) count ++;
		}
		return count;
	}

	function get_length():Int
	{
		return items.length;
	}
}