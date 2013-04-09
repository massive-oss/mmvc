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

package mmvc.impl.support;

import minject.Injector;
import mmvc.api.IViewContainer;
import mmvc.impl.Context;

class TestContext extends Context
{
	public var isInitialized(get_isInitialized, null):Bool;
	public var startupComplete:Bool ;
	
	public function new(?contextView:IViewContainer=null, ?autoStartup:Bool=true)
	{
		startupComplete = false;
		super(contextView, autoStartup);
	}
	
	public override function startup():Void
	{
		startupComplete = true;
		super.startup();
	}
	
	public function getInjector():Injector
	{
		return this.injector;
	}
	
	public function get_isInitialized():Bool
	{
		var initialized:Bool = true;
		initialized = (commandMap != null && initialized);
		initialized = (mediatorMap != null && initialized);
		return initialized;
	}
}
