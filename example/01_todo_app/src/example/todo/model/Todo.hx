package example.todo.model;

/**
A single todo data object with a name and a done status
*/
class Todo
{
	/**
	Name of the todo item
	*/
	public var name:String;

	/**
	Indicates if todo item is completed
	*/
	public var done:Bool;

	public function new(?name:String)
	{
		if(name == null) name = "New todo";
		this.name = name;
		this.done = false;
	}

	/**
	Serializes the data object as a JSON string 
	*/
	public function toString():String
	{
		return haxe.Json.stringify(this);
	}
}