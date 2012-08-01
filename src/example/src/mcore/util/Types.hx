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
