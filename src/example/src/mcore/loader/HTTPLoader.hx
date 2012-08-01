package mcore.loader;

import mcore.loader.Loader;
import msignal.Signal;
import haxe.Http;

using mcore.util.Strings;

/**
The HTTPLoader class is responsible for loading HTTP requests. The API also
handles the completed and failed signals.
*/

class HTTPLoader<T> extends LoaderBase<T>
{
	/**
	The headers to pass through with the http request.
	*/
	public var headers(default, null):Hash<String>;

	/**
	HTTP status code of response.
	*/
	public var statusCode(default, null):Int;

	var http:Http;

	/**
	@param uri  the uri to load the resource from
	@param http optional Http instance to use for the load request
	*/
	public function new(?uri:String, ?http:Http)
	{
		super(uri);
		
		if (http == null)
			http = new Http("");

		this.http = http;
		
		http.onData = httpData;
		http.onError = httpError;
		http.onStatus = httpStatus;
		headers = new Hash();
	}
	
	/**
	Configures and makes the http request. The load method does not pass 
	through any data with the request.
	*/
	override public function load()
	{
		super.load();

		http.url = uri;
		httpConfigure();
		addHeaders();

		progressed.dispatch(0);
		
		#if nme
		if (uri.indexOf("http:") == 0)
		{
			haxe.Timer.delay(callback(http.request, false), 10);
		}
		else
		{
			var result = nme.installer.Assets.getText("root/" + uri);
			haxe.Timer.delay(callback(httpData, result), 10);
		}
		#elseif neko
		if (uri.indexOf("http:") == 0)
		{
			http.request(false);
		}
		else
		{	
			loadFromFileSystem(uri);
		}
		#else
		try
		{
			http.request(false);
		}
		catch (e:Dynamic)
		{
			// js can throw synchronous security error
			failed.dispatch(SecurityError(Std.string(e)));
		}
		#end
	}

	#if neko

	/**
	Workaround to enable loading relative urls in neko
	*/
	function loadFromFileSystem(uri:String)
	{
		if (!sys.FileSystem.exists(uri))
		{
			failed.dispatch(IOError("Local file does not exist: " + uri));
		}
		else
		{
			var contents = sys.io.File.getContent(uri);
			httpData(contents);
		}
	}
	#end
	
	/**
	Configures and makes the http request. The send method can also pass 
	through data with the request. It also traps any security errors and 
	dispatches a failed signal.
	
	@param uri The URI to load.
	@param data Data to pass through with the request.
	*/
	public function send(data:Dynamic)
	{
		if (uri == null)
			throw "No uri defined for Loader";

		#if debug
			checkListeners();
		#end
		
		if (!headers.exists("Content-Type"))
		{
			var contentType = getMIMEType(data);
			headers.set("Content-Type", contentType);
		}

		http.url = uri;
		http.setPostData(Std.string(data));
		
		httpConfigure();
		addHeaders();

		progressed.dispatch(0);

		try
		{
			http.request(true);
		}
		catch (e:Dynamic)
		{
			// js can throw synchronous security error
			failed.dispatch(SecurityError(Std.string(e)));
		}
		// #end
	}

	/**
	Returns the MIME type for the current data.

	Currently only auto-detects Xml and Json. Defaults to 'application/octet-stream'.

	Note: This can be overwritten by adding a 'Content-Type' to the headers hash
	*/
	function getMIMEType(data:Dynamic):String
	{	
		if (Std.is(data, Xml))
		{
			return "application/xml";
		}
		else if (Std.is(data, String) && data.length > 0 &&
			(data.charAt(0) == "{" && data.charAt(data.length - 1) == "}") ||
			(data.charAt(0) == "[" && data.charAt(data.length - 1) == "]"))
		{
			return "application/json";
		}

		return "application/octet-stream";
	}
	
	/**
	Cancels the http request. Dispatches the cancelled signal when
	called.
	*/
	override public function cancel()
	{
		super.cancel();
		cancelled.dispatch();
	}
	
	function httpConfigure()
	{
	}
	
	function addHeaders()
	{
		for (name in headers.keys())
		{
			http.setHeader(name, headers.get(name));
		}
	}
	
	function httpData(data:String)
	{
		progressed.dispatch(1);
		completed.dispatch(cast data);
	}
	
	function httpStatus(status:Int)
	{
		statusCode = status;
	}
	
	function httpError(error:String)
	{
		failed.dispatch(IOError(error));
	}
}
