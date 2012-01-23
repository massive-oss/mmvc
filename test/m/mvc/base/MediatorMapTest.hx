
package m.mvc.base;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import m.inject.IInjector;
import m.inject.Injector;
import m.inject.Reflector;
import m.mvc.api.IMediator;
import m.mvc.api.IMediatorMap;
import m.mvc.api.IViewContainer;
import m.mvc.base.ContextError;
import m.inject.IReflector;
import m.mvc.impl.support.TestContextView;
import m.mvc.impl.support.TestContextViewMediator;
import m.mvc.impl.support.ViewComponent;
import m.mvc.impl.support.ViewComponentAdvanced;
import m.mvc.impl.support.ViewMediator;
import m.mvc.impl.support.ViewMediatorAdvanced;

class MediatorMapTest
 {
	public function new(){}
	
	var contextView:TestContextView;
	var commandExecuted:Bool;
	var mediatorMap:MediatorMap;
	var injector:IInjector;
	var reflector:IReflector;
	
	@Before
	public function before():Void
	{
		contextView = new TestContextView();
		injector = new Injector();
		reflector = new Reflector();
		mediatorMap = new MediatorMap(contextView, injector, reflector);
		
		injector.mapValue(IViewContainer, contextView);
		injector.mapValue(IInjector, injector);
		injector.mapValue(IMediatorMap, mediatorMap);
	}
	
	@After
	public function after():Void
	{
		injector.unmap(IMediatorMap);
	}
	
	@Test
	public function mediator_is_mappedAnd_created_for_view():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		
		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var mediator = mediatorMap.createMediator(viewComponent);
		var hasMapping = mediatorMap.hasMapping(ViewComponent);
		
		Assert.isTrue(hasMapping);
		Assert.isNotNull(mediator);
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));
	}
	
	@Test
	public function mediator_is_mapped_and_created_with_inject_view_as_class():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, ViewComponent, false, false);
		
		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		var exactMediator:ViewMediator = cast( mediator, ViewMediator);

		Assert.isNotNull(mediator);
		Assert.isType(mediator, ViewMediator);
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));
		Assert.isNotNull(exactMediator.view);
		Assert.isType(exactMediator.view, ViewComponent);
	}
	
	@Test
	public function mediator_is_mapped_and_created_with_inject_view_as_array_of_same_class():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, [ViewComponent], false, false);

		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		var exactMediator:ViewMediator = cast( mediator, ViewMediator);
		
		Assert.isNotNull(mediator);
		Assert.isType(mediator, ViewMediator);
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));
		Assert.isNotNull(exactMediator.view);
		Assert.isType(exactMediator.view, ViewComponent);
	}
	
	@Test
	public function mediator_is_mapped_and_created_with_inject_view_as_array_of_related_class():Void
	{
		mediatorMap.mapView(ViewComponentAdvanced, ViewMediatorAdvanced, [ViewComponent, ViewComponentAdvanced], false, false);
		
		var viewComponentAdvanced:ViewComponentAdvanced = new ViewComponentAdvanced();
		contextView.addView(viewComponentAdvanced);

		var mediator:IMediator = mediatorMap.createMediator(viewComponentAdvanced);
		var exactMediator:ViewMediatorAdvanced = cast( mediator, ViewMediatorAdvanced);

		Assert.isNotNull(mediator);
		Assert.isType(mediator, ViewMediatorAdvanced);
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponentAdvanced));
		Assert.isNotNull(exactMediator.view);
		Assert.isNotNull(exactMediator.viewAdvanced);
		Assert.isType(exactMediator.view, ViewComponent);
		Assert.isType(exactMediator.viewAdvanced, ViewComponentAdvanced);
	}
	
	@Test
	public function mediator_is_mapped_added_and_removed():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		contextView.addView(viewComponent);

		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		
		Assert.isNotNull(mediator);
		Assert.isTrue(mediatorMap.hasMediator(mediator));
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));
		
		mediatorMap.removeMediator(mediator);
		
		Assert.isFalse(mediatorMap.hasMediator(mediator));
		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));
	}
	
	@Test
	public function mediator_is_mapped_added_and_removed_by_view():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		contextView.addView(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);

		Assert.isNotNull(mediator);
		Assert.isTrue(mediatorMap.hasMediator(mediator));
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));
		
		mediatorMap.removeMediatorByView(viewComponent);
		
		Assert.isFalse(mediatorMap.hasMediator(mediator));
		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));
	}
	
	@Test
	public function auto_register():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));
	}
	
	@Test
	public function mediator_is_kept_during_reparenting_preconditions():Void
	{
		var viewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		contextView.addView(viewComponent);
		
		var mediator = mediatorMap.createMediator(viewComponent);
		
		Assert.isNotNull(mediator);
		Assert.isTrue(mediatorMap.hasMediator(mediator));
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));
	}

	// @AsyncTest
	// public function mediatorIsKeptDuringReparenting(factory:AsyncFactory):Void
	// {
	// 	var viewComponent = new ViewComponent();
		
	// 	mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
	// 	contextView.addView(viewComponent);
		
	// 	var mediator = mediatorMap.createMediator(viewComponent);
		
	// 	contextView.removeView(viewComponent);
	// 	contextView.addView(viewComponent);
		
	// 	var data = {view:viewComponent, mediator: mediator};
	// 	var handler = factory.createHandler(this, callback(verifyMediatorSurvival, data), 300);
	// 	haxe.Timer.delay(handler, 200);
	// }
	
	// function verifyMediatorSurvival(data:Dynamic):Void
	// {
	// 	var viewComponent:ViewComponent = data.view;
	// 	var mediator:IMediator = data.mediator;

	// 	Assert.isTrue(mediatorMap.hasMediator(mediator));//"Mediator should exist"
	// 	Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//"View Mediator should exist"
	// }
	
	public function mediator_is_removed_with_view_preconditions():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		var mediator:IMediator;
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		contextView.addView(viewComponent);
		mediator = mediatorMap.createMediator(viewComponent);

		Assert.isNotNull(mediator);
		Assert.isTrue(mediatorMap.hasMediator(mediator));
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));
	}

	@AsyncTest
	public function mediator_is_removed_with_view(factory:AsyncFactory):Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		var mediator:IMediator;
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		contextView.addView(viewComponent);
		mediator = mediatorMap.createMediator(viewComponent);
		
		contextView.removeView(viewComponent);
		
		var data = {view: viewComponent, mediator: mediator};
		var handler = factory.createHandler(this, callback(verifyMediatorRemoval, data), 300);
		haxe.Timer.delay(handler, 200);
	}
	
	function verifyMediatorRemoval(data:Dynamic):Void
	{
		var viewComponent:ViewComponent = data.view;
		var mediator:IMediator = data.mediator;

		Assert.isFalse(mediatorMap.hasMediator(mediator));
		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));
	}
	
	@Test
	public function context_view_mediator_is_created_when_mapped():Void
	{
		mediatorMap.mapView( TestContextView, TestContextViewMediator );
		Assert.isTrue(mediatorMap.hasMediatorForView(contextView));
	}
	
	@Test
	public function context_view_mediator_is_not_created_when_mapped_and_auto_create_is_false():Void
	{
		mediatorMap.mapView( TestContextView, TestContextViewMediator, null, false );
		Assert.isFalse(mediatorMap.hasMediatorForView(contextView));
	}
	
	@Test
	public function unmap_view():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator);
		mediatorMap.unmapView(ViewComponent);

		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var hasMediator = mediatorMap.hasMediatorForView(viewComponent);
		var hasMapping = mediatorMap.hasMapping(ViewComponent);

		Assert.isFalse(hasMediator);
		Assert.isFalse(hasMapping);
	}
	
	@Test
	public function auto_register_unregister_register():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		mediatorMap.unmapView(ViewComponent);

		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);

		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));
		contextView.removeView(viewComponent);
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		contextView.addView(viewComponent);

		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));
	}

	@Test
	public function map_same_view_twice_throws_error()
	{
		mediatorMap.mapView(ViewComponent, ViewMediator);
		var passed = false;

		try
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);
		}
		catch (e:ContextError)
		{
			passed = true;
		}

		Assert.isTrue(passed);
	}
}
