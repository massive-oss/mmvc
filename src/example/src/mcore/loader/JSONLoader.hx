package mcore.loader;

import mcore.loader.Loader;
using mcore.util.Strings;

/**
The JSONLoader is an extension of the HTTPLoader. It's responsible for loading 
JSON resources and serializing them into objects.

Example

	var loader = new JSONLoader();
	loader.completed.add(completed);
	loader.load("http://some/url/to/load");

	function completed(result:Dynamic)
	{
		trace(result.someValue)
	}
*/
class JSONLoader extends HTTPLoader<Dynamic>
{
	/**
	@param uri  the uri to load the resource from
	@param http optional Http instance to use for the load request
	*/
	public function new(?uri:String, ?http:haxe.Http)
	{
		super(uri, http);
	}

	/**
	override httpData to deserialize JSON string into an object.
	triggers FormatError if invalid JSON. 
	*/
	override function httpData(data:String)
	{
		progressed.dispatch(1);
		
		try
		{
			var json:Dynamic = haxe.Json.parse(data);
			completed.dispatch(json);
		}
		catch (e:Dynamic)
		{
			failed.dispatch(FormatError(Std.string(e)));
			return;
		}
		
		
	}


	/**
	Ensures POST data is valid JSON string
	
	@param uri The URI to load.
	@param data object or JSON string to pass through with the request.
	*/
	override public function send(data:Dynamic)
	{
		if (uri == null)
			throw "No uri defined for Loader";

		try
		{
			if (!Std.is(data, String))
			{
				data = haxe.Json.stringify(data);
			}

			if (!headers.exists("Content-Type"))
			{
				headers.set("Content-Type", "application/json");
			}

			super.send(data);
		}
		catch(e:Dynamic)
		{
			failed.dispatch(FormatError(Std.string(e)));
		}
	}
}
