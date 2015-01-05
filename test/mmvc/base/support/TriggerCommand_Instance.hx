package mmvc.base.support;

class TriggerCommand_Instance extends mmvc.impl.TriggerCommand<MockClass>
{
	override public function execute()
	{
		MockResult.result = trigger;
		MockResult.count++;
	}
}
