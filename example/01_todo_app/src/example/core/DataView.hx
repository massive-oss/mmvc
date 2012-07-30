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
