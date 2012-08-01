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
	var progress(get_progress, null):Float;

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
