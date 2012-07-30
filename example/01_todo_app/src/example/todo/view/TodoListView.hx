package example.todo.view;

import example.core.View;
import example.core.DataView;
import example.todo.model.Todo;
import example.todo.model.TodoList;

/**
Main TodoList view containing a list of Todo items

Updates individual todo item state when user clicks on a todo item

@see example.core.DataView
@see example.todo.view.TodoView
@see example.todo.model.TodoList
*/
class TodoListView extends DataView<TodoList>
{
	inline public static var CREATE_TODO = "CREATE_TODO";
	var statsView:TodoStatsView;

	/**
	Overrides constructor to set js tag name to unordered list (ul)

	@param data 	default TodoList
	@see example.core.DataView
	*/
	public function new(?data:TodoList)
	{
		#if js tagName = "ul"; #end
		super(data);
	}

	/**
	Displays an error in the stats view
	*/
	public function showError(message:String)
	{
		statsView.setData(message);
	}

	/**
	Overrides dispatched to handle ACTIONED events from child views.

	@see example.core.DataView
	*/
	override public function dispatch(event:String, view:View)
	{
		switch(event)
		{
			case View.ACTIONED:
			{
				if(Std.is(view, TodoView))
				{
					var todoView = cast view;
					toggleTodoViewState(todoView);	
				}
				else if(Std.is(view, TodoStatsView))
				{
					super.dispatch(CREATE_TODO, this);
				}
			}
			default:
			{
				super.dispatch(event, view);
			}
		}
	}

	/**
	Toggles the done state of a single TodoView

	@param view 	TodoView to toggle done state		
	*/
	function toggleTodoViewState(view:TodoView)
	{
		var data = view.data;
		data.done = !data.done;
		view.setData(data, true);

		updateStats();

	}


	/**
	Overrides initialized to create stats view
	@see example.core.View
	*/
	override function initialize()
	{
		super.initialize();

		statsView = new TodoStatsView();
		addChild(statsView);
	}


	/**
	Overrides dataChanged to add/remove listeners to collection change event

	@see example.core.DataView
	*/
	override function dataChanged()
	{
		super.dataChanged();

		if(this.previousData != null)
			this.previousData.changed.remove(collectionChanged);
		
		if(data != null)
			data.changed.add(collectionChanged);

		collectionChanged();
	}

	/**
	updates child views based on current size of data
	*/
	function collectionChanged()
	{
		updateStats();

		for(child in children.concat([]))
		{
			if(Std.is(child, TodoView))
			{
				removeChild(child);	
			}
		}

		if(data != null)
		{
			for(todo in data)
			{
				var view = new TodoView(todo);
				addChild(view);
			}
		}
	}

	/**
	Updates the stats view based on the number of done Todo items
	*/
	function updateStats()
	{
		if(data == null)
		{
			statsView.setData("No data available");
			return;
		}
		var remaining = data.getRemaining();

		var stats = switch(data.size)
		{
			case 0: "No Todo Items";
			default: remaining + " of " + data.size + " Todo Items complete";
		}

		statsView.setData(stats);	
	}
}

