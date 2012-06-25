package example.app;

class ApplicationView implements m.mvc.api.IViewContainer
{
	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;


	public function new()
	{
	}

	public function isAdded(view:Dynamic):Bool
	{
		return false;
	}

	public function initialize()
	{
		var todoView = new example.todo.view.TodoListView();
		viewAdded(todoView);
	}
}