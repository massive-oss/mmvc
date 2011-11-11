package m.app.injector.support.injectees;

import m.app.injector.support.types.Interface1;

class RecursiveInterfaceInjectee implements Interface1
{
	@inject
	public var interfaceInjectee:InterfaceInjectee;
	
	public function new(){}
}
