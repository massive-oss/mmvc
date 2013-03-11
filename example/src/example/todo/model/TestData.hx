package example.todo.model;

/**
 * ...
 * @author av
 */

enum TestEnum 
{
	One;
	SomeString(string:String);
	OtherValue(int:Int);
}

typedef TestType = 
{
	var name:String;
	var age:Int;
}