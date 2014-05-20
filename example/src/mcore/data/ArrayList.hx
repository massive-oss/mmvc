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

/**
An ArrayList is a managed collection of values with a similar API to a native 
platform Array. ArrayLists protect against out of range access and can notify 
observers when the values the contain change.
*
Example Usage:
<pre>
var list = new ArrayList<String>();
list.addAll(["foo", "bar", "cat"]);
trace(list.first);//outputs "foo";
trace(list.last);//outputs "cat";
</pre> 

@see mcore.data.Collection
@see mcore.data.CollectionBase
*/
class ArrayList<T> extends CollectionBase<T>
{
	/**
	Creates a new ArrayList containing an optional array of values.
	
	@param values		optional array of values to populate the ArrayList
	*/
	public function new(?values:Iterable<T> = null)
	{
		super();

		if (values != null)
		{
			addAll(values);
		}
	}

	/**
	The first item in the collection.
	*/
	public var first(get, null):T;

	function get_first():T
	{
		if (isEmpty())
			return null;

		return source[0];
	}

	/**
	The last item in the collection.
	*/
	public var last(get, null):T;

	function get_last():T
	{
		if (isEmpty())
			return null;

		return source[size - 1];
	}

	/**
	The number of items in the collection.
	*/
	public var length(get, null):Int;

	function get_length():Int
	{
		return source.length;
	}

	/**
	Inserts a value at a given index in the list.
	
	@param index The index at which to inset the value.
	@param value The value to insert.
	*/
	public function insert(index:Int, value:T):Void
	{
		if (index < 0 || index > size)
		{
			throw "index out of bounds";
		}

		source.insert(index, value);
		notifyChanged();
	}

	/**
	Returns a value at a given index in the list.
	
	@param index The index of the value to return.
	@return The requested value.
	*/
	public function get(index:Int):T
	{
		if (index < 0 || index >= size)
		{
			throw "index out of bounds";
		}

		return source[index];
	}

	/**
	Returns the first index at which value exists in the list, or -1 if it is 
	not found.
	
	@param value The value to index.
	@return The index of the value, or -1 if it is not found.
	*/
	public function indexOf(value:T):Int
	{
		for (i in 0...source.length)
		{
			if (source[i] == value)
			{
				return i;
			}
		}
		
		return -1;
	}

	/**
	Remove the value at a specified index.
	
	@param index The index of the value to remove.
	@return The removed value.
	*/
	public function removeAt(index:Int):T
	{
		if (index < 0 || index >= size)
		{
			throw "index out of bounds";
		}

		var value = source.splice(index, 1)[0];
		notifyChanged();
		return value;
	}
}
