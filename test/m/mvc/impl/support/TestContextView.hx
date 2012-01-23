package m.mvc.impl.support;
	
import m.data.Dictionary;
import m.mvc.api.IViewContainer;

class TestContextView implements IViewContainer
{
	var views:Dictionary<Dynamic, Bool>;

	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;

	@inject("injectionName")
	public var injectionPoint:String;
	
	public function new()
	{
		views = new Dictionary<Dynamic, Bool>();
	}

	public function addView(view:Dynamic)
	{
		views.set(view, true);

		if (viewAdded != null)
		{
			viewAdded(view);
		}
	}

	public function removeView(view:Dynamic)
	{
		views.delete(view);

		if (viewRemoved != null)
		{
			viewRemoved(view);
		}
	}

	public function isAdded(view:Dynamic)
	{
		return views.exists(view);
	}
}
