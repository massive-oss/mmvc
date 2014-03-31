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
**/

package mmvc.api;

/**
	The mmvc Mediator contract
**/
interface IMediator
{
	/**
		Should be invoked by the `IMediatorMap` during `IMediator` registration
	**/
	function preRegister():Void;
	
	/**
		Should be invoked by the `IMediator` itself when it is ready to be interacted with.

		Override and place your initialization code here.
	**/
	function onRegister():Void;
	
	/**
		Invoked when the `IMediator` has been removed by the `IMediatorMap`.
	**/
	function preRemove():Void;
	
	/**
		Should be invoked by the `IMediator` itself when it is ready to for cleanup.
		
		Override and place your cleanup code here.
	**/
	function onRemove():Void;
	
	/**
		The `IMediator`'s view component
		
		@return The view component
	**/
	function getViewComponent():Dynamic;
	
	/**
		The `IMediator`'s view component
		
		@param The view component
	**/
	function setViewComponent(viewComponent:Dynamic):Void;
}
