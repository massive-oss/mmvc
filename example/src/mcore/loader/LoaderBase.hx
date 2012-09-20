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

package mcore.loader;

import msignal.Signal;
import mcore.loader.Loader;

/**
The LoaderBase class is an abstract implementation of the Loader class.  
*/

class LoaderBase<T> implements Loader<T>
{
	/**
	The uri to load the resource from.
	*/
	public var uri:String;

	/**
	
	*/
	public var asset(default, null):T;

	/**
	The percentage of loading complete. Between 0 and 1.
	*/
	public var progress(get_progress, null):Float;
	function get_progress() { return 0; }

	/**
	A signal indicating a request has progressed
	*/
	public var progressed(default, null):Signal1<Float>;

	/**
	A signal indicating a request is completed
	*/
	public var completed(default, null):Signal1<T>;

	/**
	A signal indicating a request has failed
	*/
	public var failed(default, null):Signal1<LoaderError>;

	/**
	A signal indicating a request has been cancelled
	*/
	public var cancelled(default, null):Signal0;

	/**
	@param uri  the uri to load the resource from
	*/
	public function new(?uri:String)
	{
		this.uri = uri;

		progressed = new Signal1<Float>(Float);
		completed = new Signal1<T>(null);
		failed = new Signal1<LoaderError>(LoaderError);
		cancelled = new Signal0();
	}

	/**
	Called when the loader should begin the loading of a resource from the defined uri.

	Concrete instances should override this method to initiate their loading process.
	*/
	public function load():Void
	{
		if (uri == null)
			throw "No uri defined for Loader";

		#if debug
		checkListeners();
		#end
	}

	/**
	Called when the loader should cancel its request to load a resource.
	*/
	public function cancel():Void
	{
	}

	#if debug
	@:IgnoreCover
	function checkListeners()
	{
		var className = Type.getClassName(Type.getClass(this));
		if(completed.numListeners == 0) Console.warn("No completed listeners for " + className);
		if(failed.numListeners == 0) Console.warn("No failed listeners for " + className);
	}
	#end
}
