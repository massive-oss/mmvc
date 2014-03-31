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
	The mmvc MediatorMap contract
**/
interface IMediatorMap
{
	
	/**
		Map an `IMediator` to a view class

		@param viewClassOrName The concrete view class or Fully Qualified classname
		@param mediatorClass The `IMediator` class
		@param injectViewAs The explicit view Interface or class that the mediator depends on *or* 
			an Array of such Interfaces/Classes.
		@param autoCreate Automatically construct and register an instance of class `mediatorClass` 
			when an instance of class `viewClass` is detected
		@param autoRemove Automatically remove an instance of class `mediatorClass` when its 
			`viewClass` leaves the ancestory of the context view
	**/
	function mapView(viewClassOrName:Dynamic, mediatorClass:Class<Dynamic>, 
		?injectViewAs:Dynamic = null, ?autoCreate:Bool = true, ?autoRemove:Bool = true):Void;
	
	/**
		Unmap a view class
		
		@param viewClassOrName The concrete view class or Fully Qualified classname
	**/		
	function unmapView(viewClassOrName:Dynamic):Void;
	
	/**
		Create an instance of a mapped `IMediator`
		
		This will instantiate and register a Mediator for a given View Component. Mediator 
		dependencies will be automatically resolved.
		
		@param viewComponent An instance of the view class previously mapped to an `IMediator` class
		@return The `IMediator`
	**/
	function createMediator(viewComponent:Dynamic):IMediator;
	
	/**
		Manually register an `IMediator` instance
		
		> Registering a Mediator will *not* inject its dependencies. It is assumed that 
		> dependencies are already satisfied.
		
		@param viewComponent The view component for the `IMediator`
		@param mediator The `IMediator` to register
	**/
	function registerMediator(viewComponent:Dynamic, mediator:IMediator):Void;
	
	/**
		Remove a registered `IMediator` instance
		
		@param mediator The `IMediator` to remove
		@return The `IMediator` that was removed
	**/
	function removeMediator(mediator:IMediator):IMediator;
	
	/**
		Remove a registered `IMediator` instance
		
		@param viewComponent The view that the `IMediator` was registered with
		@return The `IMediator` that was removed
	**/
	function removeMediatorByView(viewComponent:Dynamic):IMediator;
	
	/**
		Retrieve a registered `IMediator` instance
		
		@param viewComponent The view that the `IMediator` was registered with
		@return The `IMediator`
	**/
	function retrieveMediator(viewComponent:Dynamic):IMediator;
	
	/**
		Check if the view class has been mapped or not
		
		@param viewClassOrName The concrete view class or Fully Qualified classname
		@return Whether this view class has been mapped
	**/
	function hasMapping(viewClassOrName:Dynamic):Bool;
	
	/**
		Check if the `IMediator` has been registered
		
		@param mediator The `IMediator` instance
		@return Whether this `IMediator` has been registered
	**/
	function hasMediator(mediator:IMediator):Bool;
	
	/**
		Check if an `IMediator` has been registered for a view instance
		
		@param viewComponent The view that the `IMediator` was registered with
		@return Whether an `IMediator` has been registered for this view instance
	**/
	function hasMediatorForView(viewComponent:Dynamic):Bool;
	
	/**
		The `IMediatorMap`'s `IViewContainer`
		
		@return view The `IViewContainer` to use as scope for this `IMediatorMap`
	**/
	var contextView(default, set_contextView):IViewContainer;
	
	/**
		The `IMediatorMap`'s enabled status
		
		@return Whether the `IMediatorMap` is enabled
	**/		
	var enabled(default, set_enabled):Bool;
}
