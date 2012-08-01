package mmvc.impl;

import minject.Injector;

/**
Abstract MVCS <code>IActor</code> implementation.

<p>As part of the MVCS implementation the <code>Actor</code> provides core 
functionality to an applications various working parts.</p>
 
<p>Some possible uses for the <code>Actor</code> include, but are no means 
limited to:</p>
 
<ul>
	<li>Service classes</li>
	<li>Model classes</li>
	<li>Controller classes</li>
	<li>Presentation model classes</li>
</ul>
 
<p>Essentially any class where it might be advantagous to have basic dependency 
injection supplied is a candidate for extending <code>Actor</code>.</p>
*/
class Actor
{
	@inject public var injector:Injector;

	public function new():Void {}
}
