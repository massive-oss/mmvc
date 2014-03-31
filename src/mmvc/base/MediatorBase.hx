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

import mmvc.api.IMediator;
import msignal.Slot;

/**
	An abstract `IMediator` implementation
**/
@:keepSub
class MediatorBase<T> implements IMediator
{
	/**
		This Mediator's View - used by the mmvc framework internally. You should declare a 
		dependency on a concrete view component in your implementation instead of working with 
		this property
	**/
	public var view:T;
	
	/*
		In the case of deffered instantiation, onRemove might get called before 
		`onCreationComplete` has fired. This here Bool helps us track that scenario.
	**/
	var removed:Bool;
	
	/**
		An array of slots to remove when the mediator is removed to ensure garbage collection.
	**/
	var slots:Array<AnySlot>;

	public function new()
	{
		slots = [];
	}
	
	public function preRegister():Void
	{
		removed = false;
		onRegister();
	}
	
	public function onRegister():Void
	{
	}
	
	public function preRemove():Void
	{
		removed = true;
		onRemove();
	}
	
	public function onRemove():Void
	{
		for (slot in slots) slot.remove();
	}
	
	public function getViewComponent():Dynamic
	{
		return view;
	}
	
	public function setViewComponent(viewComponent:Dynamic):Void
	{
		view = viewComponent;
	}

	/**
		Stores reference to any signal listeners, ensuring they are removed during onRemove
		
		```haxe
		mediate(something.completed.add(completed));
		```
	**/
	function mediate(slot:AnySlot)
	{
		slots.push(slot);
	}
}
