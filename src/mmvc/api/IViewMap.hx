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

package mmvc.api;

import mmvc.api.IViewContainer;

/**
	The mmvc ViewMap contract. All IViewMap automatic injections occur AFTER 
	the view components are added to the stage.
**/
interface IViewMap
{
	/**
		Map an entire package (including sub-packages) for automatic injection
		
		@param packageName The substring to compare
	**/
	function mapPackage(packageName:String):Void;
	
	/**
		Unmap a package
		
		@param packageName The substring to compare
	**/		
	function unmapPackage(packageName:String):Void;
	
	/**
		Check if a package has been registered for automatic injection
		
		@param packageName The substring to compare
		@return Whether a package has been registered for automatic injection
	**/
	function hasPackage(packageName:String):Bool;
	
	/**
		Map a view component class or interface for automatic injection
		
		@param type The concrete view Interface
	**/
	function mapType(type:Class<Dynamic>):Void;
	
	/**
		Unmap a view component class or interface
		
		@param type The concrete view Interface
	**/
	function unmapType(type:Class<Dynamic>):Void;
	
	/**
		Check if a class or interface has been registered for automatic injection
		
		@param type The concrete view interface 
		@return Whether an interface has been registered for automatic injection
	**/
	function hasType(type:Class<Dynamic>):Bool;
	
	/**
		The `IViewMap`'s `IViewContainer`
		
		@return view The `IViewContainer` to use as scope for this `IViewMap`
	**/
	var contextView(default, set_contextView):IViewContainer;
	
	/**
		The `IViewMap`'s enabled status
		
		@return Whether the `IViewMap` is enabled
	**/
	var enabled(default, set_enabled):Bool;
}
