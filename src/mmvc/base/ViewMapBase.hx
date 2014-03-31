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

package mmvc.base;

import minject.Injector;
import mmvc.api.IViewContainer;

/**
	A base ViewMap implementation
**/
class ViewMapBase
{
	public var contextView(default, set_contextView):IViewContainer;
	public var enabled(default, set_enabled):Bool;
	
	/**
		Creates a new `ViewMap` object
		
		@param contextView The root view node of the context
		@param injector An `Injector` to use for this context
	**/
	public function new(contextView:IViewContainer, injector:Injector)
	{
		viewListenerCount = 0;
		enabled = true;

		this.injector = injector;

		// this must come last, see the setter
		this.contextView = contextView;
	}

	public function set_contextView(value:IViewContainer):IViewContainer
	{
		if (value != contextView)
		{
			removeListeners();
			
			contextView = value;

			if (viewListenerCount > 0)
			{
				addListeners();
			}
		}
		
		return contextView;
	}

	public function set_enabled(value:Bool):Bool
	{
		if (value != enabled)
		{
			removeListeners();
			
			enabled = value;
			
			if (viewListenerCount > 0)
			{
				addListeners();
			}
		}

		return value;
	}
	
	var injector:Injector;
	var viewListenerCount:Int;

	function addListeners():Void {}
	function removeListeners():Void {}
	function onViewAdded(view:Dynamic):Void {}
	function onViewRemoved(view:Dynamic):Void {}
}
