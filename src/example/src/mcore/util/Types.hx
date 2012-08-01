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

/**
Utility methods for working with types.
*/
class Types
{
	/**
	Checks if an object is an instance of, or instance of a subclass of 
	a given type.
	
	@param object 	the instance to check
	@param type 	the type to compare against
	@return true if object is instance of type or subclass else false
	*/
	public static function isSubClassOf(object:Dynamic, type:Dynamic):Bool
	{
		return (Std.is(object, type) && Type.getClass(object) != type);
	}

	/**
	Wraps Type.createInstance to support optional constructor arguments in neko
	
	@param forClass 	the class type to instanciate
	@param args 	optional array of arguments
	@return instance of type
	*/
	public static function createInstance<T>(forClass:Class<T>, ?args:Array<Dynamic>):T
	{
		if (args == null) args = [];

		#if !neko
			try
			{
				return Type.createInstance(forClass, args);
			}
			catch(e:Dynamic)
			{
				throw "Error creating instance of " + Type.getClassName(forClass) + "(" + args.toString() + ")";
			}
			
		#else
			var attempts = 0;
			do
			{
				try
				{
					return Type.createInstance(forClass, args);
				}
				catch(e:Dynamic)
				{
					if(e != "Invalid call")
					{
						throw "Error creating instance of " + Type.getClassName(forClass) + "(" + args.toString() + ")";
					}
				}
			  
				attempts ++;
				args.push(null);
			}
			while (attempts < 10);

			throw "Unable to create instance of " + Type.getClassName(forClass);
			
			return null;
		#end
	}
}
