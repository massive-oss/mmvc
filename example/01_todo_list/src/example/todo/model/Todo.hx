package example.todo.model;

class Todo
{
	public var name:String;
	public var done:Bool;

	public function new(name:String)
	{
		this.name = name;
		this.done = false;
	}

	public function toString():String
	{
		return haxe.Json.stringify(this);
	}
}