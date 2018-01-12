package mmvc.base.support;

class TriggerCommand_Int extends mmvc.impl.TriggerCommand<Int>
{
	override function execute()
	{
		MockResult.result = trigger;
		MockResult.count++;
	}
}