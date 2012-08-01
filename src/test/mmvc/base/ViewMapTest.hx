
package mmvc.base;

import massive.munit.Assert;
import minject.Injector;
import minject.Reflector;
import mmvc.base.support.TestView;
import mmvc.base.support.ITestView;
import mmvc.base.support.TestContextView;
import minject.Injector;
import minject.Reflector;
import mmvc.api.IViewMap;
import mmvc.api.IViewContainer;

class ViewMapTest
 {
	public function new(){}
	
	static var INJECTION_NAME = "injectionName";
	static var INJECTION_STRING = "injectionString";
	
	var contextView:TestContextView;
	var testView:TestView;
	var injector:Injector;
	var reflector:Reflector;
	var viewMap:IViewMap;
	
	@Before
	public function before():Void
	{
		contextView = new TestContextView();
		testView = new TestView();
		injector = new Injector();
		reflector = new Reflector();
		viewMap = new ViewMap(contextView, injector);
		
		injector.mapValue(String, INJECTION_STRING, INJECTION_NAME);
	}
	
	@After
	public function after():Void
	{
		contextView = null;
		testView = null;
		injector = null;
		reflector = null;
		viewMap = null;
		injector = null;
	}
	
	@Test
	public function map_type():Void
	{
		viewMap.mapType(TestView);
		var mapped = viewMap.hasType(TestView);
		Assert.isTrue(mapped);
	}
	
	@Test
	public function unmap_type():Void
	{
		viewMap.mapType(TestView);
		viewMap.unmapType(TestView);
		var mapped = viewMap.hasType(TestView);
		Assert.isFalse(mapped);
	}
	
	@Test
	public function map_type_and_add_to_display():Void
	{
		viewMap.mapType(TestView);
		contextView.addView(testView);
		Assert.areEqual(INJECTION_STRING, testView.injectionPoint);
	}
	
	@Test
	public function unmap_type_and_add_to_display():Void
	{
		viewMap.mapType(TestView);
		viewMap.unmapType(TestView);
		contextView.addView(testView);
		Assert.isNull(testView.injectionPoint);
	}
	
	@Test
	public function map_type_and_add_to_display_twice():Void
	{
		viewMap.mapType(TestView);
		contextView.addView(testView);
		testView.injectionPoint = null;
		contextView.removeView(testView);
		contextView.addView(testView);
		Assert.isNull(testView.injectionPoint);
	}
	
	@Test
	public function map_type_of_context_view_should_inject_into_it():Void
	{
		viewMap.mapType(TestContextView);
		Assert.areEqual(INJECTION_STRING, contextView.injectionPoint);
	}
	
	@Test
	public function map_type_of_context_view_twice_should_inject_only_once():Void
	{
		viewMap.mapType(TestContextView);
		contextView.injectionPoint = null;
		viewMap.mapType(TestContextView);
		Assert.isNull(testView.injectionPoint);
	}
	
	@Test
	public function map_package():Void
	{
		viewMap.mapPackage('mmvc');
		var mapped = viewMap.hasPackage('mmvc');
		Assert.isTrue(mapped);
	}
	
	@Test
	public function unmap_package():Void
	{
		viewMap.mapPackage("mmvc");
		viewMap.unmapPackage("mmvc");
		var mapped = viewMap.hasPackage("mmvc");
		Assert.isFalse(mapped);
	}
	
	@Test
	public function mapped_package_is_injected():Void
	{
		viewMap.mapPackage("mmvc");
		contextView.addView(testView);
		Assert.areEqual(INJECTION_STRING, testView.injectionPoint);
	}
	
	@Test
	public function mapped_absolute_package_is_injected():Void
	{
		viewMap.mapPackage("mmvc.base.support");
		contextView.addView(testView);
		Assert.areEqual(INJECTION_STRING, testView.injectionPoint);
	}
	
	@Test
	public function unmapped_package_should_not_be_injected():Void
	{
		viewMap.mapPackage("mmvc");
		viewMap.unmapPackage("mmvc");
		contextView.addView(testView);
		Assert.isNull(testView.injectionPoint);
	}
	
	@Test
	public function mapped_package_not_injected_twice_when_removed_and_added():Void
	{
		viewMap.mapPackage("mmvc");
		contextView.addView(testView);
		testView.injectionPoint = null;
		contextView.removeView(testView);
		contextView.addView(testView);
		
		Assert.isNull(testView.injectionPoint);
	}
	
	@Test
	public function map_interface():Void
	{
		viewMap.mapType(ITestView);
		var mapped = viewMap.hasType(ITestView);
		Assert.isTrue(mapped);
	}
	
	@Test
	public function unmap_interface():Void
	{
		viewMap.mapType(ITestView);
		viewMap.unmapType(ITestView);
		var mapped = viewMap.hasType(ITestView);
		Assert.isFalse(mapped);
	}
	
	@Test
	public function mapped_interface_is_injected():Void
	{
		viewMap.mapType(ITestView);
		contextView.addView(testView);
		Assert.areEqual(INJECTION_STRING, testView.injectionPoint);
	}
	
	@Test
	public function unmapped_interface_should_not_be_injected():Void
	{
		viewMap.mapType(ITestView);
		viewMap.unmapType(ITestView);
		contextView.addView(testView);
		Assert.isNull(testView.injectionPoint);
	}
	
	@Test
	public function mapped_interface_not_injected_twice_when_removed_and_added():Void
	{
		viewMap.mapType(ITestView);
		contextView.addView(testView);
		testView.injectionPoint = null;
		contextView.removeView(testView);
		contextView.addView(testView);
		Assert.isNull(testView.injectionPoint);
	}

	@Test
	public function setting_enabled_does_stuff():Void
	{
		viewMap.enabled = true;
		viewMap.enabled = false;
		viewMap.enabled = true;
		
		viewMap.contextView = contextView;
		viewMap.contextView = null;
		viewMap.contextView = contextView;
		Assert.isTrue(true);
	}
}
