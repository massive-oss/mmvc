/*
* Copyright (c) 2010 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package m.app.injector;

import massive.munit.Assert;

class GetConstructorTest
 {
	public function new(){}
	
	@Test
	public function passingTest()
	{
		// leving these tests in here lest we need a similar API for low level types.
		Assert.isTrue(true);
	}
	/*
	@Test
	public function getConstructorReturnsConstructorForObject() : Void
	{
		var object: Dynamic = {};
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, Object);
	}

	@Test
	public function getConstructorReturnsConstructorForArray() : Void
	{
		var array: Array<Dynamic> = [];
		var objectClass: Class<Dynamic> = getConstructor(array);
		Assert.assertEquals('object\'s constructor is Object', objectClass, Array);
	}

	@Test
	public function getConstructorReturnsConstructorForBoolean() : Void
	{
		var object: Bool = true;
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, Boolean);
	}

	@Test
	public function getConstructorReturnsConstructorForNumber() : Void
	{
		var object: Float = 10.1;
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, Number);
	}

	@Test
	public function getConstructorReturnsConstructorForInt() : Void
	{
		var object: Int = 10;
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, int);
	}

	@Test
	public function getConstructorReturnsConstructorForUint() : Void
	{
		var object = 10;
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, int);
	}

	@Test
	public function getConstructorReturnsConstructorForString() : Void
	{
		var object: String = 'string';
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, String);
	}

	@Test
	public function getConstructorReturnsConstructorForXML() : Void
	{
		var object: XML = new XML();
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, XML);
	}

	@Test
	public function getConstructorReturnsConstructorForXMLList() : Void
	{
		var object: XMLList = new XMLList();
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, XMLList);
	}

	@Test
	public function getConstructorReturnsConstructorForFunction() : Void
	{
		var object: Dynamic = function() : Void {};
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, Function);
	}

	@Test
	public function getConstructorReturnsConstructorForRegExp() : Void
	{
		var object: EReg = ~/./;
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, RegExp);
	}

	@Test
	public function getConstructorReturnsConstructorForDate() : Void
	{
		var object: Date = new Date();
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, Date);
	}

	@Test
	public function getConstructorReturnsConstructorForError() : Void
	{
		var object: Error = new Error();
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, Error);
	}

	@Test
	public function getConstructorReturnsConstructorForQName() : Void
	{
		var object: QName = new QName();
		var objectClass: Class<Dynamic> = getConstructor(object);
		Assert.assertEquals('object\'s constructor is Object', objectClass, QName);
	}

	@Test
	public function getConstructorReturnsConstructorForVector() : Void
	{
		var object : Vector.<String> = new Vector.<String>();
		var objectClass: Class<Dynamic> = getConstructor(object);
		//See comment in getConstructor for why Vector.<*> is expected.
		Assert.assertEquals('object\'s constructor is Object', objectClass, Vector.<*>);
	}
	*/
}
