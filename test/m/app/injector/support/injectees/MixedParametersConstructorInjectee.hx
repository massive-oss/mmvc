/*
* Copyright (c) 2009 the original author or authors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

package m.app.injector.support.injectees;

import m.app.injector.support.types.Class1;
import m.app.injector.support.types.Interface1;

class MixedParametersConstructorInjectee
{
	public static var NAME1 = "name1";
	public static var NAME2 = "name2";

	var dependency1:Class1;
	var dependency2:Class1;
	var dependency3:Interface1;
	
	public function getDependency1():Class1
	{
		return dependency1;
	}
	public function getDependency2():Class1
	{
		return dependency2;
	}
	public function getDependency3():Interface1
	{
		return dependency3;
	}
	
	@inject("name1", "", "name2")
	public function new(dependency1:Class1, dependency2:Class1, dependency3:Interface1)
	{
		this.dependency1 = dependency1;
		this.dependency2 = dependency2;
		this.dependency3 = dependency3;
	}
}
