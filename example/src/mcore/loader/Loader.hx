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

typedef AnyLoader = Loader<Dynamic>;

/**
The Loader class defines an API for loading uri's. The API also defines signals
for progressed, completed and failed requests.
*/

interface Loader<T>
{
	var uri:String;
	var progress(get, null):Float;

	var progressed(default, null):Signal1<Float>;
	var completed(default, null):Signal1<T>;
	var failed(default, null):Signal1<LoaderError>;
	var cancelled(default, null):Signal0;

	function load():Void;
	function cancel():Void;
}

enum LoaderError
{
	IOError(info:String);
	SecurityError(info:String);
	FormatError(info:String);
	DataError(info:String, data:String);
}
