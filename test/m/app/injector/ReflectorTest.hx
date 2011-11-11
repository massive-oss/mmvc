/*
 * Copyright (c) 2009 - 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package m.app.injector;

import massive.munit.Assert;

import m.app.injector.support.types.Class1;
import m.app.injector.support.types.Class1Extension;
import m.app.injector.support.types.Interface1;

class ReflectorTest
{
	public function new(){}
	
 	static var CLASS1_FQCN_DOT_NOTATION:String = "m.app.injector.support.types.Class1";
	static var CLASS_IN_ROOT_PACKAGE:Class<Dynamic> = Date;
	static var CLASS_NAME_IN_ROOT_PACKAGE:String = "Date";
	
	var reflector:Reflector;
	
	@Before
	public function setup():Void
	{
		reflector = new Reflector();
	}
	
	@After
	public function teardown():Void
	{
		reflector = null;
	}
	
	@Test
	public function classExtendsClass():Void
	{
		var isClass = reflector.classExtendsOrImplements(Class1Extension, Class1);
		Assert.isTrue(isClass);//"Class1Extension should be an extension of Class1"
	}
	
	@Test
	public function classExtendsClassFromClassNameWithDotNotation():Void
	{
		var isClass = reflector.classExtendsOrImplements("m.app.injector.support.types.Class1Extension", Class1);
		Assert.isTrue(isClass);//"Class1Extension should be an extension of Class1"
	}
	
	@Test
	public function classImplementsInterface():Void
	{
		var isImplemented = reflector.classExtendsOrImplements(Class1, Interface1);
		Assert.isTrue(isImplemented);//"Class1 should implement Interface1"
	}
	
	@Test
	public function classImplementsInterfaceFromClassNameWithDotNotation():Void
	{
		var isImplemented = reflector.classExtendsOrImplements("m.app.injector.support.types.Class1", Interface1);
		Assert.isTrue(isImplemented);//"Class1 should implement Interface1"
	}
	
	@Test
	public function getFullyQualifiedClassNameFromClass():Void
	{
		var fqcn = reflector.getFQCN(Class1);
		Assert.areEqual(CLASS1_FQCN_DOT_NOTATION, fqcn);
	}

	@Test
	public function getFullyQualifiedClassNameFromClassString():Void
	{
		var fqcn = reflector.getFQCN(CLASS1_FQCN_DOT_NOTATION);
		Assert.areEqual(CLASS1_FQCN_DOT_NOTATION, fqcn);
	}
	
	@Test
	public function getFullyQualifiedClassNameFromClassInRootPackage():Void
	{
		var fqcn = reflector.getFQCN(CLASS_IN_ROOT_PACKAGE);
		Assert.areEqual(CLASS_NAME_IN_ROOT_PACKAGE, fqcn);
	}

	@Test
	public function getFullyQualifiedClassNameFromClassStringInRootPackage():Void
	{
		var fqcn = reflector.getFQCN(CLASS_NAME_IN_ROOT_PACKAGE);
		Assert.areEqual(CLASS_NAME_IN_ROOT_PACKAGE, fqcn);
	}
}
