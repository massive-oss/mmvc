package mmvc.base.support;

class TriggerCommand_String extends mmvc.impl.TriggerCommand<String>
{
	override function execute()
	{
		MockResult.result = trigger;
		MockResult.count++;
	}
}
