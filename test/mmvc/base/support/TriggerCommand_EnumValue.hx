package mmvc.base.support;

class TriggerCommand_EnumValue extends mmvc.impl.TriggerCommand<EnumValue>
{
	override function execute()
	{
		MockResult.result = trigger;
		MockResult.count++;
	}
}
