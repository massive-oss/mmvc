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

package mcore.data;

import msignal.Signal;
import mcore.util.Iterables;
import mcore.util.Arrays;
import mcore.util.Types;

/**
A base collection implementation.
*
@see mcore.data.Collection
*/
class CollectionBase<T> implements Collection<T>
{
	/**
	Dispatched when the values of the collection change.
	*/
	public var changed:Signal0;

	/**
	The number of values in this collection.
	*/
	public var size(get_size, null):Int;
	function get_size():Int { return source.length; }

	var source:Array<T>;

	function new()
	{
		source = [];
		changed = new Signal0();
	}

	/**
	Adds a value to the collection.
	
	@param value The value to add.
	*/
	public function add(value:T)
	{
		source.push(value);
		notifyChanged();
	}

	function notifyChanged()
	{
		changed.dispatch();
	}

	/**
	Adds a collection of values to this collection.

	@param values		the collection of values to add to this collection.
	*/
	public function addAll(values:Iterable<T>)
	{
		if (values == null) return;

		var s = source.length;
		for (value in values)
		{
			source.push(value);
		}

		if (source.length != s)
			notifyChanged();
	}

	/**
	Removes all values in the colleciton.
	*/
	public function clear()
	{
		if (isEmpty()) return;
		
		source.splice(0, source.length);
		notifyChanged();
	}
	
	/**
	Returns true if a value in the collection is equal to the provided value, 
	using standard equality.
	
	@param value The value to check for.
	@return A boolean indicating the existence of the value in the collection.
	*/
	public function contains(value:T):Bool
	{
		return Iterables.contains(source, value);
	}

	/**
	@return A boolean indicating the abscence of values in the collection.
	*/
	public function isEmpty():Bool
	{
		return source.length == 0;
	}

	/**
	@return An iterator for the values in the collection.
	*/
	public function iterator():Iterator<Null<T>>
	{
		return source.iterator();
	}

	/**
	Removes a value from the collection if it exists.
	
	@param value The value to remove.
	@return A boolean indicating whether the value was removed.
	*/
	public function remove(value:T):Bool
	{
		var hasChanged = false;
		var i = source.length;
		while (i-- > 0)
		{
			if (source[i] == value)
			{
				source.splice(0, 1);
				hasChanged = true;
			}
		}
		if (hasChanged)
			notifyChanged();

		return hasChanged;
	}

	/**
	Returns a collection containing values for which predicate(value) returns 
	true.
	
	@param predicate The filtering function, taking a collection value as an 
	argument and returning a boolean indicating prescence in the resulting 
	collection.
	@return The filtered collection.
	*/
	public function filter(predicate:T -> Bool):Collection<T>
	{
		var collectionType = Type.getClass(this);
		var collection:Collection<T> = Types.createInstance(collectionType, []);
		var filteredValues:Array<T> = Iterables.filter(source, predicate);

		collection.addAll(filteredValues);
		return collection;
	}

	/**
	Returns an array of the values in the collection.
	
	@return An array of values in the collection.
	*/
	public function toArray():Array<T>
	{
		return source.copy();
	}

	/**
	Returns a string representation of the collection.
	
	@return A String representation of the collection.
	*/
	public function toString():String
	{
		return Arrays.toString(source);
	}
}
