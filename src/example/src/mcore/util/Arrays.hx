package mcore.util;

class Arrays
{
	/**
	Normalises toString() output between platforms
	For example: ["a", "b", "c"] becomes "a,b,c"
	Note: in neko array.toString includes the '[]' and has space between each value.
	Where as in js/flash it doesnt.

	@param source 	The source array to convert to string;
	@return string in format "a,b,c"
	*/
	public static inline function toString<T>(source:Array<T>):String
	{
		#if neko
			return source.join(",");
		#else
			return source.toString();
		#end
	}
	
	/**
	Returns a copy of the source array, with its elements randomly reordered
	*/
	public static function shuffle<T>(source:Array<T>):Array<T>
	{
		var copy = source.copy();
		var shuffled = [];
		while (copy.length > 0)
			shuffled.push(copy.splice(Std.random(copy.length), 1)[0]);
		return shuffled;
	}

	/**
	Convenience method to get the last item in an array.
	*/
	public static inline function lastItem<T>(source:Array<T>):T
	{
		return source[source.length - 1];
	}
}
