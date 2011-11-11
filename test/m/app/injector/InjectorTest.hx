package m.app.injector;

import massive.munit.Assert;
import m.app.injector.support.injectees.ClassInjectee;
import m.app.injector.support.injectees.InterfaceInjectee;
import m.app.injector.support.injectees.NamedClassInjectee;
import m.app.injector.support.injectees.NamedInterfaceInjectee;
import m.app.injector.support.injectees.StringInjectee;
import m.app.injector.support.injectees.RecursiveInterfaceInjectee;
import m.app.injector.support.injectees.MultipleSingletonsOfSameClassInjectee;
import m.app.injector.support.injectees.ComplexClassInjectee;
import m.app.injector.support.injectees.TwoNamedInterfaceFieldsInjectee;
import m.app.injector.support.injectees.OneParameterMethodInjectee;
import m.app.injector.support.injectees.OneNamedParameterMethodInjectee;
import m.app.injector.support.injectees.TwoParametersMethodInjectee;
import m.app.injector.support.injectees.TwoNamedParametersMethodInjectee;
import m.app.injector.support.injectees.MixedParametersMethodInjectee;
import m.app.injector.support.injectees.OneParameterConstructorInjectee;
import m.app.injector.support.injectees.TwoParametersConstructorInjectee;
import m.app.injector.support.injectees.OneNamedParameterConstructorInjectee;
import m.app.injector.support.injectees.TwoNamedParametersConstructorInjectee;
import m.app.injector.support.injectees.MixedParametersConstructorInjectee;
import m.app.injector.support.injectees.NamedArrayInjectee;
import m.app.injector.support.injectees.MultipleNamedSingletonsOfSameClassInjectee;
import m.app.injector.support.injectees.XMLInjectee;
import m.app.injector.support.injectees.OrderedPostConstructInjectee;
import m.app.injector.support.types.Class1;
import m.app.injector.support.types.Class2;
import m.app.injector.support.types.Interface1;
import m.app.injector.support.types.Interface2;
import m.app.injector.support.types.ComplexClass;
import m.app.injector.support.injectees.SetterInjectee;

class InjectorTest
 {
	public function new(){}
	
	var injector:Injector;
	
	@Before
	public function setup():Void
	{
		injector = new Injector();
	}

	@After
	public function tearDown():Void
	{
		injector = null;
	}
	
	@Test
	public function unbind()
	{
		var injectee = new ClassInjectee();
		var value = new Class1();

		injector.mapValue(Class1, value);
		injector.unmap(Class1);

		try
		{
			injector.injectInto(injectee);
		}
		catch(e:Dynamic)
		{
		}

		Assert.areEqual(null, injectee.property);//"Property should not be injected"
	}

	@Test
	public function injectorInjectsBoundValueIntoAllInjectees():Void
	{
		var value = new Class1();
		injector.mapValue(Class1, value);

		var injectee1 = new ClassInjectee();
		injector.injectInto(injectee1);

		var injectee2 = new ClassInjectee();
		injector.injectInto(injectee2);

		Assert.areEqual(value, injectee1.property); //"Value should have been injected"
		Assert.areEqual(injectee1.property, injectee2.property); //"Injected values should be equal"
	}
	
	@Test
	public function bindValueByInterface():Void
	{
		var injectee = new InterfaceInjectee();
		var value = new Class1();

		injector.mapValue(Interface1, value);
		injector.injectInto(injectee);
		Assert.areEqual(value, injectee.property);//"Value should have been injected"
	}
	
	@Test
	public function bindNamedValue():Void
	{
		var injectee = new NamedClassInjectee();
		var value = new Class1();

		injector.mapValue(Class1, value, NamedClassInjectee.NAME);
		injector.injectInto(injectee);
		Assert.areEqual(value, injectee.property);//"Named value should have been injected"
	}
	
	@Test
	public function bindNamedValueByInterface():Void
	{
		var injectee = new NamedInterfaceInjectee();
		var value = new Class1();

		injector.mapValue(Interface1, value, NamedClassInjectee.NAME);
		injector.injectInto(injectee);
		Assert.areEqual(value, injectee.property);//"Named value should have been injected"
	}
	
	@Test
	public function bindFalsyValue():Void
	{
		var injectee = new StringInjectee();
		var value = "test";

		injector.mapValue(String, value);
		injector.injectInto(injectee);

		Assert.areEqual(value, injectee.property);//"Value should have been injected"
	}
	
	@Test
	public function boundValueIsNotInjectedInto():Void
	{
		var injectee = new RecursiveInterfaceInjectee();
		var value = new InterfaceInjectee();

		injector.mapValue(InterfaceInjectee, value);
		injector.injectInto(injectee);
		
		Assert.isNull(value.property);//"value shouldn't have been injected into"
	}
	
	@Test
	public function bindMultipleInterfacesToOneSingletonClass():Void
	{
		var injectee = new MultipleSingletonsOfSameClassInjectee();
		
		injector.mapSingletonOf(Interface1, Class1);
		injector.mapSingletonOf(Interface2, Class1);

		injector.injectInto(injectee);
		Assert.isNotNull(injectee.property1);//"Singleton Value for 'property1' should have been injected"

		Assert.isNotNull(injectee.property2);//"Singleton Value for 'property2' should have been injected"

		// in haxe you can't compare types which the compiler knows cannot be the same
		var same = untyped (injectee.property1 == injectee.property2);
		Assert.isFalse(same);//"Singleton Values 'property1' and 'property2' should not be identical"
	}
	
	@Test
	public function bindClass():Void
	{
		injector.mapClass(Class1, Class1);

		var injectee1 = new ClassInjectee();
		injector.injectInto(injectee1);

		var injectee2 = new ClassInjectee();
		injector.injectInto(injectee2);

		Assert.isNotNull(injectee1.property); //"Instance of Class should have been injected"
		Assert.isFalse(injectee1.property == injectee2.property); //"Injected values should be different"
	}
	
	@Test
	public function boundClassIsInjectedInto():Void
	{
		var injectee = new ComplexClassInjectee();
		var value = new Class1();

		injector.mapValue(Class1, value);
		injector.mapClass(ComplexClass, ComplexClass);
		injector.injectInto(injectee);

		Assert.isNotNull(injectee.property);//"Complex Value should have been injected"
		Assert.areEqual(value, injectee.property.value);//"Nested value should have been injected"
	}
	
	@Test
	public function bindClassByInterface():Void
	{
		var injectee = new InterfaceInjectee();
		injector.mapClass(Interface1, Class1);
		injector.injectInto(injectee);
		Assert.isNotNull(injectee.property);//"Instance of Class should have been injected"
	}
	
	@Test
	public function bindNamedClass():Void
	{
		var injectee:NamedClassInjectee = new NamedClassInjectee();
		injector.mapClass(Class1, Class1, NamedClassInjectee.NAME);
		injector.injectInto(injectee);
		Assert.isNotNull(injectee.property);//"Instance of named Class should have been injected"
	}
	
	@Test
	public function bindNamedClassByInterface():Void
	{
		var injectee = new NamedInterfaceInjectee();
		injector.mapClass(Interface1, Class1, NamedClassInjectee.NAME);
		injector.injectInto(injectee);
		Assert.isNotNull(injectee.property);//"Instance of named Class should have been injected"
	}
	
	@Test
	public function bindSingleton():Void
	{
		var injectee1:ClassInjectee = new ClassInjectee();
		var injectee2:ClassInjectee = new ClassInjectee();

		injector.mapSingleton(Class1);

		injector.injectInto(injectee1);
		Assert.isNotNull(injectee1.property);//"Instance of Class should have been injected"
		
		injector.injectInto(injectee2);
		Assert.areEqual(injectee1.property, injectee2.property);//"Injected values should be equal"
	}
	
	@Test
	public function bindSingletonOf():Void
	{
		var injectee1 = new InterfaceInjectee();
		var injectee2 = new InterfaceInjectee();

		injector.mapSingletonOf(Interface1, Class1);

		injector.injectInto(injectee1);
		Assert.isNotNull(injectee1.property);//"Instance of Class should have been injected"

		injector.injectInto(injectee2);
		Assert.areEqual(injectee1.property, injectee2.property);//"Injected values should be equal"
	}
	
	@Test
	public function bindDifferentlyNamedSingletonsBySameInterface():Void
	{
		var injectee = new TwoNamedInterfaceFieldsInjectee();
		
		injector.mapSingletonOf(Interface1, Class1, TwoNamedInterfaceFieldsInjectee.NAME1);
		injector.mapSingletonOf(Interface1, Class2, TwoNamedInterfaceFieldsInjectee.NAME2);
		
		injector.injectInto(injectee);
		
		Assert.isTrue(Std.is(injectee.property1, Class1));//'Property "property1" should be of type "Class1"'
		Assert.isTrue(Std.is(injectee.property2, Class2));//'Property "property2" should be of type "Class2"'
		Assert.isFalse(injectee.property1 == injectee.property2);//'Properties "property1" and "property2" should have received different singletons'
	}
	
	@Test
	public function performSetterInjection():Void
	{
		var injectee1:SetterInjectee = new SetterInjectee();
		var injectee2:SetterInjectee = new SetterInjectee();

		injector.mapClass(Class1, Class1);

		injector.injectInto(injectee1);
		Assert.isNotNull(injectee1.property);//"Instance of Class should have been injected"
		
		injector.injectInto(injectee2);
		Assert.isFalse(injectee1.property == injectee2.property);//"Injected values should be different"
	}
	
	@Test
	public function performMethodInjectionWithOneParameter():Void
	{
		var injectee1 = new OneParameterMethodInjectee();
		var injectee2 = new OneParameterMethodInjectee();

		injector.mapClass(Class1, Class1);
		
		injector.injectInto(injectee1);
		Assert.isNotNull(injectee1.getDependency());//"Instance of Class should have been injected"

		injector.injectInto(injectee2);
		Assert.isFalse(injectee1.getDependency() == injectee2.getDependency());//"Injected values should be different"
	}
	
	@Test
	public function performMethodInjectionWithOneNamedParameter():Void
	{
		var injectee1 = new OneNamedParameterMethodInjectee();
		var injectee2 = new OneNamedParameterMethodInjectee();

		injector.mapClass(Class1, Class1, OneNamedParameterMethodInjectee.NAME);
		
		injector.injectInto(injectee1);
		Assert.isNotNull(injectee1.getDependency());//"Instance of Class should have been injected for named Class1 parameter"

		injector.injectInto(injectee2);
		Assert.isFalse(injectee1.getDependency() == injectee2.getDependency());//"Injected values should be different"
	}
	
	@Test
	public function performMethodInjectionWithTwoParameters():Void
	{
		var injectee1 = new TwoParametersMethodInjectee();
		var injectee2 = new TwoParametersMethodInjectee();

		injector.mapClass(Class1, Class1);
		injector.mapClass(Interface1, Class1);

		injector.injectInto(injectee1);
		Assert.isNotNull(injectee1.getDependency1());//"Instance of Class should have been injected for unnamed Class1 parameter"
		Assert.isNotNull(injectee1.getDependency2());//"Instance of Class should have been injected for unnamed Interface parameter"

		injector.injectInto(injectee2);
		Assert.isFalse(injectee1.getDependency1() == injectee2.getDependency1());//"Injected values should be different"
		Assert.isFalse(injectee1.getDependency2() == injectee2.getDependency2());//"Injected values for Interface should be different"
	}
	
	@Test
	public function performMethodInjectionWithTwoNamedParameters():Void
	{
		var injectee1 = new TwoNamedParametersMethodInjectee();
		var injectee2 = new TwoNamedParametersMethodInjectee();

		injector.mapClass(Class1, Class1, TwoNamedParametersMethodInjectee.NAME1);
		injector.mapClass(Interface1, Class1, TwoNamedParametersMethodInjectee.NAME2);

		injector.injectInto(injectee1);
		Assert.isNotNull(injectee1.getDependency1());//"Instance of Class should have been injected for named Class1 parameter"
		Assert.isNotNull(injectee1.getDependency2());//"Instance of Class should have been injected for  for named Interface parameter"

		injector.injectInto(injectee2);
		Assert.isFalse(injectee1.getDependency1() == injectee2.getDependency1());//"Injected values should be different"
		Assert.isFalse(injectee1.getDependency2() == injectee2.getDependency2());//"Injected values for Interface should be different"
	}
	
	@Test
	public function performMethodInjectionWithMixedParameters():Void
	{
		var injectee1 = new MixedParametersMethodInjectee();
		var injectee2 = new MixedParametersMethodInjectee();

		injector.mapClass(Class1, Class1, MixedParametersMethodInjectee.NAME1);
		injector.mapClass(Class1, Class1);
		injector.mapClass(Interface1, Class1, MixedParametersMethodInjectee.NAME2);
		
		injector.injectInto(injectee1);
		Assert.isNotNull(injectee1.getDependency1());//"Instance of Class should have been injected for named Class1 parameter"
		Assert.isNotNull(injectee1.getDependency2());//"Instance of Class should have been injected for unnamed Class1 parameter"
		Assert.isNotNull(injectee1.getDependency3());//"Instance of Class should have been injected for Interface"

		injector.injectInto(injectee2);
		Assert.isFalse(injectee1.getDependency1() == injectee2.getDependency1());//"Injected values for named Class1 should be different"
		Assert.isFalse(injectee1.getDependency2() == injectee2.getDependency2());//"Injected values for unnamed Class1 should be different"
		Assert.isFalse(injectee1.getDependency3() == injectee2.getDependency3());//"Injected values for named Interface should be different"
	}
	
	@Test
	public function performConstructorInjectionWithOneParameter():Void
	{
		injector.mapClass(Class1, Class1);

		var injectee = injector.instantiate(OneParameterConstructorInjectee);
		Assert.isNotNull(injectee.getDependency());//"Instance of Class should have been injected for Class1 parameter"
	}
	
	@Test
	public function performConstructorInjectionWithTwoParameters():Void
	{
		injector.mapClass(Class1, Class1);
		injector.mapValue(String, "stringDependency");

		var injectee = injector.instantiate(TwoParametersConstructorInjectee);

		Assert.isNotNull(injectee.getDependency1());//"Instance of Class should have been injected for named Class1 parameter"
		Assert.areEqual(injectee.getDependency2(), "stringDependency");//"The String 'stringDependency' should have been injected for String parameter"
	}
	
	@Test
	public function performConstructorInjectionWithOneNamedParameter():Void
	{
		injector.mapClass(Class1, Class1, OneNamedParameterConstructorInjectee.NAME);
		var injectee = injector.instantiate(OneNamedParameterConstructorInjectee);
		Assert.isNotNull(injectee.getDependency());//"Instance of Class should have been injected for named Class1 parameter"
	}
	
	@Test
	public function performConstructorInjectionWithTwoNamedParameter():Void
	{
		var stringValue = "stringDependency";
		injector.mapClass(Class1, Class1, TwoNamedParametersConstructorInjectee.NAME1);
		injector.mapValue(String, stringValue, TwoNamedParametersConstructorInjectee.NAME2);

		var injectee = injector.instantiate(TwoNamedParametersConstructorInjectee);
		Assert.isNotNull(injectee.getDependency1());//"Instance of Class should have been injected for named Class1 parameter"
		Assert.areEqual(injectee.getDependency2(), stringValue);//"The String 'stringDependency' should have been injected for named String parameter"
	}
	
	@Test
	public function performConstructorInjectionWithMixedParameters():Void
	{
		injector.mapClass(Class1, Class1, MixedParametersConstructorInjectee.NAME1);
		injector.mapClass(Class1, Class1);
		injector.mapClass(Interface1, Class1, MixedParametersConstructorInjectee.NAME2);

		var injectee = injector.instantiate(MixedParametersConstructorInjectee);
		Assert.isNotNull(injectee.getDependency1());//"Instance of Class should have been injected for named Class1 parameter"
		Assert.isNotNull(injectee.getDependency2());//"Instance of Class should have been injected for unnamed Class1 parameter"
		Assert.isNotNull(injectee.getDependency3());//"Instance of Class should have been injected for Interface"
	}
	
	@Test
	public function performNamedArrayInjection():Void
	{
		var array = ["value1", "value2", "value3"];

		injector.mapValue(Array, array, NamedArrayInjectee.NAME);
		var injectee = injector.instantiate(NamedArrayInjectee);

		Assert.isNotNull(injectee.array);//"Instance 'array' should have been injected for named Array parameter"
		Assert.areEqual(array, injectee.array);//"Instance field 'array' should be identical to local variable 'array'"
	}
	
	@Test
	public function performMappedRuleInjection():Void
	{
		var rule = injector.mapSingletonOf(Interface1, Class1);
		injector.mapRule(Interface2, rule);

		var injectee = injector.instantiate(MultipleSingletonsOfSameClassInjectee);
		Assert.areEqual(injectee.property1, injectee.property2);//"Instance field 'property1' should be identical to Instance field 'property2'"
	}
	
	@Test
	public function performMappedNamedRuleInjection():Void
	{
		var rule = injector.mapSingletonOf(Interface1, Class1);

		injector.mapRule(Interface2, rule);
		injector.mapRule(Interface1, rule, MultipleNamedSingletonsOfSameClassInjectee.NAME1);
		injector.mapRule(Interface2, rule, MultipleNamedSingletonsOfSameClassInjectee.NAME2);

		var injectee = injector.instantiate(MultipleNamedSingletonsOfSameClassInjectee);
		Assert.areEqual(injectee.property1, injectee.property2);//"Instance field 'property1' should be identical to Instance field 'property2'"
		Assert.areEqual(injectee.property1, injectee.namedProperty1);//"Instance field 'property1' should be identical to Instance field 'namedProperty1'"
		Assert.areEqual(injectee.property1, injectee.namedProperty2);//"Instance field 'property1' should be identical to Instance field 'namedProperty2'"
	}
	
	@Test
	public function performInjectionIntoValueWithRecursiveSingeltonDependency():Void
	{
		var injectee = new InterfaceInjectee();
		
		injector.mapValue(InterfaceInjectee, injectee);
		injector.mapSingletonOf(Interface1, RecursiveInterfaceInjectee);
		
		injector.injectInto(injectee);
		Assert.isTrue(true); // need to assert something

		//Assert.areEqual(injectee.property1, injectee.property2);//"Instance field 'property1' should be identical to Instance field 'property2'"
		//Assert.areEqual(injectee.property1, injectee.namedProperty1);//"Instance field 'property1' should be identical to Instance field 'namedProperty1'"
		//Assert.areEqual(injectee.property1, injectee.namedProperty2);//"Instance field 'property1' should be identical to Instance field 'namedProperty2'"
	}
	
	@Test
	public function injectXMLValue() : Void
	{
		var injectee = new XMLInjectee();
		var value = Xml.parse("<test/>");

		injector.mapValue(Xml, value);
		injector.injectInto(injectee);

		Assert.areEqual(injectee.property, value);//'injected value should be indentical to mapped value'
	}
	
	@Test
	public function postConstructIsCalled():Void
	{
		var injectee = new ClassInjectee();
		var value = new Class1();

		injector.mapValue(Class1, value);
		injector.injectInto(injectee);
		
		Assert.isTrue(injectee.someProperty);
	}
	
	@Test
	public function postConstructMethodsCalledAsOrdered():Void
	{
		var injectee = new OrderedPostConstructInjectee();
		injector.injectInto(injectee);

		Assert.isTrue(injectee.loadedAsOrdered);
	}
	
	@Test
	public function hasMappingFailsForUnmappedUnnamedClass():Void
	{
		Assert.isFalse(injector.hasMapping(Class1));
	}
	
	@Test
	public function hasMappingFailsForUnmappedNamedClass():Void
	{
		Assert.isFalse(injector.hasMapping(Class1, "namedClass"));
	}
	
	@Test
	public function hasMappingSucceedsForMappedUnnamedClass():Void
	{
		injector.mapClass(Class1, Class1);
		Assert.isTrue(injector.hasMapping(Class1));
	}
	
	@Test
	public function hasMappingSucceedsForMappedNamedClass():Void
	{
		injector.mapClass(Class1, Class1, "namedClass");
		Assert.isTrue(injector.hasMapping(Class1, "namedClass"));
	}

	@Test
	public function getMappingResponseSucceedsForMappedUnnamedClass():Void
	{
		var class1 = new Class1();
		injector.mapValue(Class1, class1);
		Assert.areEqual(injector.getInstance(Class1), class1);
	}

	@Test
	public function getMappingResponseSucceedsForMappedNamedClass():Void
	{
		var class1 = new Class1();
		injector.mapValue(Class1, class1, "namedClass");
		Assert.areEqual(injector.getInstance(Class1, "namedClass"), class1);
	}

	@Test
	public function injectorRemovesSingletonInstanceOnRuleRemoval():Void
	{
		injector.mapSingleton(Class1);

		var injectee1 = injector.instantiate(ClassInjectee);
		injector.unmap(Class1);
		injector.mapSingleton(Class1);

		var injectee2 = injector.instantiate(ClassInjectee);
		Assert.isFalse(injectee1.property == injectee2.property);//'injectee1.property is not the same instance as injectee2.property'
	}
	
	@Test
	public function haltOnMissingDependency():Void
	{
		var injectee = new InterfaceInjectee();
		var passed = false;

		try
		{
			injector.injectInto(injectee);
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, InjectorError);
		}
		
		Assert.isTrue(passed);
	}
	
	@Test
	public function haltOnMissingNamedDependency():Void
	{
		var injectee = new NamedClassInjectee();
		var passed = false;

		try
		{
			injector.injectInto(injectee);
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, InjectorError);
		}
		
		Assert.isTrue(passed);
	}

	@Test
	public function getMappingResponseFailsForUnmappedUnnamedClass():Void
	{
		var passed = false;

		try
		{
			injector.getInstance(Class1);
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, InjectorError);
		}
		
		Assert.isTrue(passed);
	}
	
	@Test
	public function getMappingResponseFailsForUnmappedNamedClass():Void
	{
		var passed = false;
		
		try
		{
			injector.getInstance(Class1, "namedClass");
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, InjectorError);
		}
		
		Assert.isTrue(passed);
	}
	
	@Test
	public function instantiateThrowsMeaningfulErrorOnInterfaceInstantiation() : Void
	{
		var passed = false;

		try
		{
			injector.instantiate(Interface1);
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, InjectorError);
		}
		
		Assert.isTrue(passed);
	}
}
