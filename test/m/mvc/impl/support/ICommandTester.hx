package m.mvc.impl.support;

interface ICommandTester
{
	function resetCommandExecuted():Void;
	function markCommandExecuted():Void;
	function markCommand2Executed(param1:Int, param2:String):Void;
}
