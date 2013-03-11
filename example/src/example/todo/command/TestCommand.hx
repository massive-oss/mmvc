package src.example.todo.command;
import mmvc.impl.Command;
import example.todo.model.TestData;

class TestCommand extends Command
{
	public function executeArgs(someType:TestType, testEnum:TestEnum):Void 
	{
		trace(":executeArgs intVal = " + Std.string(someType) + " testEnum = " + testEnum);
	}
}