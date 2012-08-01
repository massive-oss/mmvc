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

/**
The collection interface defines an API for working with collections of values. 
The API defines methods for adding, removing and manipulating values in the 
collection.

Creating a concrete instance (e.g. ArrayList, Stack, Set, etc):
<pre>
var collection = new CollectionImpl<Foo>();
</pre>*
Adding and removing values:
<pre>
collection.add(foo1);
collection.addAll([foo1, foo2, foo3]);		
collection.remove(foo1);
collection.clear();
</pre>

Measuring and accessing values:
<pre>
collection.size
collection.contains(foo1);
collection.isEmpty());
</pre>

Iterating through values:
<pre>
for(foo in collection.iterator())
{
	trace(foo.bar);
}
var array = collection.toArray();
</pre>

Observing changes to collection:
<pre>
collection.changed.addOnce(changeHandler);
collection.add(foo2);
...
function changeHandler()
{
	//will execute when collection contents changes
}
</pre>
*
*/
interface Collection<T>
{
	/**
	Dispatched when the values of the collection change.
	*/
	var changed:Signal0;

	/**
	The number of values in this collection.
	*/
	var size(get_size, null):Int;

	/**
	Adds a value to the collection.
	
	@param value		the value to add.
	*/
	function add(value:T):Void;

	/**
	Adds a collection of values to this collection.
	
	@param values		the collection of values to add to this collection.
	*/
	function addAll(values:Iterable<T>):Void;

	/**
	Removes all values in the collection.
	*/
	function clear():Void;

	/**
	Returns true if a value in the collection is equal to the provided value, 
	using standard equality.
	
	@param value		the value to check for.
	@return 	<code>true</code> if value exists in collection.
	*			<code>false</code> otherwise
	*/
	function contains(value:T):Bool;

	/**
	@return <code>true</code> if collection contains no values.
	*		<code>false</code> otherwise
	*/
	function isEmpty():Bool;

	/**
	Directly access an iterator contain the values of the collection
	<pre>
	for(foo in collection.iterator())
	{
		trace(foo.bar);
	}
	</pre>
	
	@return Iterator for the values in the collection.
	*/
	function iterator():Iterator<Null<T>>;

	/**
	Removes a value from the collection if it exists.
	
	@param value The value to remove.
	@return 	<code>true</code> if value was successfully removed
	*			<code>false</code> otherwise
	*/
	function remove(value:T):Bool;

	/**
	Returns a collection containing values for which predicate(value) returns 
	true.
	
	@param predicate The filtering function, taking a collection value as an 
	argument and returning a boolean indicating prescence in the resulting 
	collection.
	@return The filtered collection.
	*/
	function filter(predicate:T -> Bool):Collection<T>;

	/**
	Returns an array of the values in the collection.
	@return An array of values in the collection.
	*/
	function toArray():Array<T>;
}
