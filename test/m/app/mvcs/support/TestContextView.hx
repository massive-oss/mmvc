/*
* Copyright (c) 2009 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/
package m.app.mvcs.support;
	
import m.app.util.Dictionary;
import m.app.core.IViewContainer;

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
		views.add(view, true);

		if (viewAdded != null)
		{
			viewAdded(view);
		}
	}

	public function removeView(view:Dynamic)
	{
		views.remove(view);

		if (viewRemoved != null)
		{
			viewRemoved(view);
		}
	}

	public function isAdded(view:Dynamic)
	{
		return (views.get(view) == true);
	}
}
