/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

import massive.munit.client.PrintClient;
import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.TestRunner;

#if js
import js.Lib;
import js.Dom;
#end

/**
 * Auto generated Test Application.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestMain
{
    static function main(){	new TestMain(); }

    public function new()
    {
        var suites = new Array<Class<massive.munit.TestSuite>>();
        suites.push(TestSuite);

        #if MCOVER
            var client = new massive.mcover.munit.client.MCoverPrintClient();
        #else
            var client = new RichPrintClient();
        #end

        var runner:TestRunner = new TestRunner(client);
        //runner.addResultClient(new HTTPClient(new JUnitReportClient()));
        runner.completionHandler = completionHandler;
        runner.run(suites);
    }

    /*
        updates the background color and closes the current browser
        for flash and html targets (useful for continous integration servers)
    */
    function completionHandler(successful:Bool):Void
    {
        try
        {
            #if flash
                flash.external.ExternalInterface.call("testResult", successful);
            #elseif js
                js.Lib.eval("testResult(" + successful + ");");
            #elseif neko
                neko.Sys.exit(0);
            #end
        }
        // if run from outside browser can get error which we can ignore
        catch (e:Dynamic)
        {
        }
    }
}
