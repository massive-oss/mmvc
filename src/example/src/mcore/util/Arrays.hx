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
