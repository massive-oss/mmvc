package mcore.util;

/**
Utility methods to operate on Iterables.

Has some similarities to Haxe's Lambda class with the following main differences:

a) Favor native Arrays over Haxe based Lists
b) Inline methods where it makes sense for speed.
*/
class Iterables
{
	/**
	Determine if a value is present in an iterable.
	Standard equality is used for comparison.
	*/
	public static inline function contains<T>(iterable:Iterable<T>, value:T):Bool
	{
		return indexOf(iterable, value) != -1;
	}

	/**
	Returns the index of a value in an iterable, or -1 if not found.
	Standard equality is used for comparison.
	*/
	public static function indexOf<T>(iterable:Iterable<T>, value:T):Int
	{
		var i = 0;
		for (member in iterable)
		{
			if (member == value)
				return i;
			i++;
		}
		return -1;
	}

	/**
	Returns the first element of an iterable that satisfies the predicate, or null
	if there is no such element.
	*/
	public static inline function find<T>(iterable:Iterable<T>, predicate:T->Bool):Null<T>
	{
		var item:Null<T> = null;
		for (member in iterable)
		{
			if (predicate(member))
			{
				item = member;
				break;
			}
		}
		return item;
	}

	/**
	Filter an iterable by a predicate and return the matching elements in an array.
	*/
	public static inline function filter<T>(iterable:Iterable<T>, predicate:T -> Bool):Array<T>
	{
		var items:Array<T> = [];
		for (member in iterable)
			if (predicate(member))
				items.push(member);
		return items;
	}

	/**
	Concatenate the elements of two iterables into a single array.
	*/
	public static inline function concat<T>(iterableA:Iterable<T>, iterableB:Iterable<T>):Array<T>
	{
		var items:Array<T> = [];
		for (iterable in [iterableA, iterableB])
			for (item in iterable)
				items.push(item);
		return items;
	}

	/**
	Apply a selector function to each element of an iterable, and return the array of results.
	*/
	public static inline function map<A,B>(iterable:Iterable<A>, selector:A -> B):Array<B>
	{
		var items:Array<B> = [];
		for (item in iterable)
			items.push(selector(item));
		return items;
	}

	/**
	Apply a selector function to each element of an iterable, also passing in the index, and return the array of results.
	*/
	public static inline function mapWithIndex<A,B>(iterable:Iterable<A>, selector:A -> Int -> B):Array<B>
	{
		var items:Array<B> = [];
		for (item in iterable)
			items.push(selector(item, items.length));
		return items;
	}

	/**
	Perform a functional left fold.

	From tail to head, each element of the iterable is passed to the aggregator function along with the
	current aggregate. This should then return the new aggregate.

	@return the final aggregate of the fold
	*/
	public static inline function fold<A,B>(iterable:Iterable<A>, aggregator:A -> B -> B, seed:B):B
	{
		for (member in iterable)
			seed = aggregator(member, seed);
		return seed;
	}

	/**
	Perform a functional right fold.

	From head to tail, each element of the iterable is passed to the aggregator function along with the
	current aggregate. This should then return the new aggregate.

	@return the final aggregate of the fold
	*/
	public static inline function foldRight<A,B>(iterable:Iterable<A>, aggregator:A -> B -> B, seed:B):B
	{
		return fold(reverse(iterable), aggregator, seed);
	}

	/**
	Reverse an iterable's order and return as an array.
	*/
	public static inline function reverse<T>(iterable:Iterable<T>):Array<T>
	{
		var items:Array<T> = [];
		for (member in iterable)
			items.unshift(member);
		return items;
	}

	/**
	Determine if an iterable has any elements.
	*/
	public static inline function isEmpty<T>(iterable:Iterable<T>):Bool
	{
		return !iterable.iterator().hasNext();
	}

	/**
	Convert an iterable to an array.
	*/
	public static inline function toArray<T>(iterable:Iterable<T>):Array<T>
	{
		var result:Array<T> = [];
		for (member in iterable)
			result.push(member);
		return result;
	}

	/**
	Return the number of elements in an iterable.
	*/
	public static inline function size<T>(iterable:Iterable<T>):Int
	{
		var i = 0;
		for (member in iterable)
			i++;
		return i;
	}

	/**
	Count the number of elements in an iterable which fulfill a given predicate.
	*/
	public static inline function count<T>(iterable:Iterable<T>, predicate:T->Bool):Int
	{
		var i = 0;
		for (member in iterable)
			if (predicate(member))
				i++;
		return i;
	}
}
