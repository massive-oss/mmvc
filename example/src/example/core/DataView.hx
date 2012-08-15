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

package example.core;

/**
A Typed data view using Haxe generics.
Provides a simple contract for typed data property and associated events
*/
class DataView<T> extends View
{
	/**
	Event type dispatched when data is modified
	@see DataView.setData()
	*/
	inline public static var DATA_CHANGED:String = "dataChanged";

	/**
	Typed data property
	*/
	public var data(default, null):T;


	/**
	Reference to previous data object
	*/
	var previousData(default, null):T;

	/**
	Optionally set a data property during construction
	*/
	public function new(?data:T)
	{
		super();
		setData(data);
	}

	/**
	Sets the data property and triggers a DATA_CHANGED event
	@param data 	data to set
	@param force 	forces change even if data object is identical
	*/
	public function setData(data:T, ?force:Bool=false)
	{
		if(this.data != data || force == true)
		{
			
			previousData = this.data;

			this.data = data;

			dataChanged();
			update();
			dispatch(DATA_CHANGED, this);
		}
	}

	/**
	Updates instance specific properties and state when data changes
	*/
	function dataChanged()
	{
		
	}
}
