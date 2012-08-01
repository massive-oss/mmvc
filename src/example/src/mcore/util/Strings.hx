package mcore.util;

/**
Utility methods for working with strings.
*/
class Strings
{
	/**
	Removes all the HTML markup from a string
	
	@param content 	the string to strip  
	@return the stripped string
	*/
	public static function stripHTML(content:String):String
	{
		var pattern:EReg = ~/<[^>]*>/g;
		return pattern.replace(content, "");
	}

	/**
	Capitalizes a string of words separated by spaces.
	
	@param value 	the string to capitalize
	@return the capitalized string
	*/
	public static function capitalize(value:String):String
	{
		// dp: this function really needs improvement

		var words = value.split(" ");
		for (i in 0...words.length)
		{
			var word = words[i];
			words[i] = word.charAt(0).toUpperCase() + word.substr(1);
		}
		
		return words.join(" ");
	}
	
	
	/**
	Replaces token markers in source string with supplied token values.
	The index of a token value maps to its id in the source string.	

	e.g. StringTools.substitute("Red {0} {1}", ["Green", "Blue"]); // outputs Red Green Blue

	@param source	the string with tokens to be substituted 
	@param values	an array of substitute tokens
	@return a copy of the source string with any substitutions made
	*/
	public static function substitute(source:String, values:Array<Dynamic>):String
	{
		for (i in 0...values.length)
			source = source.split("{" + i + "}").join(values[i]);
		return source;
	}

	/**
	Returns true if the subject string is found within the source string

	@param source the string to search
	@param subject the string to search for in source

	@return true if the subject is found, false if not
	*/
	public static inline function contains(source:String, subject:String):Bool
	{
		return source.indexOf(subject) != -1;
	}
	
	/**
	Convenience method to the get the last character in a string.

	@param source   the string to grab the last character from
	@return the last character in the source string
	*/
	public static inline function lastChar(source:String):String
	{
		return (source == "") ? "" : source.charAt(source.length - 1);
	}
}
