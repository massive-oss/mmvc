/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.app.injector;

import massive.munit.Assert;
import m.app.injector.support.injectees.ClassInjectee;
import m.app.injector.support.injectees.childinjectors.InjectorCopyRule;
import m.app.injector.support.injectees.childinjectors.InjectorInjectee;
import m.app.injector.support.injectees.childinjectors.LeftRobotFoot;
import m.app.injector.support.injectees.childinjectors.RightRobotFoot;
import m.app.injector.support.injectees.childinjectors.RobotAnkle;
import m.app.injector.support.injectees.childinjectors.RobotBody;
import m.app.injector.support.injectees.childinjectors.RobotFoot;
import m.app.injector.support.injectees.childinjectors.RobotLeg;
import m.app.injector.support.injectees.childinjectors.RobotToes;
import m.app.injector.support.types.Class1;

class ChildInjectorTest
 {
	public function new(){}
	
	var injector:Injector;
	
	@Before
	public function runBeforeEachTest():Void
	{
		injector = new Injector();
	}

	@After
	public function teardown():Void
	{
		injector = null;
	}
	
	@Test
	public function injectorCreatesChildInjector():Void
	{
		var childInjector = injector.createChildInjector();
		Assert.isTrue(Std.is(childInjector, Injector));//'injector.createChildInjector should return an injector'
	}
	
	@Test
	public function injectorUsesChildInjectorForSpecifiedRule():Void
	{
		injector.mapClass(RobotFoot, RobotFoot);

		var leftFootRule = injector.mapClass(RobotLeg, RobotLeg, "leftLeg");
		var leftChildInjector = injector.createChildInjector();
		leftChildInjector.mapClass(RobotAnkle, RobotAnkle);
		leftChildInjector.mapClass(RobotFoot, LeftRobotFoot);
		leftFootRule.setInjector(leftChildInjector);
		
		var rightFootRule = injector.mapClass(RobotLeg, RobotLeg, "rightLeg");
		var rightChildInjector = injector.createChildInjector();
		rightChildInjector.mapClass(RobotAnkle, RobotAnkle);
		rightChildInjector.mapClass(RobotFoot, RightRobotFoot);
		rightFootRule.setInjector(rightChildInjector);
		
		var robotBody = injector.instantiate(RobotBody);
		Assert.isTrue(Std.is(robotBody.rightLeg.ankle.foot, RightRobotFoot));//'Right RobotLeg should have a RightRobotFoot'
		Assert.isTrue(Std.is(robotBody.leftLeg.ankle.foot, LeftRobotFoot));//'Left RobotLeg should have a LeftRobotFoot'
	}
	
	@Test
	public function childInjectorUsesParentInjectorForMissingRules():Void
	{
		injector.mapClass(RobotFoot, RobotFoot);
		injector.mapClass(RobotToes, RobotToes);

		var leftFootRule = injector.mapClass(RobotLeg, RobotLeg, "leftLeg");
		var leftChildInjector = injector.createChildInjector();
		leftChildInjector.mapClass(RobotAnkle, RobotAnkle);
		leftChildInjector.mapClass(RobotFoot, LeftRobotFoot);
		leftFootRule.setInjector(leftChildInjector);

		var rightFootRule = injector.mapClass(RobotLeg, RobotLeg, "rightLeg");
		var rightChildInjector = injector.createChildInjector();
		rightChildInjector.mapClass(RobotAnkle, RobotAnkle);
		rightChildInjector.mapClass(RobotFoot, RightRobotFoot);
		rightFootRule.setInjector(rightChildInjector);

		var robotBody = injector.instantiate(RobotBody);

		Assert.isTrue(Std.is(robotBody.rightLeg.ankle.foot.toes, RobotToes));//'Right RobotFoot should have toes'
		Assert.isTrue(Std.is(robotBody.leftLeg.ankle.foot.toes, RobotToes));//'Left Robotfoot should have a toes'
	}
	
	@Test
	public function childInjectorDoesntReturnToParentAfterUsingParentInjectorForMissingRules():Void
	{
		injector.mapClass(RobotAnkle, RobotAnkle);
		injector.mapClass(RobotFoot, RobotFoot);
		injector.mapClass(RobotToes, RobotToes);

		var leftFootRule = injector.mapClass(RobotLeg, RobotLeg, "leftLeg");
		var leftChildInjector = injector.createChildInjector();
		leftChildInjector.mapClass(RobotFoot, LeftRobotFoot);
		leftFootRule.setInjector(leftChildInjector);

		var rightFootRule = injector.mapClass(RobotLeg, RobotLeg, "rightLeg");
		var rightChildInjector = injector.createChildInjector();
		rightChildInjector.mapClass(RobotFoot, RightRobotFoot);
		rightFootRule.setInjector(rightChildInjector);

		var robotBody = injector.instantiate(RobotBody);
		Assert.isTrue(Std.is(robotBody.rightLeg.ankle.foot, RightRobotFoot));//'Right RobotFoot should have RightRobotFoot'
		Assert.isTrue(Std.is(robotBody.leftLeg.ankle.foot, LeftRobotFoot));//'Left RobotFoot should have LeftRobotFoot'
	}
	
	@Test
	public function childInjectorUsesParentsMapOfWorkedInjectees():Void
	{
		var childInjector = injector.createChildInjector();
		
		var class1 = new Class1();
		var class2 = new Class1();

		injector.mapValue(Class1, class1);
		childInjector.mapValue(Class1, class2);

		var injectee = injector.instantiate(ClassInjectee);
		childInjector.injectInto(injectee);
		Assert.areEqual(injectee.property, class1);//'injectee.property isn\' overwritten by second injection through child injector'
	}
	
    @Test
    public function childInjectorHasMappingWhenExistsOnParentInjector():Void
    {
        var childInjector = injector.createChildInjector();
        var class1 = new Class1();
        injector.mapValue(Class1, class1);  
        
        Assert.isTrue(childInjector.hasMapping(Class1));//'Child injector should return true for hasMapping that exists on parent injector'
    }
    
    @Test
    public function childInjectorDoesNotHaveMappingWhenDoesNotExistOnParentInjector():Void
    {
        var childInjector = injector.createChildInjector();
        Assert.isFalse(childInjector.hasMapping(Class1));//'Child injector should not return true for hasMapping that does not exists on parent injector'
    }
    
    @Test
    public function grandChildInjectorSuppliesInjectionFromAncestor():Void
    {
        var injectee = new ClassInjectee();
        var childInjector = injector.createChildInjector();
        var grandChildInjector = childInjector.createChildInjector();

        injector.mapSingleton(Class1);
        grandChildInjector.injectInto(injectee);
        
        Assert.isTrue(Std.is(injectee.property, Class1));//"injectee has been injected with Class1 instance from grandChildInjector"
    }
	
	@Test
	public function injectorCanCreateChildInjectorDuringInjection():Void
	{
		injector.mapRule(Injector, new InjectorCopyRule());
		injector.mapClass(InjectorInjectee, InjectorInjectee);
		var injectee = injector.getInstance(InjectorInjectee);

		Assert.isNotNull(injectee.injector);//'Injection has been applied to injectorInjectee'
		Assert.isTrue(injectee.injector.parentInjector == injector);//'injectorInjectee.injector is child of main injector'
		Assert.isTrue(injectee.nestedInjectee.nestedInjectee.injector.parentInjector.parentInjector.parentInjector == injector);//'injectorInjectee.nestedInjectee is grandchild of main injector'
	}
}
