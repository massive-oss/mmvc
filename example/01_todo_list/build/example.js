var $_, $hxClasses = $hxClasses || {}, $estr = function() { return js.Boot.__string_rec(this,''); }
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var EReg = $hxClasses["EReg"] = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	r: null
	,match: function(s) {
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,matchedLeft: function() {
		if(this.r.m == null) throw "No string matched";
		return this.r.s.substr(0,this.r.m.index);
	}
	,matchedRight: function() {
		if(this.r.m == null) throw "No string matched";
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	,matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,customReplace: function(s,f) {
		var buf = new StringBuf();
		while(true) {
			if(!this.match(s)) break;
			buf.add(this.matchedLeft());
			buf.add(f(this));
			s = this.matchedRight();
		}
		buf.b[buf.b.length] = s == null?"null":s;
		return buf.b.join("");
	}
	,__class__: EReg
}
var Hash = $hxClasses["Hash"] = function() {
	this.h = { };
};
Hash.__name__ = ["Hash"];
Hash.prototype = {
	h: null
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return a.iterator();
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		s.b[s.b.length] = "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b[s.b.length] = i == null?"null":i;
			s.b[s.b.length] = " => ";
			s.add(Std.string(this.get(i)));
			if(it.hasNext()) s.b[s.b.length] = ", ";
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,__class__: Hash
}
var IntIter = $hxClasses["IntIter"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	min: null
	,max: null
	,hasNext: function() {
		return this.min < this.max;
	}
	,next: function() {
		return this.min++;
	}
	,__class__: IntIter
}
var Lambda = $hxClasses["Lambda"] = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.list = function(it) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		l.add(i);
	}
	return l;
}
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
}
Lambda.mapi = function(it,f) {
	var l = new List();
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(i++,x));
	}
	return l;
}
Lambda.has = function(it,elt,cmp) {
	if(cmp == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x == elt) return true;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(cmp(x,elt)) return true;
		}
	}
	return false;
}
Lambda.exists = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
}
Lambda.foreach = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
Lambda.iter = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
}
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
}
Lambda.fold = function(it,f,first) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
Lambda.empty = function(it) {
	return !it.iterator().hasNext();
}
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = a.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = b.iterator();
	while( $it1.hasNext() ) {
		var x = $it1.next();
		l.add(x);
	}
	return l;
}
Lambda.prototype = {
	__class__: Lambda
}
var List = $hxClasses["List"] = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,last: function() {
		return this.q == null?null:this.q[0];
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		s.b[s.b.length] = "{";
		while(l != null) {
			if(first) first = false; else s.b[s.b.length] = ", ";
			s.add(Std.string(l[0]));
			l = l[1];
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,join: function(sep) {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) first = false; else s.b[s.b.length] = sep == null?"null":sep;
			s.add(l[0]);
			l = l[1];
		}
		return s.b.join("");
	}
	,filter: function(f) {
		var l2 = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			if(f(v)) l2.add(v);
		}
		return l2;
	}
	,map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
	}
	,__class__: List
}
var Main = $hxClasses["Main"] = function() { }
Main.__name__ = ["Main"];
Main.main = function() {
	var view = new example.app.ApplicationView();
	var context = new example.app.ApplicationContext(view);
}
Main.prototype = {
	__class__: Main
}
var Reflect = $hxClasses["Reflect"] = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && f.__name__ == null;
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && v.__name__ != null;
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}
Reflect.prototype = {
	__class__: Reflect
}
var Std = $hxClasses["Std"] = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && x.charCodeAt(1) == 120) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
Std.prototype = {
	__class__: Std
}
var StringBuf = $hxClasses["StringBuf"] = function() {
	this.b = new Array();
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	add: function(x) {
		this.b[this.b.length] = x == null?"null":x;
	}
	,addSub: function(s,pos,len) {
		this.b[this.b.length] = s.substr(pos,len);
	}
	,addChar: function(c) {
		this.b[this.b.length] = String.fromCharCode(c);
	}
	,toString: function() {
		return this.b.join("");
	}
	,b: null
	,__class__: StringBuf
}
var StringTools = $hxClasses["StringTools"] = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && s.substr(0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && s.substr(slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = s.charCodeAt(pos);
	return c >= 9 && c <= 13 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return s.substr(r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return s.substr(0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += c.substr(0,l - sl);
		sl = l;
	} else {
		s += c;
		sl += cl;
	}
	return s;
}
StringTools.lpad = function(s,c,l) {
	var ns = "";
	var sl = s.length;
	if(sl >= l) return s;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		ns += c.substr(0,l - sl);
		sl = l;
	} else {
		ns += c;
		sl += cl;
	}
	return ns + s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.cca(index);
}
StringTools.isEOF = function(c) {
	return c != c;
}
StringTools.prototype = {
	__class__: StringTools
}
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = $hxClasses["Type"] = function() { }
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	if(o.__enum__ != null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || cl.__name__ == null) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || e.__ename__ == null) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	switch(args.length) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	a.remove("__class__");
	a.remove("__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	a.remove("__name__");
	a.remove("__interfaces__");
	a.remove("__properties__");
	a.remove("__super__");
	a.remove("prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.copy();
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ != null) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.allEnums = function(e) {
	var all = [];
	var cst = e.__constructs__;
	var _g = 0;
	while(_g < cst.length) {
		var c = cst[_g];
		++_g;
		var v = Reflect.field(e,c);
		if(!Reflect.isFunction(v)) all.push(v);
	}
	return all;
}
Type.prototype = {
	__class__: Type
}
var Xml = $hxClasses["Xml"] = function() {
};
Xml.__name__ = ["Xml"];
Xml.Element = null;
Xml.PCData = null;
Xml.CData = null;
Xml.Comment = null;
Xml.DocType = null;
Xml.Prolog = null;
Xml.Document = null;
Xml.parse = function(str) {
	var rules = [Xml.enode,Xml.epcdata,Xml.eend,Xml.ecdata,Xml.edoctype,Xml.ecomment,Xml.eprolog];
	var nrules = rules.length;
	var current = Xml.createDocument();
	var stack = new List();
	while(str.length > 0) {
		var i = 0;
		try {
			while(i < nrules) {
				var r = rules[i];
				if(r.match(str)) {
					switch(i) {
					case 0:
						var x = Xml.createElement(r.matched(1));
						current.addChild(x);
						str = r.matchedRight();
						while(Xml.eattribute.match(str)) {
							x.set(Xml.eattribute.matched(1),Xml.eattribute.matched(3));
							str = Xml.eattribute.matchedRight();
						}
						if(!Xml.eclose.match(str)) {
							i = nrules;
							throw "__break__";
						}
						if(Xml.eclose.matched(1) == ">") {
							stack.push(current);
							current = x;
						}
						str = Xml.eclose.matchedRight();
						break;
					case 1:
						var x = Xml.createPCData(r.matched(0));
						current.addChild(x);
						str = r.matchedRight();
						break;
					case 2:
						if(current._children != null && current._children.length == 0) {
							var e = Xml.createPCData("");
							current.addChild(e);
						}
						if(r.matched(1) != current._nodeName || stack.isEmpty()) {
							i = nrules;
							throw "__break__";
						}
						current = stack.pop();
						str = r.matchedRight();
						break;
					case 3:
						str = r.matchedRight();
						if(!Xml.ecdata_end.match(str)) throw "End of CDATA section not found";
						var x = Xml.createCData(Xml.ecdata_end.matchedLeft());
						current.addChild(x);
						str = Xml.ecdata_end.matchedRight();
						break;
					case 4:
						var pos = 0;
						var count = 0;
						var old = str;
						try {
							while(true) {
								if(!Xml.edoctype_elt.match(str)) throw "End of DOCTYPE section not found";
								var p = Xml.edoctype_elt.matchedPos();
								pos += p.pos + p.len;
								str = Xml.edoctype_elt.matchedRight();
								switch(Xml.edoctype_elt.matched(0)) {
								case "[":
									count++;
									break;
								case "]":
									count--;
									if(count < 0) throw "Invalid ] found in DOCTYPE declaration";
									break;
								default:
									if(count == 0) throw "__break__";
								}
							}
						} catch( e ) { if( e != "__break__" ) throw e; }
						var x = Xml.createDocType(old.substr(10,pos - 11));
						current.addChild(x);
						break;
					case 5:
						if(!Xml.ecomment_end.match(str)) throw "Unclosed Comment";
						var p = Xml.ecomment_end.matchedPos();
						var x = Xml.createComment(str.substr(4,p.pos + p.len - 7));
						current.addChild(x);
						str = Xml.ecomment_end.matchedRight();
						break;
					case 6:
						var prolog = r.matched(0);
						var x = Xml.createProlog(prolog.substr(2,prolog.length - 4));
						current.addChild(x);
						str = r.matchedRight();
						break;
					}
					throw "__break__";
				}
				i += 1;
			}
		} catch( e ) { if( e != "__break__" ) throw e; }
		if(i == nrules) {
			if(str.length > 10) throw "Xml parse error : Unexpected " + str.substr(0,10) + "..."; else throw "Xml parse error : Unexpected " + str;
		}
	}
	if(!stack.isEmpty()) throw "Xml parse error : Unclosed " + stack.last().getNodeName();
	return current;
}
Xml.createElement = function(name) {
	var r = new Xml();
	r.nodeType = Xml.Element;
	r._children = new Array();
	r._attributes = new Hash();
	r.setNodeName(name);
	return r;
}
Xml.createPCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.PCData;
	r.setNodeValue(data);
	return r;
}
Xml.createCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.CData;
	r.setNodeValue(data);
	return r;
}
Xml.createComment = function(data) {
	var r = new Xml();
	r.nodeType = Xml.Comment;
	r.setNodeValue(data);
	return r;
}
Xml.createDocType = function(data) {
	var r = new Xml();
	r.nodeType = Xml.DocType;
	r.setNodeValue(data);
	return r;
}
Xml.createProlog = function(data) {
	var r = new Xml();
	r.nodeType = Xml.Prolog;
	r.setNodeValue(data);
	return r;
}
Xml.createDocument = function() {
	var r = new Xml();
	r.nodeType = Xml.Document;
	r._children = new Array();
	return r;
}
Xml.prototype = {
	nodeType: null
	,nodeName: null
	,nodeValue: null
	,parent: null
	,_nodeName: null
	,_nodeValue: null
	,_attributes: null
	,_children: null
	,_parent: null
	,getNodeName: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName;
	}
	,setNodeName: function(n) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName = n;
	}
	,getNodeValue: function() {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue;
	}
	,setNodeValue: function(v) {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue = v;
	}
	,getParent: function() {
		return this._parent;
	}
	,get: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.get(att);
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.set(att,value);
	}
	,remove: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.remove(att);
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.exists(att);
	}
	,attributes: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.keys();
	}
	,iterator: function() {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			return this.cur < this.x.length;
		}, next : function() {
			return this.x[this.cur++];
		}};
	}
	,elements: function() {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				if(this.x[k].nodeType == Xml.Element) break;
				k += 1;
			}
			this.cur = k;
			return k < l;
		}, next : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				k += 1;
				if(n.nodeType == Xml.Element) {
					this.cur = k;
					return n;
				}
			}
			return null;
		}};
	}
	,elementsNamed: function(name) {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				if(n.nodeType == Xml.Element && n._nodeName == name) break;
				k++;
			}
			this.cur = k;
			return k < l;
		}, next : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				k++;
				if(n.nodeType == Xml.Element && n._nodeName == name) {
					this.cur = k;
					return n;
				}
			}
			return null;
		}};
	}
	,firstChild: function() {
		if(this._children == null) throw "bad nodetype";
		return this._children[0];
	}
	,firstElement: function() {
		if(this._children == null) throw "bad nodetype";
		var cur = 0;
		var l = this._children.length;
		while(cur < l) {
			var n = this._children[cur];
			if(n.nodeType == Xml.Element) return n;
			cur++;
		}
		return null;
	}
	,addChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) x._parent._children.remove(x);
		x._parent = this;
		this._children.push(x);
	}
	,removeChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		var b = this._children.remove(x);
		if(b) x._parent = null;
		return b;
	}
	,insertChild: function(x,pos) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) x._parent._children.remove(x);
		x._parent = this;
		this._children.insert(pos,x);
	}
	,toString: function() {
		if(this.nodeType == Xml.PCData) return this._nodeValue;
		if(this.nodeType == Xml.CData) return "<![CDATA[" + this._nodeValue + "]]>";
		if(this.nodeType == Xml.Comment) return "<!--" + this._nodeValue + "-->";
		if(this.nodeType == Xml.DocType) return "<!DOCTYPE " + this._nodeValue + ">";
		if(this.nodeType == Xml.Prolog) return "<?" + this._nodeValue + "?>";
		var s = new StringBuf();
		if(this.nodeType == Xml.Element) {
			s.b[s.b.length] = "<";
			s.add(this._nodeName);
			var $it0 = this._attributes.keys();
			while( $it0.hasNext() ) {
				var k = $it0.next();
				s.b[s.b.length] = " ";
				s.b[s.b.length] = k == null?"null":k;
				s.b[s.b.length] = "=\"";
				s.add(this._attributes.get(k));
				s.b[s.b.length] = "\"";
			}
			if(this._children.length == 0) {
				s.b[s.b.length] = "/>";
				return s.b.join("");
			}
			s.b[s.b.length] = ">";
		}
		var $it1 = this.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			s.add(x.toString());
		}
		if(this.nodeType == Xml.Element) {
			s.b[s.b.length] = "</";
			s.add(this._nodeName);
			s.b[s.b.length] = ">";
		}
		return s.b.join("");
	}
	,__class__: Xml
	,__properties__: {get_parent:"getParent",set_nodeValue:"setNodeValue",get_nodeValue:"getNodeValue",set_nodeName:"setNodeName",get_nodeName:"getNodeName"}
}
var m = m || {}
if(!m.mvc) m.mvc = {}
if(!m.mvc.api) m.mvc.api = {}
m.mvc.api.IContext = $hxClasses["m.mvc.api.IContext"] = function() { }
m.mvc.api.IContext.__name__ = ["m","mvc","api","IContext"];
m.mvc.api.IContext.prototype = {
	commandMap: null
	,__class__: m.mvc.api.IContext
	,__properties__: {get_commandMap:"get_commandMap"}
}
if(!m.mvc.impl) m.mvc.impl = {}
m.mvc.impl.Context = $hxClasses["m.mvc.impl.Context"] = function(contextView,autoStartup) {
	if(autoStartup == null) autoStartup = true;
	this.autoStartup = autoStartup;
	this.set_contextView(contextView);
};
m.mvc.impl.Context.__name__ = ["m","mvc","impl","Context"];
m.mvc.impl.Context.__interfaces__ = [m.mvc.api.IContext];
m.mvc.impl.Context.prototype = {
	autoStartup: null
	,contextView: null
	,commandMap: null
	,injector: null
	,mediatorMap: null
	,reflector: null
	,viewMap: null
	,startup: function() {
	}
	,shutdown: function() {
	}
	,set_contextView: function(value) {
		if(this.contextView != value) {
			this.contextView = value;
			this.commandMap = null;
			this.mediatorMap = null;
			this.viewMap = null;
			this.mapInjections();
			this.checkAutoStartup();
		}
		return value;
	}
	,get_injector: function() {
		if(this.injector == null) return this.createInjector();
		return this.injector;
	}
	,get_reflector: function() {
		if(this.reflector == null) this.reflector = new m.inject.Reflector();
		return this.reflector;
	}
	,get_commandMap: function() {
		if(this.commandMap == null) this.commandMap = new m.mvc.base.CommandMap(this.createChildInjector());
		return this.commandMap;
	}
	,get_mediatorMap: function() {
		if(this.mediatorMap == null) this.mediatorMap = new m.mvc.base.MediatorMap(this.contextView,this.createChildInjector(),this.get_reflector());
		return this.mediatorMap;
	}
	,get_viewMap: function() {
		if(this.viewMap == null) this.viewMap = new m.mvc.base.ViewMap(this.contextView,this.get_injector());
		return this.viewMap;
	}
	,mapInjections: function() {
		this.get_injector().mapValue(m.inject.IReflector,this.get_reflector());
		this.get_injector().mapValue(m.inject.IInjector,this.get_injector());
		this.get_injector().mapValue(m.mvc.api.IViewContainer,this.contextView);
		this.get_injector().mapValue(m.mvc.api.ICommandMap,this.get_commandMap());
		this.get_injector().mapValue(m.mvc.api.IMediatorMap,this.get_mediatorMap());
		this.get_injector().mapValue(m.mvc.api.IViewMap,this.get_viewMap());
	}
	,checkAutoStartup: function() {
		if(this.autoStartup && this.contextView != null) this.startup();
	}
	,createInjector: function() {
		this.injector = new m.inject.Injector();
		return this.get_injector();
	}
	,createChildInjector: function() {
		return this.get_injector().createChildInjector();
	}
	,__class__: m.mvc.impl.Context
	,__properties__: {get_viewMap:"get_viewMap",get_reflector:"get_reflector",get_mediatorMap:"get_mediatorMap",get_injector:"get_injector",get_commandMap:"get_commandMap",set_contextView:"set_contextView"}
}
var example = example || {}
if(!example.app) example.app = {}
example.app.ApplicationContext = $hxClasses["example.app.ApplicationContext"] = function(contextView) {
	m.mvc.impl.Context.call(this,contextView);
};
example.app.ApplicationContext.__name__ = ["example","app","ApplicationContext"];
example.app.ApplicationContext.__super__ = m.mvc.impl.Context;
example.app.ApplicationContext.prototype = $extend(m.mvc.impl.Context.prototype,{
	startup: function() {
		this.get_commandMap().mapSignalClass(example.todo.signal.LoadTodoList,example.todo.command.LoadTodoListCommand);
		this.get_injector().mapSingleton(example.todo.model.TodoList);
		this.get_mediatorMap().mapView(example.todo.view.TodoListView,example.todo.view.TodoListViewMediator);
		this.get_mediatorMap().mapView(example.app.ApplicationView,example.app.ApplicationViewMediator);
	}
	,shutdown: function() {
	}
	,__class__: example.app.ApplicationContext
});
m.mvc.api.IViewContainer = $hxClasses["m.mvc.api.IViewContainer"] = function() { }
m.mvc.api.IViewContainer.__name__ = ["m","mvc","api","IViewContainer"];
m.mvc.api.IViewContainer.prototype = {
	viewAdded: null
	,viewRemoved: null
	,isAdded: null
	,__class__: m.mvc.api.IViewContainer
}
example.app.ApplicationView = $hxClasses["example.app.ApplicationView"] = function() {
};
example.app.ApplicationView.__name__ = ["example","app","ApplicationView"];
example.app.ApplicationView.__interfaces__ = [m.mvc.api.IViewContainer];
example.app.ApplicationView.prototype = {
	viewAdded: null
	,viewRemoved: null
	,isAdded: function(view) {
		return false;
	}
	,initialize: function() {
		var todoView = new example.todo.view.TodoListView();
		this.viewAdded(todoView);
	}
	,__class__: example.app.ApplicationView
}
m.mvc.api.IMediator = $hxClasses["m.mvc.api.IMediator"] = function() { }
m.mvc.api.IMediator.__name__ = ["m","mvc","api","IMediator"];
m.mvc.api.IMediator.prototype = {
	preRegister: null
	,onRegister: null
	,preRemove: null
	,onRemove: null
	,getViewComponent: null
	,setViewComponent: null
	,__class__: m.mvc.api.IMediator
}
if(!m.mvc.base) m.mvc.base = {}
m.mvc.base.MediatorBase = $hxClasses["m.mvc.base.MediatorBase"] = function() {
	this.slots = [];
};
m.mvc.base.MediatorBase.__name__ = ["m","mvc","base","MediatorBase"];
m.mvc.base.MediatorBase.__interfaces__ = [m.mvc.api.IMediator];
m.mvc.base.MediatorBase.prototype = {
	view: null
	,removed: null
	,slots: null
	,preRegister: function() {
		this.removed = false;
		this.onRegister();
	}
	,onRegister: function() {
	}
	,preRemove: function() {
		this.removed = true;
		this.onRemove();
	}
	,onRemove: function() {
		var _g = 0, _g1 = this.slots;
		while(_g < _g1.length) {
			var slot = _g1[_g];
			++_g;
			slot.remove();
		}
	}
	,getViewComponent: function() {
		return this.view;
	}
	,setViewComponent: function(viewComponent) {
		this.view = viewComponent;
	}
	,mediate: function(slot) {
		this.slots.push(slot);
	}
	,__class__: m.mvc.base.MediatorBase
}
m.mvc.impl.Mediator = $hxClasses["m.mvc.impl.Mediator"] = function() {
	m.mvc.base.MediatorBase.call(this);
};
m.mvc.impl.Mediator.__name__ = ["m","mvc","impl","Mediator"];
m.mvc.impl.Mediator.__super__ = m.mvc.base.MediatorBase;
m.mvc.impl.Mediator.prototype = $extend(m.mvc.base.MediatorBase.prototype,{
	injector: null
	,contextView: null
	,mediatorMap: null
	,__class__: m.mvc.impl.Mediator
});
example.app.ApplicationViewMediator = $hxClasses["example.app.ApplicationViewMediator"] = function() {
	m.mvc.impl.Mediator.call(this);
};
example.app.ApplicationViewMediator.__name__ = ["example","app","ApplicationViewMediator"];
example.app.ApplicationViewMediator.__super__ = m.mvc.impl.Mediator;
example.app.ApplicationViewMediator.prototype = $extend(m.mvc.impl.Mediator.prototype,{
	onRegister: function() {
		this.view.initialize();
	}
	,__class__: example.app.ApplicationViewMediator
});
m.mvc.api.ICommand = $hxClasses["m.mvc.api.ICommand"] = function() { }
m.mvc.api.ICommand.__name__ = ["m","mvc","api","ICommand"];
m.mvc.api.ICommand.prototype = {
	execute: null
	,__class__: m.mvc.api.ICommand
}
m.mvc.impl.Command = $hxClasses["m.mvc.impl.Command"] = function() {
};
m.mvc.impl.Command.__name__ = ["m","mvc","impl","Command"];
m.mvc.impl.Command.__interfaces__ = [m.mvc.api.ICommand];
m.mvc.impl.Command.prototype = {
	contextView: null
	,commandMap: null
	,injector: null
	,mediatorMap: null
	,execute: function() {
	}
	,__class__: m.mvc.impl.Command
}
if(!example.todo) example.todo = {}
if(!example.todo.command) example.todo.command = {}
example.todo.command.LoadTodoListCommand = $hxClasses["example.todo.command.LoadTodoListCommand"] = function() {
	m.mvc.impl.Command.call(this);
};
example.todo.command.LoadTodoListCommand.__name__ = ["example","todo","command","LoadTodoListCommand"];
example.todo.command.LoadTodoListCommand.__super__ = m.mvc.impl.Command;
example.todo.command.LoadTodoListCommand.prototype = $extend(m.mvc.impl.Command.prototype,{
	list: null
	,signal: null
	,loader: null
	,execute: function() {
		this.loader = new m.loader.JSONLoader();
		this.loader.completed.addOnce(this.completed.$bind(this));
		this.loader.failed.addOnce(this.failed.$bind(this));
		this.loader.load("data.json");
	}
	,completed: function(data) {
		this.loader.failed.remove(this.failed.$bind(this));
		var items = data.items;
		var _g = 0;
		while(_g < items.length) {
			var item = items[_g];
			++_g;
			var todo = new example.todo.model.Todo(item.name);
			todo.done = item.done == true;
			this.list.add(todo);
		}
		this.signal.completed.dispatch(this.list);
	}
	,failed: function(error) {
		this.loader.completed.remove(this.completed.$bind(this));
		this.signal.failed.dispatch(Std.string(error));
	}
	,__class__: example.todo.command.LoadTodoListCommand
});
if(!example.todo.model) example.todo.model = {}
example.todo.model.Todo = $hxClasses["example.todo.model.Todo"] = function(name) {
	this.name = name;
	this.done = false;
};
example.todo.model.Todo.__name__ = ["example","todo","model","Todo"];
example.todo.model.Todo.prototype = {
	name: null
	,done: null
	,toString: function() {
		return haxe.Json.stringify(this);
	}
	,__class__: example.todo.model.Todo
}
example.todo.model.TodoList = $hxClasses["example.todo.model.TodoList"] = function(items) {
	if(items == null) items = [];
	this.items = items;
};
example.todo.model.TodoList.__name__ = ["example","todo","model","TodoList"];
example.todo.model.TodoList.prototype = {
	items: null
	,length: null
	,add: function(todo) {
		this.items.push(todo);
	}
	,remove: function(todo) {
		this.items.remove(todo);
	}
	,getRemaining: function() {
		var count = 0;
		var _g = 0, _g1 = this.items;
		while(_g < _g1.length) {
			var todo = _g1[_g];
			++_g;
			if(!todo.done) count++;
		}
		return count;
	}
	,get_length: function() {
		return this.items.length;
	}
	,__class__: example.todo.model.TodoList
	,__properties__: {get_length:"get_length"}
}
if(!m.signal) m.signal = {}
m.signal.Signal = $hxClasses["m.signal.Signal"] = function(valueClasses) {
	if(valueClasses == null) valueClasses = [];
	this.valueClasses = valueClasses;
	this.slots = m.signal.SlotList.NIL;
	this.priorityBased = false;
};
m.signal.Signal.__name__ = ["m","signal","Signal"];
m.signal.Signal.prototype = {
	valueClasses: null
	,numListeners: null
	,slots: null
	,priorityBased: null
	,add: function(listener) {
		return this.registerListener(listener);
	}
	,addOnce: function(listener) {
		return this.registerListener(listener,true);
	}
	,addWithPriority: function(listener,priority) {
		if(priority == null) priority = 0;
		return this.registerListener(listener,false,priority);
	}
	,addOnceWithPriority: function(listener,priority) {
		if(priority == null) priority = 0;
		return this.registerListener(listener,true,priority);
	}
	,remove: function(listener) {
		var slot = this.slots.find(listener);
		if(slot == null) return null;
		this.slots = this.slots.filterNot(listener);
		return slot;
	}
	,removeAll: function() {
		this.slots = m.signal.SlotList.NIL;
	}
	,registerListener: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		if(this.registrationPossible(listener,once)) {
			var newSlot = this.createSlot(listener,once,priority);
			if(!this.priorityBased && priority != 0) this.priorityBased = true;
			if(!this.priorityBased && priority == 0) this.slots = this.slots.prepend(newSlot); else this.slots = this.slots.insertWithPriority(newSlot);
			return newSlot;
		}
		return this.slots.find(listener);
	}
	,registrationPossible: function(listener,once) {
		if(!this.slots.nonEmpty) return true;
		var existingSlot = this.slots.find(listener);
		if(existingSlot == null) return true;
		if(existingSlot.once != once) throw new m.exception.IllegalOperationException("You cannot addOnce() then add() the same listener without removing the relationship first.",null,{ fileName : "Signal.hx", lineNumber : 133, className : "m.signal.Signal", methodName : "registrationPossible"});
		return false;
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return null;
	}
	,get_numListeners: function() {
		return this.slots.get_length();
	}
	,__class__: m.signal.Signal
	,__properties__: {get_numListeners:"get_numListeners"}
}
m.signal.Signal0 = $hxClasses["m.signal.Signal0"] = function() {
	m.signal.Signal.call(this);
};
m.signal.Signal0.__name__ = ["m","signal","Signal0"];
m.signal.Signal0.__super__ = m.signal.Signal;
m.signal.Signal0.prototype = $extend(m.signal.Signal.prototype,{
	dispatch: function() {
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute();
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new m.signal.Slot0(this,listener,once,priority);
	}
	,__class__: m.signal.Signal0
});
if(!example.todo.signal) example.todo.signal = {}
example.todo.signal.LoadTodoList = $hxClasses["example.todo.signal.LoadTodoList"] = function() {
	m.signal.Signal0.call(this);
	this.completed = new m.signal.Signal1(example.todo.model.TodoList);
	this.failed = new m.signal.Signal1(Dynamic);
};
example.todo.signal.LoadTodoList.__name__ = ["example","todo","signal","LoadTodoList"];
example.todo.signal.LoadTodoList.__super__ = m.signal.Signal0;
example.todo.signal.LoadTodoList.prototype = $extend(m.signal.Signal0.prototype,{
	completed: null
	,failed: null
	,__class__: example.todo.signal.LoadTodoList
});
if(!example.todo.view) example.todo.view = {}
example.todo.view.TodoListView = $hxClasses["example.todo.view.TodoListView"] = function() {
};
example.todo.view.TodoListView.__name__ = ["example","todo","view","TodoListView"];
example.todo.view.TodoListView.prototype = {
	__class__: example.todo.view.TodoListView
}
example.todo.view.TodoView = $hxClasses["example.todo.view.TodoView"] = function() {
};
example.todo.view.TodoView.__name__ = ["example","todo","view","TodoView"];
example.todo.view.TodoView.prototype = {
	__class__: example.todo.view.TodoView
}
example.todo.view.TodoListViewMediator = $hxClasses["example.todo.view.TodoListViewMediator"] = function() {
	m.mvc.impl.Mediator.call(this);
};
example.todo.view.TodoListViewMediator.__name__ = ["example","todo","view","TodoListViewMediator"];
example.todo.view.TodoListViewMediator.__super__ = m.mvc.impl.Mediator;
example.todo.view.TodoListViewMediator.prototype = $extend(m.mvc.impl.Mediator.prototype,{
	loadTodoList: null
	,onRegister: function() {
		this.loadTodoList.completed.addOnce(this.completed.$bind(this));
		this.loadTodoList.failed.addOnce(this.failed.$bind(this));
		this.loadTodoList.dispatch();
	}
	,completed: function(list) {
		haxe.Log.trace(list.get_length(),{ fileName : "TodoListViewMediator.hx", lineNumber : 25, className : "example.todo.view.TodoListViewMediator", methodName : "completed"});
	}
	,failed: function(error) {
	}
	,__class__: example.todo.view.TodoListViewMediator
});
var haxe = haxe || {}
haxe.Http = $hxClasses["haxe.Http"] = function(url) {
	this.url = url;
	this.headers = new Hash();
	this.params = new Hash();
	this.async = true;
};
haxe.Http.__name__ = ["haxe","Http"];
haxe.Http.requestUrl = function(url) {
	var h = new haxe.Http(url);
	h.async = false;
	var r = null;
	h.onData = function(d) {
		r = d;
	};
	h.onError = function(e) {
		throw e;
	};
	h.request(false);
	return r;
}
haxe.Http.prototype = {
	loader: null
	,cancel: function() {
		if(this.loader != null) {
			this.loader.abort();
			this.loader = null;
		}
	}
	,url: null
	,async: null
	,postData: null
	,headers: null
	,params: null
	,setHeader: function(header,value) {
		this.headers.set(header,value);
	}
	,setParameter: function(param,value) {
		this.params.set(param,value);
	}
	,setPostData: function(data) {
		this.postData = data;
	}
	,request: function(post) {
		var me = this;
		var r = this.loader = new js.XMLHttpRequest();
		var onreadystatechange = function() {
			if(r.readyState != 4) return;
			var s = (function($this) {
				var $r;
				try {
					$r = r.status;
				} catch( e ) {
					$r = null;
				}
				return $r;
			}(this));
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) me.onData(r.responseText); else switch(s) {
			case null: case undefined:
				me.onError("Failed to connect or resolve host");
				break;
			case 12029:
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.onError("Unknown host");
				break;
			default:
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var $it0 = this.params.keys();
			while( $it0.hasNext() ) {
				var p = $it0.next();
				if(uri == null) uri = ""; else uri += "&";
				uri += StringTools.urlDecode(p) + "=" + StringTools.urlEncode(this.params.get(p));
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e ) {
			this.onError(e.toString());
			return;
		}
		if(this.headers.get("Content-Type") == null && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var $it1 = this.headers.keys();
		while( $it1.hasNext() ) {
			var h = $it1.next();
			r.setRequestHeader(h,this.headers.get(h));
		}
		r.send(uri);
		if(!this.async) onreadystatechange();
	}
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
	,__class__: haxe.Http
}
haxe.Json = $hxClasses["haxe.Json"] = function() {
};
haxe.Json.__name__ = ["haxe","Json"];
haxe.Json.parse = function(text) {
	return new haxe.Json().doParse(text);
}
haxe.Json.stringify = function(value) {
	return new haxe.Json().toString(value);
}
haxe.Json.prototype = {
	buf: null
	,str: null
	,pos: null
	,reg_float: null
	,toString: function(v) {
		this.buf = new StringBuf();
		this.toStringRec(v);
		return this.buf.b.join("");
	}
	,objString: function(v) {
		var first = true;
		this.buf.add("{");
		var _g = 0, _g1 = Reflect.fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			var value = Reflect.field(v,f);
			if(Reflect.isFunction(value)) continue;
			if(first) first = false; else this.buf.add(",");
			this.quote(f);
			this.buf.add(":");
			this.toStringRec(value);
		}
		this.buf.add("}");
	}
	,toStringRec: function(v) {
		var $e = (Type["typeof"](v));
		switch( $e[1] ) {
		case 8:
			this.buf.add("\"???\"");
			break;
		case 4:
			this.objString(v);
			break;
		case 1:
		case 2:
			this.buf.add(v);
			break;
		case 5:
			this.buf.add("\"<fun>\"");
			break;
		case 6:
			var c = $e[2];
			if(c == String) this.quote(v); else if(c == Array) {
				var v1 = v;
				this.buf.add("[");
				var len = v1.length;
				if(len > 0) {
					this.toStringRec(v1[0]);
					var i = 1;
					while(i < len) {
						this.buf.add(",");
						this.toStringRec(v1[i++]);
					}
				}
				this.buf.add("]");
			} else if(c == Hash) {
				var v1 = v;
				var o = { };
				var $it0 = v1.keys();
				while( $it0.hasNext() ) {
					var k = $it0.next();
					o[k] = v1.get(k);
				}
				this.objString(o);
			} else if(v.iterator != null) {
				var a = [];
				var it = v.iterator();
				while( it.hasNext() ) {
					var v1 = it.next();
					a.push(v1);
				}
				this.toStringRec(a);
			} else this.objString(v);
			break;
		case 7:
			var e = $e[2];
			this.buf.add(v[1]);
			break;
		case 3:
			this.buf.add(v?"true":"false");
			break;
		case 0:
			this.buf.add("null");
			break;
		}
	}
	,quote: function(s) {
		this.buf.add("\"");
		var i = 0;
		while(true) {
			var c = s.cca(i++);
			if(c != c) break;
			switch(c) {
			case 34:
				this.buf.add("\\\"");
				break;
			case 92:
				this.buf.add("\\\\");
				break;
			case 10:
				this.buf.add("\\n");
				break;
			case 13:
				this.buf.add("\\r");
				break;
			case 9:
				this.buf.add("\\t");
				break;
			case 8:
				this.buf.add("\\b");
				break;
			case 12:
				this.buf.add("\\f");
				break;
			default:
				this.buf.addChar(c);
			}
		}
		this.buf.add("\"");
	}
	,doParse: function(str) {
		this.reg_float = new EReg("^-?(0|[1-9][0-9]*)(\\.[0-9]+)?([eE][+-]?[0-9]+)?","");
		this.str = str;
		this.pos = 0;
		return this.parseRec();
	}
	,invalidChar: function() {
		this.pos--;
		throw "Invalid char " + this.str.cca(this.pos) + " at position " + this.pos;
	}
	,nextChar: function() {
		return this.str.cca(this.pos++);
	}
	,parseRec: function() {
		while(true) {
			var c = this.str.cca(this.pos++);
			switch(c) {
			case 32:case 13:case 10:case 9:
				break;
			case 123:
				var obj = { }, field = null, comma = null;
				while(true) {
					var c1 = this.str.cca(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 125:
						if(field != null || comma == false) this.invalidChar();
						return obj;
					case 58:
						if(field == null) this.invalidChar();
						obj[field] = this.parseRec();
						field = null;
						comma = true;
						break;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					case 34:
						if(comma) this.invalidChar();
						field = this.parseString();
						break;
					default:
						this.invalidChar();
					}
				}
				break;
			case 91:
				var arr = [], comma = null;
				while(true) {
					var c1 = this.str.cca(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 93:
						if(comma == false) this.invalidChar();
						return arr;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					default:
						if(comma) this.invalidChar();
						this.pos--;
						arr.push(this.parseRec());
						comma = true;
					}
				}
				break;
			case 116:
				var save = this.pos;
				if(this.str.cca(this.pos++) != 114 || this.str.cca(this.pos++) != 117 || this.str.cca(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return true;
			case 102:
				var save = this.pos;
				if(this.str.cca(this.pos++) != 97 || this.str.cca(this.pos++) != 108 || this.str.cca(this.pos++) != 115 || this.str.cca(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return false;
			case 110:
				var save = this.pos;
				if(this.str.cca(this.pos++) != 117 || this.str.cca(this.pos++) != 108 || this.str.cca(this.pos++) != 108) {
					this.pos = save;
					this.invalidChar();
				}
				return null;
			case 34:
				return this.parseString();
			case 48:case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:case 45:
				this.pos--;
				if(!this.reg_float.match(this.str.substr(this.pos))) throw "Invalid float at position " + this.pos;
				var v = this.reg_float.matched(0);
				this.pos += v.length;
				var f = Std.parseFloat(v);
				var i = f | 0;
				return i == f?i:f;
			default:
				this.invalidChar();
			}
		}
		return null;
	}
	,parseString: function() {
		var start = this.pos;
		var buf = new StringBuf();
		while(true) {
			var c = this.str.cca(this.pos++);
			if(c == 34) break;
			if(c == 92) {
				buf.b[buf.b.length] = this.str.substr(start,this.pos - start - 1);
				c = this.str.cca(this.pos++);
				switch(c) {
				case 114:
					buf.b[buf.b.length] = String.fromCharCode(13);
					break;
				case 110:
					buf.b[buf.b.length] = String.fromCharCode(10);
					break;
				case 116:
					buf.b[buf.b.length] = String.fromCharCode(9);
					break;
				case 98:
					buf.b[buf.b.length] = String.fromCharCode(8);
					break;
				case 102:
					buf.b[buf.b.length] = String.fromCharCode(12);
					break;
				case 47:case 92:case 34:
					buf.b[buf.b.length] = String.fromCharCode(c);
					break;
				case 117:
					var uc = Std.parseInt("0x" + this.str.substr(this.pos,4));
					this.pos += 4;
					buf.b[buf.b.length] = String.fromCharCode(uc);
					break;
				default:
					throw "Invalid escape sequence \\" + String.fromCharCode(c) + " at position " + (this.pos - 1);
				}
				start = this.pos;
			} else if(c != c) throw "Unclosed string";
		}
		buf.b[buf.b.length] = this.str.substr(start,this.pos - start - 1);
		return buf.b.join("");
	}
	,__class__: haxe.Json
}
haxe.Log = $hxClasses["haxe.Log"] = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype = {
	__class__: haxe.Log
}
haxe.StackItem = $hxClasses["haxe.StackItem"] = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","Lambda"] }
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Lambda = function(v) { var $x = ["Lambda",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.Stack = $hxClasses["haxe.Stack"] = function() { }
haxe.Stack.__name__ = ["haxe","Stack"];
haxe.Stack.callStack = function() {
	return [];
}
haxe.Stack.exceptionStack = function() {
	return [];
}
haxe.Stack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b[b.b.length] = "\nCalled from ";
		haxe.Stack.itemToString(b,s);
	}
	return b.b.join("");
}
haxe.Stack.itemToString = function(b,s) {
	var $e = (s);
	switch( $e[1] ) {
	case 0:
		b.b[b.b.length] = "a C function";
		break;
	case 1:
		var m = $e[2];
		b.b[b.b.length] = "module ";
		b.b[b.b.length] = m == null?"null":m;
		break;
	case 2:
		var line = $e[4], file = $e[3], s1 = $e[2];
		if(s1 != null) {
			haxe.Stack.itemToString(b,s1);
			b.b[b.b.length] = " (";
		}
		b.b[b.b.length] = file == null?"null":file;
		b.b[b.b.length] = " line ";
		b.b[b.b.length] = line == null?"null":line;
		if(s1 != null) b.b[b.b.length] = ")";
		break;
	case 3:
		var meth = $e[3], cname = $e[2];
		b.b[b.b.length] = cname == null?"null":cname;
		b.b[b.b.length] = ".";
		b.b[b.b.length] = meth == null?"null":meth;
		break;
	case 4:
		var n = $e[2];
		b.b[b.b.length] = "local function #";
		b.b[b.b.length] = n == null?"null":n;
		break;
	}
}
haxe.Stack.makeStack = function(s) {
	return null;
}
haxe.Stack.prototype = {
	__class__: haxe.Stack
}
haxe.Timer = $hxClasses["haxe.Timer"] = function(time_ms) {
	var me = this;
	this.id = window.setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
haxe.Timer.measure = function(f,pos) {
	var t0 = haxe.Timer.stamp();
	var r = f();
	haxe.Log.trace(haxe.Timer.stamp() - t0 + "s",pos);
	return r;
}
haxe.Timer.stamp = function() {
	return Date.now().getTime() / 1000;
}
haxe.Timer.prototype = {
	id: null
	,stop: function() {
		if(this.id == null) return;
		window.clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe.Timer
}
if(!haxe.rtti) haxe.rtti = {}
haxe.rtti.CType = $hxClasses["haxe.rtti.CType"] = { __ename__ : ["haxe","rtti","CType"], __constructs__ : ["CUnknown","CEnum","CClass","CTypedef","CFunction","CAnonymous","CDynamic"] }
haxe.rtti.CType.CUnknown = ["CUnknown",0];
haxe.rtti.CType.CUnknown.toString = $estr;
haxe.rtti.CType.CUnknown.__enum__ = haxe.rtti.CType;
haxe.rtti.CType.CEnum = function(name,params) { var $x = ["CEnum",1,name,params]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CClass = function(name,params) { var $x = ["CClass",2,name,params]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CTypedef = function(name,params) { var $x = ["CTypedef",3,name,params]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CFunction = function(args,ret) { var $x = ["CFunction",4,args,ret]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CAnonymous = function(fields) { var $x = ["CAnonymous",5,fields]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CDynamic = function(t) { var $x = ["CDynamic",6,t]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.Rights = $hxClasses["haxe.rtti.Rights"] = { __ename__ : ["haxe","rtti","Rights"], __constructs__ : ["RNormal","RNo","RCall","RMethod","RDynamic","RInline"] }
haxe.rtti.Rights.RNormal = ["RNormal",0];
haxe.rtti.Rights.RNormal.toString = $estr;
haxe.rtti.Rights.RNormal.__enum__ = haxe.rtti.Rights;
haxe.rtti.Rights.RNo = ["RNo",1];
haxe.rtti.Rights.RNo.toString = $estr;
haxe.rtti.Rights.RNo.__enum__ = haxe.rtti.Rights;
haxe.rtti.Rights.RCall = function(m) { var $x = ["RCall",2,m]; $x.__enum__ = haxe.rtti.Rights; $x.toString = $estr; return $x; }
haxe.rtti.Rights.RMethod = ["RMethod",3];
haxe.rtti.Rights.RMethod.toString = $estr;
haxe.rtti.Rights.RMethod.__enum__ = haxe.rtti.Rights;
haxe.rtti.Rights.RDynamic = ["RDynamic",4];
haxe.rtti.Rights.RDynamic.toString = $estr;
haxe.rtti.Rights.RDynamic.__enum__ = haxe.rtti.Rights;
haxe.rtti.Rights.RInline = ["RInline",5];
haxe.rtti.Rights.RInline.toString = $estr;
haxe.rtti.Rights.RInline.__enum__ = haxe.rtti.Rights;
haxe.rtti.TypeTree = $hxClasses["haxe.rtti.TypeTree"] = { __ename__ : ["haxe","rtti","TypeTree"], __constructs__ : ["TPackage","TClassdecl","TEnumdecl","TTypedecl"] }
haxe.rtti.TypeTree.TPackage = function(name,full,subs) { var $x = ["TPackage",0,name,full,subs]; $x.__enum__ = haxe.rtti.TypeTree; $x.toString = $estr; return $x; }
haxe.rtti.TypeTree.TClassdecl = function(c) { var $x = ["TClassdecl",1,c]; $x.__enum__ = haxe.rtti.TypeTree; $x.toString = $estr; return $x; }
haxe.rtti.TypeTree.TEnumdecl = function(e) { var $x = ["TEnumdecl",2,e]; $x.__enum__ = haxe.rtti.TypeTree; $x.toString = $estr; return $x; }
haxe.rtti.TypeTree.TTypedecl = function(t) { var $x = ["TTypedecl",3,t]; $x.__enum__ = haxe.rtti.TypeTree; $x.toString = $estr; return $x; }
haxe.rtti.TypeApi = $hxClasses["haxe.rtti.TypeApi"] = function() { }
haxe.rtti.TypeApi.__name__ = ["haxe","rtti","TypeApi"];
haxe.rtti.TypeApi.typeInfos = function(t) {
	var inf;
	var $e = (t);
	switch( $e[1] ) {
	case 1:
		var c = $e[2];
		inf = c;
		break;
	case 2:
		var e = $e[2];
		inf = e;
		break;
	case 3:
		var t1 = $e[2];
		inf = t1;
		break;
	case 0:
		throw "Unexpected Package";
		break;
	}
	return inf;
}
haxe.rtti.TypeApi.isVar = function(t) {
	return (function($this) {
		var $r;
		switch( (t)[1] ) {
		case 4:
			$r = false;
			break;
		default:
			$r = true;
		}
		return $r;
	}(this));
}
haxe.rtti.TypeApi.leq = function(f,l1,l2) {
	var it = l2.iterator();
	var $it0 = l1.iterator();
	while( $it0.hasNext() ) {
		var e1 = $it0.next();
		if(!it.hasNext()) return false;
		var e2 = it.next();
		if(!f(e1,e2)) return false;
	}
	if(it.hasNext()) return false;
	return true;
}
haxe.rtti.TypeApi.rightsEq = function(r1,r2) {
	if(r1 == r2) return true;
	var $e = (r1);
	switch( $e[1] ) {
	case 2:
		var m1 = $e[2];
		var $e = (r2);
		switch( $e[1] ) {
		case 2:
			var m2 = $e[2];
			return m1 == m2;
		default:
		}
		break;
	default:
	}
	return false;
}
haxe.rtti.TypeApi.typeEq = function(t1,t2) {
	var $e = (t1);
	switch( $e[1] ) {
	case 0:
		return t2 == haxe.rtti.CType.CUnknown;
	case 1:
		var params = $e[3], name = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 1:
			var params2 = $e[3], name2 = $e[2];
			return name == name2 && haxe.rtti.TypeApi.leq(haxe.rtti.TypeApi.typeEq,params,params2);
		default:
		}
		break;
	case 2:
		var params = $e[3], name = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 2:
			var params2 = $e[3], name2 = $e[2];
			return name == name2 && haxe.rtti.TypeApi.leq(haxe.rtti.TypeApi.typeEq,params,params2);
		default:
		}
		break;
	case 3:
		var params = $e[3], name = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 3:
			var params2 = $e[3], name2 = $e[2];
			return name == name2 && haxe.rtti.TypeApi.leq(haxe.rtti.TypeApi.typeEq,params,params2);
		default:
		}
		break;
	case 4:
		var ret = $e[3], args = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 4:
			var ret2 = $e[3], args2 = $e[2];
			return haxe.rtti.TypeApi.leq(function(a,b) {
				return a.name == b.name && a.opt == b.opt && haxe.rtti.TypeApi.typeEq(a.t,b.t);
			},args,args2) && haxe.rtti.TypeApi.typeEq(ret,ret2);
		default:
		}
		break;
	case 5:
		var fields = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 5:
			var fields2 = $e[2];
			return haxe.rtti.TypeApi.leq(function(a,b) {
				return a.name == b.name && haxe.rtti.TypeApi.typeEq(a.t,b.t);
			},fields,fields2);
		default:
		}
		break;
	case 6:
		var t = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 6:
			var t21 = $e[2];
			if(t == null != (t21 == null)) return false;
			return t == null || haxe.rtti.TypeApi.typeEq(t,t21);
		default:
		}
		break;
	}
	return false;
}
haxe.rtti.TypeApi.fieldEq = function(f1,f2) {
	if(f1.name != f2.name) return false;
	if(!haxe.rtti.TypeApi.typeEq(f1.type,f2.type)) return false;
	if(f1.isPublic != f2.isPublic) return false;
	if(f1.doc != f2.doc) return false;
	if(!haxe.rtti.TypeApi.rightsEq(f1.get,f2.get)) return false;
	if(!haxe.rtti.TypeApi.rightsEq(f1.set,f2.set)) return false;
	if(f1.params == null != (f2.params == null)) return false;
	if(f1.params != null && f1.params.join(":") != f2.params.join(":")) return false;
	return true;
}
haxe.rtti.TypeApi.constructorEq = function(c1,c2) {
	if(c1.name != c2.name) return false;
	if(c1.doc != c2.doc) return false;
	if(c1.args == null != (c2.args == null)) return false;
	if(c1.args != null && !haxe.rtti.TypeApi.leq(function(a,b) {
		return a.name == b.name && a.opt == b.opt && haxe.rtti.TypeApi.typeEq(a.t,b.t);
	},c1.args,c2.args)) return false;
	return true;
}
haxe.rtti.TypeApi.prototype = {
	__class__: haxe.rtti.TypeApi
}
haxe.rtti.Meta = $hxClasses["haxe.rtti.Meta"] = function() { }
haxe.rtti.Meta.__name__ = ["haxe","rtti","Meta"];
haxe.rtti.Meta.getType = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.obj == null?{ }:meta.obj;
}
haxe.rtti.Meta.getStatics = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.statics == null?{ }:meta.statics;
}
haxe.rtti.Meta.getFields = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.fields == null?{ }:meta.fields;
}
haxe.rtti.Meta.prototype = {
	__class__: haxe.rtti.Meta
}
var js = js || {}
js.Boot = $hxClasses["js.Boot"] = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ != null || o.__ename__ != null)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__ != null) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		return o.__enum__ == cl || cl == Class && o.__name__ != null || cl == Enum && o.__ename__ != null;
	}
}
js.Boot.__init = function() {
	js.Lib.isIE = typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null;
	js.Lib.isOpera = typeof window!='undefined' && window.opera != null;
	Array.prototype.copy = Array.prototype.slice;
	Array.prototype.insert = function(i,x) {
		this.splice(i,0,x);
	};
	Array.prototype.remove = Array.prototype.indexOf?function(obj) {
		var idx = this.indexOf(obj);
		if(idx == -1) return false;
		this.splice(idx,1);
		return true;
	}:function(obj) {
		var i = 0;
		var l = this.length;
		while(i < l) {
			if(this[i] == obj) {
				this.splice(i,1);
				return true;
			}
			i++;
		}
		return false;
	};
	Array.prototype.iterator = function() {
		return { cur : 0, arr : this, hasNext : function() {
			return this.cur < this.arr.length;
		}, next : function() {
			return this.arr[this.cur++];
		}};
	};
	if(String.prototype.cca == null) String.prototype.cca = String.prototype.charCodeAt;
	String.prototype.charCodeAt = function(i) {
		var x = this.cca(i);
		if(x != x) return undefined;
		return x;
	};
	var oldsub = String.prototype.substr;
	String.prototype.substr = function(pos,len) {
		if(pos != null && pos != 0 && len != null && len < 0) return "";
		if(len == null) len = this.length;
		if(pos < 0) {
			pos = this.length + pos;
			if(pos < 0) pos = 0;
		} else if(len < 0) len = this.length + len - pos;
		return oldsub.apply(this,[pos,len]);
	};
	Function.prototype["$bind"] = function(o) {
		var f = function() {
			return f.method.apply(f.scope,arguments);
		};
		f.scope = o;
		f.method = this;
		return f;
	};
}
js.Boot.prototype = {
	__class__: js.Boot
}
js.Lib = $hxClasses["js.Lib"] = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
js.Lib.prototype = {
	__class__: js.Lib
}
if(!m.data) m.data = {}
m.data.Dictionary = $hxClasses["m.data.Dictionary"] = function(weakKeys) {
	if(weakKeys == null) weakKeys = false;
	this._keys = [];
	this._values = [];
};
m.data.Dictionary.__name__ = ["m","data","Dictionary"];
m.data.Dictionary.prototype = {
	_keys: null
	,_values: null
	,set: function(key,value) {
		var _g1 = 0, _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._keys[i] == key) {
				this._keys[i] = key;
				this._values[i] = value;
				return;
			}
		}
		this._keys.push(key);
		this._values.push(value);
	}
	,get: function(key) {
		var _g1 = 0, _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._keys[i] == key) return this._values[i];
		}
		return null;
	}
	,'delete': function(key) {
		var _g1 = 0, _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._keys[i] == key) {
				this._keys.splice(i,1);
				this._values.splice(i,1);
				return;
			}
		}
	}
	,exists: function(key) {
		return this.get(key) != null;
	}
	,keys: function() {
		return this._keys;
	}
	,iterator: function() {
		return this._keys.iterator();
	}
	,__class__: m.data.Dictionary
}
if(!m.exception) m.exception = {}
m.exception.Exception = $hxClasses["m.exception.Exception"] = function(message,cause,info) {
	if(message == null) message = "";
	this.name = Type.getClassName(Type.getClass(this));
	this.message = message;
	this.cause = cause;
	this.info = info;
};
m.exception.Exception.__name__ = ["m","exception","Exception"];
m.exception.Exception.getStackTrace = function(source) {
	var s = "";
	if(s != "") return s;
	var stack = haxe.Stack.exceptionStack();
	while(stack.length > 0) {
		var $e = (stack.shift());
		switch( $e[1] ) {
		case 2:
			var line = $e[4], file = $e[3], item = $e[2];
			s += "\tat " + file + " (" + line + ")\n";
			break;
		case 1:
			var module = $e[2];
			break;
		case 3:
			var method = $e[3], classname = $e[2];
			s += "\tat " + classname + "#" + method + "\n";
			break;
		case 4:
			var value = $e[2];
			break;
		case 0:
			break;
		}
	}
	return s;
}
m.exception.Exception.prototype = {
	name: null
	,get_name: function() {
		return this.name;
	}
	,message: null
	,get_message: function() {
		return this.message;
	}
	,cause: null
	,info: null
	,toString: function() {
		var str = this.get_name() + ": " + this.get_message();
		if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
		if(this.cause != null) str += "\n\t Caused by: " + m.exception.Exception.getStackTrace(this.cause);
		return str;
	}
	,__class__: m.exception.Exception
	,__properties__: {get_message:"get_message",get_name:"get_name"}
}
m.exception.ArgumentException = $hxClasses["m.exception.ArgumentException"] = function(message,cause,info) {
	if(message == null) message = "";
	m.exception.Exception.call(this,message,cause,info);
};
m.exception.ArgumentException.__name__ = ["m","exception","ArgumentException"];
m.exception.ArgumentException.__super__ = m.exception.Exception;
m.exception.ArgumentException.prototype = $extend(m.exception.Exception.prototype,{
	__class__: m.exception.ArgumentException
});
m.exception.IllegalOperationException = $hxClasses["m.exception.IllegalOperationException"] = function(message,cause,info) {
	if(message == null) message = "";
	m.exception.Exception.call(this,message,cause,info);
};
m.exception.IllegalOperationException.__name__ = ["m","exception","IllegalOperationException"];
m.exception.IllegalOperationException.__super__ = m.exception.Exception;
m.exception.IllegalOperationException.prototype = $extend(m.exception.Exception.prototype,{
	__class__: m.exception.IllegalOperationException
});
if(!m.inject) m.inject = {}
m.inject.IInjector = $hxClasses["m.inject.IInjector"] = function() { }
m.inject.IInjector.__name__ = ["m","inject","IInjector"];
m.inject.IInjector.prototype = {
	mapValue: null
	,mapClass: null
	,mapSingleton: null
	,mapSingletonOf: null
	,mapRule: null
	,injectInto: null
	,instantiate: null
	,getInstance: null
	,createChildInjector: null
	,unmap: null
	,hasMapping: null
	,__class__: m.inject.IInjector
}
m.inject.IReflector = $hxClasses["m.inject.IReflector"] = function() { }
m.inject.IReflector.__name__ = ["m","inject","IReflector"];
m.inject.IReflector.prototype = {
	classExtendsOrImplements: null
	,getClass: null
	,getFQCN: null
	,__class__: m.inject.IReflector
}
m.inject.InjectionConfig = $hxClasses["m.inject.InjectionConfig"] = function(request,injectionName) {
	this.request = request;
	this.injectionName = injectionName;
};
m.inject.InjectionConfig.__name__ = ["m","inject","InjectionConfig"];
m.inject.InjectionConfig.prototype = {
	request: null
	,injectionName: null
	,injector: null
	,result: null
	,getResponse: function(injector) {
		if(this.injector != null) injector = this.injector;
		if(this.result != null) return this.result.getResponse(injector);
		var parentConfig = injector.getAncestorMapping(this.request,this.injectionName);
		if(parentConfig != null) return parentConfig.getResponse(injector);
		return null;
	}
	,hasResponse: function(injector) {
		return this.result != null;
	}
	,hasOwnResponse: function() {
		return this.result != null;
	}
	,setResult: function(result) {
		if(this.result != null && result != null) haxe.Log.trace("Warning: Injector already has a rule for type \"" + Type.getClassName(this.request) + "\", named \"" + this.injectionName + "\".\nIf you have overwritten this mapping intentionally " + "you can use \"injector.unmap()\" prior to your replacement " + "mapping in order to avoid seeing this message.",{ fileName : "InjectionConfig.hx", lineNumber : 52, className : "m.inject.InjectionConfig", methodName : "setResult"});
		this.result = result;
	}
	,setInjector: function(injector) {
		this.injector = injector;
	}
	,__class__: m.inject.InjectionConfig
}
m.inject.Injector = $hxClasses["m.inject.Injector"] = function() {
	this.m_mappings = new Hash();
	this.m_injecteeDescriptions = new m.inject.ClassHash();
	this.attendedToInjectees = new m.data.Dictionary();
};
m.inject.Injector.__name__ = ["m","inject","Injector"];
m.inject.Injector.__interfaces__ = [m.inject.IInjector];
m.inject.Injector.prototype = {
	attendedToInjectees: null
	,parentInjector: null
	,m_parentInjector: null
	,m_mappings: null
	,m_injecteeDescriptions: null
	,mapValue: function(whenAskedFor,useValue,named) {
		if(named == null) named = "";
		var config = this.getMapping(whenAskedFor,named);
		config.setResult(new m.inject.injectionresults.InjectValueResult(useValue));
		return config;
	}
	,mapClass: function(whenAskedFor,instantiateClass,named) {
		if(named == null) named = "";
		var config = this.getMapping(whenAskedFor,named);
		config.setResult(new m.inject.injectionresults.InjectClassResult(instantiateClass));
		return config;
	}
	,mapSingleton: function(whenAskedFor,named) {
		if(named == null) named = "";
		return this.mapSingletonOf(whenAskedFor,whenAskedFor,named);
	}
	,mapSingletonOf: function(whenAskedFor,useSingletonOf,named) {
		if(named == null) named = "";
		var config = this.getMapping(whenAskedFor,named);
		config.setResult(new m.inject.injectionresults.InjectSingletonResult(useSingletonOf));
		return config;
	}
	,mapRule: function(whenAskedFor,useRule,named) {
		if(named == null) named = "";
		var config = this.getMapping(whenAskedFor,named);
		config.setResult(new m.inject.injectionresults.InjectOtherRuleResult(useRule));
		return useRule;
	}
	,getClassName: function(forClass) {
		if(forClass == null) return "Dynamic"; else return Type.getClassName(forClass);
	}
	,getMapping: function(forClass,named) {
		if(named == null) named = "";
		var requestName = this.getClassName(forClass) + "#" + named;
		if(this.m_mappings.exists(requestName)) return this.m_mappings.get(requestName);
		var config = new m.inject.InjectionConfig(forClass,named);
		this.m_mappings.set(requestName,config);
		return config;
	}
	,injectInto: function(target) {
		if(this.attendedToInjectees.exists(target)) return;
		this.attendedToInjectees.set(target,true);
		var targetClass = Type.getClass(target);
		var injecteeDescription = null;
		if(this.m_injecteeDescriptions.exists(targetClass)) injecteeDescription = this.m_injecteeDescriptions.get(targetClass); else injecteeDescription = this.getInjectionPoints(targetClass);
		if(injecteeDescription == null) return;
		var injectionPoints = injecteeDescription.injectionPoints;
		var length = injectionPoints.length;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var injectionPoint = injectionPoints[i];
			injectionPoint.applyInjection(target,this);
		}
	}
	,instantiate: function(forClass) {
		var injecteeDescription;
		if(this.m_injecteeDescriptions.exists(forClass)) injecteeDescription = this.m_injecteeDescriptions.get(forClass); else injecteeDescription = this.getInjectionPoints(forClass);
		var injectionPoint = injecteeDescription.ctor;
		var instance = injectionPoint.applyInjection(forClass,this);
		this.injectInto(instance);
		return instance;
	}
	,unmap: function(theClass,named) {
		if(named == null) named = "";
		var mapping = this.getConfigurationForRequest(theClass,named);
		if(mapping == null) throw new m.inject.InjectorException("Error while removing an injector mapping: No mapping defined for class " + this.getClassName(theClass) + ", named \"" + named + "\"");
		mapping.setResult(null);
	}
	,hasMapping: function(forClass,named) {
		if(named == null) named = "";
		var mapping = this.getConfigurationForRequest(forClass,named);
		if(mapping == null) return false;
		return mapping.hasResponse(this);
	}
	,getInstance: function(ofClass,named) {
		if(named == null) named = "";
		var mapping = this.getConfigurationForRequest(ofClass,named);
		if(mapping == null || !mapping.hasResponse(this)) throw new m.inject.InjectorException("Error while getting mapping response: No mapping defined for class " + this.getClassName(ofClass) + ", named \"" + named + "\"");
		return mapping.getResponse(this);
	}
	,getInjectionPoints: function(forClass) {
		var typeMeta = haxe.rtti.Meta.getType(forClass);
		if(typeMeta != null && Reflect.hasField(typeMeta,"interface")) throw new m.inject.InjectorException("Interfaces can't be used as instantiatable classes.");
		var fieldsMeta = this.getFields(forClass);
		var ctorInjectionPoint = null;
		var injectionPoints = [];
		var postConstructMethodPoints = [];
		var _g = 0, _g1 = Reflect.fields(fieldsMeta);
		while(_g < _g1.length) {
			var field = _g1[_g];
			++_g;
			var fieldMeta = Reflect.field(fieldsMeta,field);
			var inject = Reflect.hasField(fieldMeta,"inject");
			var post = Reflect.hasField(fieldMeta,"post");
			var type = Reflect.field(fieldMeta,"type");
			var args = Reflect.field(fieldMeta,"args");
			if(field == "_") {
				if(args.length > 0) ctorInjectionPoint = new m.inject.injectionpoints.ConstructorInjectionPoint(fieldMeta,forClass,this);
			} else if(Reflect.hasField(fieldMeta,"args")) {
				if(inject) {
					var injectionPoint = new m.inject.injectionpoints.MethodInjectionPoint(fieldMeta,this);
					injectionPoints.push(injectionPoint);
				} else if(post) {
					var injectionPoint = new m.inject.injectionpoints.PostConstructInjectionPoint(fieldMeta,this);
					postConstructMethodPoints.push(injectionPoint);
				}
			} else if(type != null) {
				var injectionPoint = new m.inject.injectionpoints.PropertyInjectionPoint(fieldMeta,this);
				injectionPoints.push(injectionPoint);
			}
		}
		if(postConstructMethodPoints.length > 0) {
			postConstructMethodPoints.sort(function(a,b) {
				return a.order - b.order;
			});
			var _g = 0;
			while(_g < postConstructMethodPoints.length) {
				var point = postConstructMethodPoints[_g];
				++_g;
				injectionPoints.push(point);
			}
		}
		if(ctorInjectionPoint == null) ctorInjectionPoint = new m.inject.injectionpoints.NoParamsConstructorInjectionPoint();
		var injecteeDescription = new m.inject.InjecteeDescription(ctorInjectionPoint,injectionPoints);
		this.m_injecteeDescriptions.set(forClass,injecteeDescription);
		return injecteeDescription;
	}
	,getConfigurationForRequest: function(forClass,named,traverseAncestors) {
		if(traverseAncestors == null) traverseAncestors = true;
		var requestName = this.getClassName(forClass) + "#" + named;
		if(!this.m_mappings.exists(requestName)) {
			if(traverseAncestors && this.parentInjector != null && this.parentInjector.hasMapping(forClass,named)) return this.getAncestorMapping(forClass,named);
			return null;
		}
		return this.m_mappings.get(requestName);
	}
	,set_parentInjector: function(value) {
		if(this.parentInjector != null && value == null) this.attendedToInjectees = new m.data.Dictionary();
		this.parentInjector = value;
		if(this.parentInjector != null) this.attendedToInjectees = this.parentInjector.attendedToInjectees;
		return this.parentInjector;
	}
	,createChildInjector: function() {
		var injector = new m.inject.Injector();
		injector.set_parentInjector(this);
		return injector;
	}
	,getAncestorMapping: function(forClass,named) {
		var parent = this.parentInjector;
		while(parent != null) {
			var parentConfig = parent.getConfigurationForRequest(forClass,named,false);
			if(parentConfig != null && parentConfig.hasOwnResponse()) return parentConfig;
			parent = parent.parentInjector;
		}
		return null;
	}
	,getFields: function(type) {
		var meta = { };
		while(type != null) {
			var typeMeta = haxe.rtti.Meta.getFields(type);
			var _g = 0, _g1 = Reflect.fields(typeMeta);
			while(_g < _g1.length) {
				var field = _g1[_g];
				++_g;
				meta[field] = Reflect.field(typeMeta,field);
			}
			type = Type.getSuperClass(type);
		}
		return meta;
	}
	,__class__: m.inject.Injector
	,__properties__: {set_parentInjector:"set_parentInjector"}
}
m.inject.ClassHash = $hxClasses["m.inject.ClassHash"] = function() {
	this.hash = new Hash();
};
m.inject.ClassHash.__name__ = ["m","inject","ClassHash"];
m.inject.ClassHash.prototype = {
	hash: null
	,set: function(key,value) {
		this.hash.set(Type.getClassName(key),value);
	}
	,get: function(key) {
		return this.hash.get(Type.getClassName(key));
	}
	,exists: function(key) {
		return this.hash.exists(Type.getClassName(key));
	}
	,__class__: m.inject.ClassHash
}
m.inject.InjecteeDescription = $hxClasses["m.inject.InjecteeDescription"] = function(ctor,injectionPoints) {
	this.ctor = ctor;
	this.injectionPoints = injectionPoints;
};
m.inject.InjecteeDescription.__name__ = ["m","inject","InjecteeDescription"];
m.inject.InjecteeDescription.prototype = {
	ctor: null
	,injectionPoints: null
	,__class__: m.inject.InjecteeDescription
}
m.inject.InjectorException = $hxClasses["m.inject.InjectorException"] = function(message) {
	m.exception.Exception.call(this,message,null,{ fileName : "Injector.hx", lineNumber : 397, className : "m.inject.InjectorException", methodName : "new"});
};
m.inject.InjectorException.__name__ = ["m","inject","InjectorException"];
m.inject.InjectorException.__super__ = m.exception.Exception;
m.inject.InjectorException.prototype = $extend(m.exception.Exception.prototype,{
	__class__: m.inject.InjectorException
});
m.inject.Reflector = $hxClasses["m.inject.Reflector"] = function() {
};
m.inject.Reflector.__name__ = ["m","inject","Reflector"];
m.inject.Reflector.__interfaces__ = [m.inject.IReflector];
m.inject.Reflector.prototype = {
	classExtendsOrImplements: function(classOrClassName,superClass) {
		var actualClass = null;
		if(Std["is"](classOrClassName,Class)) actualClass = (function($this) {
			var $r;
			var $t = classOrClassName;
			if(Std["is"]($t,Class)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this)); else if(Std["is"](classOrClassName,String)) try {
			actualClass = Type.resolveClass((function($this) {
				var $r;
				var $t = classOrClassName;
				if(Std["is"]($t,String)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this)));
		} catch( e ) {
			throw "The class name " + classOrClassName + " is not valid because of " + e + "\n" + e.getStackTrace();
		}
		if(actualClass == null) throw "The parameter classOrClassName must be a Class or fully qualified class name.";
		var classInstance = Type.createEmptyInstance(actualClass);
		return Std["is"](classInstance,superClass);
	}
	,getClass: function(value) {
		if(Std["is"](value,Class)) return value;
		return Type.getClass(value);
	}
	,getFQCN: function(value) {
		var fqcn;
		if(Std["is"](value,String)) return (function($this) {
			var $r;
			var $t = value;
			if(Std["is"]($t,String)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
		return Type.getClassName(value);
	}
	,__class__: m.inject.Reflector
}
if(!m.inject.injectionpoints) m.inject.injectionpoints = {}
m.inject.injectionpoints.InjectionPoint = $hxClasses["m.inject.injectionpoints.InjectionPoint"] = function(meta,injector) {
	this.initializeInjection(meta);
};
m.inject.injectionpoints.InjectionPoint.__name__ = ["m","inject","injectionpoints","InjectionPoint"];
m.inject.injectionpoints.InjectionPoint.prototype = {
	applyInjection: function(target,injector) {
		return target;
	}
	,initializeInjection: function(meta) {
	}
	,__class__: m.inject.injectionpoints.InjectionPoint
}
m.inject.injectionpoints.MethodInjectionPoint = $hxClasses["m.inject.injectionpoints.MethodInjectionPoint"] = function(meta,injector) {
	this.requiredParameters = 0;
	m.inject.injectionpoints.InjectionPoint.call(this,meta,injector);
};
m.inject.injectionpoints.MethodInjectionPoint.__name__ = ["m","inject","injectionpoints","MethodInjectionPoint"];
m.inject.injectionpoints.MethodInjectionPoint.__super__ = m.inject.injectionpoints.InjectionPoint;
m.inject.injectionpoints.MethodInjectionPoint.prototype = $extend(m.inject.injectionpoints.InjectionPoint.prototype,{
	methodName: null
	,_parameterInjectionConfigs: null
	,requiredParameters: null
	,applyInjection: function(target,injector) {
		var parameters = this.gatherParameterValues(target,injector);
		var method = Reflect.field(target,this.methodName);
		m.util.ReflectUtil.callMethod(target,method,parameters);
		return target;
	}
	,initializeInjection: function(meta) {
		this.methodName = meta.name[0];
		this.gatherParameters(meta);
	}
	,gatherParameters: function(meta) {
		var nameArgs = meta.inject;
		var args = meta.args;
		if(nameArgs == null) nameArgs = [];
		this._parameterInjectionConfigs = [];
		var i = 0;
		var _g = 0;
		while(_g < args.length) {
			var arg = args[_g];
			++_g;
			var injectionName = "";
			if(i < nameArgs.length) injectionName = nameArgs[i];
			var parameterTypeName = arg.type;
			if(arg.opt) {
				if(parameterTypeName == "Dynamic") throw new m.inject.InjectorException("Error in method definition of injectee. Required parameters can't have non class type.");
			} else this.requiredParameters++;
			this._parameterInjectionConfigs.push(new m.inject.injectionpoints.ParameterInjectionConfig(parameterTypeName,injectionName));
			i++;
		}
	}
	,gatherParameterValues: function(target,injector) {
		var parameters = [];
		var length = this._parameterInjectionConfigs.length;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var parameterConfig = this._parameterInjectionConfigs[i];
			var config = injector.getMapping(Type.resolveClass(parameterConfig.typeName),parameterConfig.injectionName);
			var injection = config.getResponse(injector);
			if(injection == null) {
				if(i >= this.requiredParameters) break;
				throw new m.inject.InjectorException("Injector is missing a rule to handle injection into target " + Type.getClassName(Type.getClass(target)) + ". Target dependency: " + Type.getClassName(config.request) + ", method: " + this.methodName + ", parameter: " + (i + 1) + ", named: " + parameterConfig.injectionName);
			}
			parameters[i] = injection;
		}
		return parameters;
	}
	,__class__: m.inject.injectionpoints.MethodInjectionPoint
});
m.inject.injectionpoints.ConstructorInjectionPoint = $hxClasses["m.inject.injectionpoints.ConstructorInjectionPoint"] = function(meta,forClass,injector) {
	m.inject.injectionpoints.MethodInjectionPoint.call(this,meta,injector);
};
m.inject.injectionpoints.ConstructorInjectionPoint.__name__ = ["m","inject","injectionpoints","ConstructorInjectionPoint"];
m.inject.injectionpoints.ConstructorInjectionPoint.__super__ = m.inject.injectionpoints.MethodInjectionPoint;
m.inject.injectionpoints.ConstructorInjectionPoint.prototype = $extend(m.inject.injectionpoints.MethodInjectionPoint.prototype,{
	applyInjection: function(target,injector) {
		var ofClass = target;
		var withArgs = this.gatherParameterValues(target,injector);
		return m.util.TypeUtil.createInstance(ofClass,withArgs);
	}
	,initializeInjection: function(meta) {
		this.methodName = "new";
		this.gatherParameters(meta);
	}
	,__class__: m.inject.injectionpoints.ConstructorInjectionPoint
});
m.inject.injectionpoints.ParameterInjectionConfig = $hxClasses["m.inject.injectionpoints.ParameterInjectionConfig"] = function(typeName,injectionName) {
	this.typeName = typeName;
	this.injectionName = injectionName;
};
m.inject.injectionpoints.ParameterInjectionConfig.__name__ = ["m","inject","injectionpoints","ParameterInjectionConfig"];
m.inject.injectionpoints.ParameterInjectionConfig.prototype = {
	typeName: null
	,injectionName: null
	,__class__: m.inject.injectionpoints.ParameterInjectionConfig
}
m.inject.injectionpoints.NoParamsConstructorInjectionPoint = $hxClasses["m.inject.injectionpoints.NoParamsConstructorInjectionPoint"] = function() {
	m.inject.injectionpoints.InjectionPoint.call(this,null,null);
};
m.inject.injectionpoints.NoParamsConstructorInjectionPoint.__name__ = ["m","inject","injectionpoints","NoParamsConstructorInjectionPoint"];
m.inject.injectionpoints.NoParamsConstructorInjectionPoint.__super__ = m.inject.injectionpoints.InjectionPoint;
m.inject.injectionpoints.NoParamsConstructorInjectionPoint.prototype = $extend(m.inject.injectionpoints.InjectionPoint.prototype,{
	applyInjection: function(target,injector) {
		return m.util.TypeUtil.createInstance(target,[]);
	}
	,__class__: m.inject.injectionpoints.NoParamsConstructorInjectionPoint
});
m.inject.injectionpoints.PostConstructInjectionPoint = $hxClasses["m.inject.injectionpoints.PostConstructInjectionPoint"] = function(meta,injector) {
	this.order = 0;
	m.inject.injectionpoints.InjectionPoint.call(this,meta,injector);
};
m.inject.injectionpoints.PostConstructInjectionPoint.__name__ = ["m","inject","injectionpoints","PostConstructInjectionPoint"];
m.inject.injectionpoints.PostConstructInjectionPoint.__super__ = m.inject.injectionpoints.InjectionPoint;
m.inject.injectionpoints.PostConstructInjectionPoint.prototype = $extend(m.inject.injectionpoints.InjectionPoint.prototype,{
	order: null
	,methodName: null
	,applyInjection: function(target,injector) {
		m.util.ReflectUtil.callMethod(target,Reflect.field(target,this.methodName),[]);
		return target;
	}
	,initializeInjection: function(meta) {
		this.methodName = meta.name[0];
		if(meta.post != null) this.order = meta.post[0];
	}
	,__class__: m.inject.injectionpoints.PostConstructInjectionPoint
});
m.inject.injectionpoints.PropertyInjectionPoint = $hxClasses["m.inject.injectionpoints.PropertyInjectionPoint"] = function(meta,injector) {
	m.inject.injectionpoints.InjectionPoint.call(this,meta,null);
};
m.inject.injectionpoints.PropertyInjectionPoint.__name__ = ["m","inject","injectionpoints","PropertyInjectionPoint"];
m.inject.injectionpoints.PropertyInjectionPoint.__super__ = m.inject.injectionpoints.InjectionPoint;
m.inject.injectionpoints.PropertyInjectionPoint.prototype = $extend(m.inject.injectionpoints.InjectionPoint.prototype,{
	propertyName: null
	,propertyType: null
	,injectionName: null
	,hasSetter: null
	,applyInjection: function(target,injector) {
		var injectionConfig = injector.getMapping(Type.resolveClass(this.propertyType),this.injectionName);
		var injection = injectionConfig.getResponse(injector);
		if(injection == null) throw new m.inject.InjectorException("Injector is missing a rule to handle injection into property \"" + this.propertyName + "\" of object \"" + target + "\". Target dependency: \"" + this.propertyType + "\", named \"" + this.injectionName + "\"");
		if(this.hasSetter) {
			var setter = Reflect.field(target,this.propertyName);
			m.util.ReflectUtil.callMethod(target,setter,[injection]);
		} else target[this.propertyName] = injection;
		return target;
	}
	,initializeInjection: function(meta) {
		this.propertyType = meta.type[0];
		this.hasSetter = meta.setter != null;
		if(this.hasSetter) this.propertyName = meta.setter[0]; else this.propertyName = meta.name[0];
		if(meta.inject == null) this.injectionName = ""; else this.injectionName = meta.inject[0];
	}
	,__class__: m.inject.injectionpoints.PropertyInjectionPoint
});
if(!m.inject.injectionresults) m.inject.injectionresults = {}
m.inject.injectionresults.InjectionResult = $hxClasses["m.inject.injectionresults.InjectionResult"] = function() {
};
m.inject.injectionresults.InjectionResult.__name__ = ["m","inject","injectionresults","InjectionResult"];
m.inject.injectionresults.InjectionResult.prototype = {
	getResponse: function(injector) {
		return null;
	}
	,__class__: m.inject.injectionresults.InjectionResult
}
m.inject.injectionresults.InjectClassResult = $hxClasses["m.inject.injectionresults.InjectClassResult"] = function(responseType) {
	m.inject.injectionresults.InjectionResult.call(this);
	this.responseType = responseType;
};
m.inject.injectionresults.InjectClassResult.__name__ = ["m","inject","injectionresults","InjectClassResult"];
m.inject.injectionresults.InjectClassResult.__super__ = m.inject.injectionresults.InjectionResult;
m.inject.injectionresults.InjectClassResult.prototype = $extend(m.inject.injectionresults.InjectionResult.prototype,{
	responseType: null
	,getResponse: function(injector) {
		return injector.instantiate(this.responseType);
	}
	,__class__: m.inject.injectionresults.InjectClassResult
});
m.inject.injectionresults.InjectOtherRuleResult = $hxClasses["m.inject.injectionresults.InjectOtherRuleResult"] = function(rule) {
	m.inject.injectionresults.InjectionResult.call(this);
	this.rule = rule;
};
m.inject.injectionresults.InjectOtherRuleResult.__name__ = ["m","inject","injectionresults","InjectOtherRuleResult"];
m.inject.injectionresults.InjectOtherRuleResult.__super__ = m.inject.injectionresults.InjectionResult;
m.inject.injectionresults.InjectOtherRuleResult.prototype = $extend(m.inject.injectionresults.InjectionResult.prototype,{
	rule: null
	,getResponse: function(injector) {
		return this.rule.getResponse(injector);
	}
	,__class__: m.inject.injectionresults.InjectOtherRuleResult
});
m.inject.injectionresults.InjectSingletonResult = $hxClasses["m.inject.injectionresults.InjectSingletonResult"] = function(responseType) {
	m.inject.injectionresults.InjectionResult.call(this);
	this.responseType = responseType;
};
m.inject.injectionresults.InjectSingletonResult.__name__ = ["m","inject","injectionresults","InjectSingletonResult"];
m.inject.injectionresults.InjectSingletonResult.__super__ = m.inject.injectionresults.InjectionResult;
m.inject.injectionresults.InjectSingletonResult.prototype = $extend(m.inject.injectionresults.InjectionResult.prototype,{
	responseType: null
	,response: null
	,getResponse: function(injector) {
		if(this.response == null) this.response = this.createResponse(injector);
		return this.response;
	}
	,createResponse: function(injector) {
		return injector.instantiate(this.responseType);
	}
	,__class__: m.inject.injectionresults.InjectSingletonResult
});
m.inject.injectionresults.InjectValueResult = $hxClasses["m.inject.injectionresults.InjectValueResult"] = function(value) {
	m.inject.injectionresults.InjectionResult.call(this);
	this.value = value;
};
m.inject.injectionresults.InjectValueResult.__name__ = ["m","inject","injectionresults","InjectValueResult"];
m.inject.injectionresults.InjectValueResult.__super__ = m.inject.injectionresults.InjectionResult;
m.inject.injectionresults.InjectValueResult.prototype = $extend(m.inject.injectionresults.InjectionResult.prototype,{
	value: null
	,getResponse: function(injector) {
		return this.value;
	}
	,__class__: m.inject.injectionresults.InjectValueResult
});
if(!m.loader) m.loader = {}
m.loader.Loader = $hxClasses["m.loader.Loader"] = function() { }
m.loader.Loader.__name__ = ["m","loader","Loader"];
m.loader.Loader.prototype = {
	uri: null
	,progress: null
	,statusCode: null
	,progressed: null
	,completed: null
	,failed: null
	,load: null
	,cancel: null
	,__class__: m.loader.Loader
}
m.loader.LoaderBase = $hxClasses["m.loader.LoaderBase"] = function() {
	this.progressed = new m.signal.Signal1(Float);
	this.completed = new m.signal.Signal1(null);
	this.failed = new m.signal.Signal1(m.loader.LoaderError);
	this.cancelled = new m.signal.Signal0();
	this.statusCode = 0;
};
m.loader.LoaderBase.__name__ = ["m","loader","LoaderBase"];
m.loader.LoaderBase.__interfaces__ = [m.loader.Loader];
m.loader.LoaderBase.prototype = {
	uri: null
	,asset: null
	,progress: null
	,statusCode: null
	,progressed: null
	,completed: null
	,failed: null
	,cancelled: null
	,load: function(uri) {
		if(uri == null) throw new m.exception.ArgumentException(null,null,{ fileName : "LoaderBase.hx", lineNumber : 65, className : "m.loader.LoaderBase", methodName : "load"});
	}
	,cancel: function() {
	}
	,__class__: m.loader.LoaderBase
}
m.loader.HTTPLoader = $hxClasses["m.loader.HTTPLoader"] = function(http) {
	m.loader.LoaderBase.call(this);
	if(http == null) http = new haxe.Http("");
	this.http = http;
	http.onData = this.httpData.$bind(this);
	http.onError = this.httpError.$bind(this);
	http.onStatus = this.httpStatus.$bind(this);
	this.headers = new Hash();
};
m.loader.HTTPLoader.__name__ = ["m","loader","HTTPLoader"];
m.loader.HTTPLoader.__super__ = m.loader.LoaderBase;
m.loader.HTTPLoader.prototype = $extend(m.loader.LoaderBase.prototype,{
	headers: null
	,http: null
	,load: function(uri) {
		m.loader.LoaderBase.prototype.load.call(this,uri);
		this.uri = uri;
		this.http.url = uri;
		this.httpConfigure();
		this.addHeaders();
		this.progressed.dispatch(0);
		try {
			this.http.request(false);
		} catch( e ) {
			this.failed.dispatch(m.loader.LoaderError.SecurityError(Std.string(e)));
		}
	}
	,send: function(uri,data) {
		if(uri == null) throw new m.exception.ArgumentException(null,null,{ fileName : "HTTPLoader.hx", lineNumber : 129, className : "m.loader.HTTPLoader", methodName : "send"});
		this.uri = uri;
		if(!this.headers.exists("Content-Type")) {
			var contentType = this.getMIMEType(data);
			this.headers.set("Content-Type",contentType);
		}
		this.http.url = uri;
		this.http.setPostData(Std.string(data));
		this.httpConfigure();
		this.addHeaders();
		this.progressed.dispatch(0);
		try {
			this.http.request(true);
		} catch( e ) {
			this.failed.dispatch(m.loader.LoaderError.SecurityError(Std.string(e)));
		}
	}
	,getMIMEType: function(data) {
		if(Std["is"](data,Xml)) return "application/xml";
		return "application/octet-stream";
	}
	,cancel: function() {
		m.loader.LoaderBase.prototype.cancel.call(this);
		this.http.cancel();
		this.cancelled.dispatch();
	}
	,httpConfigure: function() {
	}
	,addHeaders: function() {
		var $it0 = this.headers.keys();
		while( $it0.hasNext() ) {
			var name = $it0.next();
			this.http.setHeader(name,this.headers.get(name));
		}
	}
	,httpData: function(data) {
		this.progressed.dispatch(1);
		this.completed.dispatch(data);
	}
	,httpStatus: function(status) {
		this.statusCode = status;
	}
	,httpError: function(error) {
		this.failed.dispatch(m.loader.LoaderError.IOError(error));
	}
	,__class__: m.loader.HTTPLoader
});
m.loader.JSONLoader = $hxClasses["m.loader.JSONLoader"] = function(http) {
	m.loader.HTTPLoader.call(this,http);
};
m.loader.JSONLoader.__name__ = ["m","loader","JSONLoader"];
m.loader.JSONLoader.__super__ = m.loader.HTTPLoader;
m.loader.JSONLoader.prototype = $extend(m.loader.HTTPLoader.prototype,{
	httpData: function(data) {
		this.progressed.dispatch(1);
		try {
			var json = haxe.Json.parse(data);
			this.completed.dispatch(json);
		} catch( e ) {
			this.failed.dispatch(m.loader.LoaderError.FormatError(Std.string(e)));
			return;
		}
	}
	,send: function(uri,data) {
		if(uri == null) throw new m.exception.ArgumentException(null,null,{ fileName : "JSONLoader.hx", lineNumber : 58, className : "m.loader.JSONLoader", methodName : "send"});
		try {
			if(!Std["is"](data,String)) data = haxe.Json.stringify(data);
			if(!this.headers.exists("Content-Type")) this.headers.set("Content-Type","application/json");
			m.loader.HTTPLoader.prototype.send.call(this,uri,data);
		} catch( e ) {
			this.failed.dispatch(m.loader.LoaderError.FormatError(Std.string(e)));
		}
	}
	,__class__: m.loader.JSONLoader
});
m.loader.LoaderError = $hxClasses["m.loader.LoaderError"] = { __ename__ : ["m","loader","LoaderError"], __constructs__ : ["IOError","SecurityError","FormatError","DataError"] }
m.loader.LoaderError.IOError = function(info) { var $x = ["IOError",0,info]; $x.__enum__ = m.loader.LoaderError; $x.toString = $estr; return $x; }
m.loader.LoaderError.SecurityError = function(info) { var $x = ["SecurityError",1,info]; $x.__enum__ = m.loader.LoaderError; $x.toString = $estr; return $x; }
m.loader.LoaderError.FormatError = function(info) { var $x = ["FormatError",2,info]; $x.__enum__ = m.loader.LoaderError; $x.toString = $estr; return $x; }
m.loader.LoaderError.DataError = function(info,data) { var $x = ["DataError",3,info,data]; $x.__enum__ = m.loader.LoaderError; $x.toString = $estr; return $x; }
m.mvc.api.ICommandMap = $hxClasses["m.mvc.api.ICommandMap"] = function() { }
m.mvc.api.ICommandMap.__name__ = ["m","mvc","api","ICommandMap"];
m.mvc.api.ICommandMap.prototype = {
	mapSignal: null
	,mapSignalClass: null
	,hasSignalCommand: null
	,unmapSignal: null
	,unmapSignalClass: null
	,detain: null
	,release: null
	,__class__: m.mvc.api.ICommandMap
}
m.mvc.api.IMediatorMap = $hxClasses["m.mvc.api.IMediatorMap"] = function() { }
m.mvc.api.IMediatorMap.__name__ = ["m","mvc","api","IMediatorMap"];
m.mvc.api.IMediatorMap.prototype = {
	mapView: null
	,unmapView: null
	,createMediator: null
	,registerMediator: null
	,removeMediator: null
	,removeMediatorByView: null
	,retrieveMediator: null
	,hasMapping: null
	,hasMediator: null
	,hasMediatorForView: null
	,contextView: null
	,enabled: null
	,__class__: m.mvc.api.IMediatorMap
	,__properties__: {set_enabled:"set_enabled",set_contextView:"set_contextView"}
}
m.mvc.api.IViewMap = $hxClasses["m.mvc.api.IViewMap"] = function() { }
m.mvc.api.IViewMap.__name__ = ["m","mvc","api","IViewMap"];
m.mvc.api.IViewMap.prototype = {
	mapPackage: null
	,unmapPackage: null
	,hasPackage: null
	,mapType: null
	,unmapType: null
	,hasType: null
	,contextView: null
	,enabled: null
	,__class__: m.mvc.api.IViewMap
	,__properties__: {set_enabled:"set_enabled",set_contextView:"set_contextView"}
}
m.mvc.base.CommandMap = $hxClasses["m.mvc.base.CommandMap"] = function(injector) {
	this.injector = injector;
	this.signalMap = new m.data.Dictionary();
	this.signalClassMap = new m.data.Dictionary();
	this.detainedCommands = new m.data.Dictionary();
};
m.mvc.base.CommandMap.__name__ = ["m","mvc","base","CommandMap"];
m.mvc.base.CommandMap.__interfaces__ = [m.mvc.api.ICommandMap];
m.mvc.base.CommandMap.prototype = {
	injector: null
	,signalMap: null
	,signalClassMap: null
	,detainedCommands: null
	,mapSignal: function(signal,commandClass,oneShot) {
		if(oneShot == null) oneShot = false;
		if(this.hasSignalCommand(signal,commandClass)) return;
		var signalCommandMap;
		if(this.signalMap.exists(signal)) signalCommandMap = this.signalMap.get(signal); else {
			signalCommandMap = new m.data.Dictionary(false);
			this.signalMap.set(signal,signalCommandMap);
		}
		var me = this;
		var callbackFunction = Reflect.makeVarArgs(function(args) {
			me.routeSignalToCommand(signal,args,commandClass,oneShot);
		});
		signalCommandMap.set(commandClass,callbackFunction);
		signal.add(callbackFunction);
	}
	,mapSignalClass: function(signalClass,commandClass,oneShot) {
		if(oneShot == null) oneShot = false;
		var signal = this.getSignalClassInstance(signalClass);
		this.mapSignal(signal,commandClass,oneShot);
		return signal;
	}
	,unmapSignalClass: function(signalClass,commandClass) {
		this.unmapSignal(this.getSignalClassInstance(signalClass),commandClass);
		this.injector.unmap(signalClass);
	}
	,getSignalClassInstance: function(signalClass) {
		if(this.signalClassMap.exists(signalClass)) return (function($this) {
			var $r;
			var $t = $this.signalClassMap.get(signalClass);
			if(Std["is"]($t,m.signal.Signal)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this));
		var signal = this.createSignalClassInstance(signalClass);
		this.signalClassMap.set(signalClass,signal);
		return signal;
	}
	,createSignalClassInstance: function(signalClass) {
		var injectorForSignalInstance = this.injector;
		var signal;
		if(this.injector.hasMapping(m.inject.IInjector)) injectorForSignalInstance = this.injector.getInstance(m.inject.IInjector);
		signal = injectorForSignalInstance.instantiate(signalClass);
		injectorForSignalInstance.mapValue(signalClass,signal);
		this.signalClassMap.set(signalClass,signal);
		return signal;
	}
	,hasSignalCommand: function(signal,commandClass) {
		var callbacksByCommandClass = this.signalMap.get(signal);
		if(callbacksByCommandClass == null) return false;
		var callbackFunction = callbacksByCommandClass.get(commandClass);
		return callbackFunction != null;
	}
	,unmapSignal: function(signal,commandClass) {
		var callbacksByCommandClass = this.signalMap.get(signal);
		if(callbacksByCommandClass == null) return;
		var callbackFunction = callbacksByCommandClass.get(commandClass);
		if(callbackFunction == null) return;
		signal.remove(callbackFunction);
		callbacksByCommandClass["delete"](commandClass);
	}
	,routeSignalToCommand: function(signal,valueObjects,commandClass,oneshot) {
		this.mapSignalValues(signal.valueClasses,valueObjects);
		var command = this.createCommandInstance(commandClass);
		this.unmapSignalValues(signal.valueClasses,valueObjects);
		command.execute();
		if(oneshot) this.unmapSignal(signal,commandClass);
	}
	,createCommandInstance: function(commandClass) {
		return this.injector.instantiate(commandClass);
	}
	,mapSignalValues: function(valueClasses,valueObjects) {
		var _g1 = 0, _g = valueClasses.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.injector.mapValue(valueClasses[i],valueObjects[i]);
		}
	}
	,unmapSignalValues: function(valueClasses,valueObjects) {
		var _g1 = 0, _g = valueClasses.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.injector.unmap(valueClasses[i]);
		}
	}
	,detain: function(command) {
		this.detainedCommands.set(command,true);
	}
	,release: function(command) {
		if(this.detainedCommands.exists(command)) this.detainedCommands["delete"](command);
	}
	,__class__: m.mvc.base.CommandMap
}
m.mvc.base.ContextError = $hxClasses["m.mvc.base.ContextError"] = function(message,id) {
	if(id == null) id = 0;
	if(message == null) message = "";
	this.message = message;
	this.id = id;
};
m.mvc.base.ContextError.__name__ = ["m","mvc","base","ContextError"];
m.mvc.base.ContextError.prototype = {
	message: null
	,id: null
	,__class__: m.mvc.base.ContextError
}
m.mvc.base.ViewMapBase = $hxClasses["m.mvc.base.ViewMapBase"] = function(contextView,injector) {
	this.viewListenerCount = 0;
	this.set_enabled(true);
	this.injector = injector;
	this.set_contextView(contextView);
};
m.mvc.base.ViewMapBase.__name__ = ["m","mvc","base","ViewMapBase"];
m.mvc.base.ViewMapBase.prototype = {
	contextView: null
	,enabled: null
	,set_contextView: function(value) {
		if(value != this.contextView) {
			this.removeListeners();
			this.contextView = value;
			if(this.viewListenerCount > 0) this.addListeners();
		}
		return this.contextView;
	}
	,set_enabled: function(value) {
		if(value != this.enabled) {
			this.removeListeners();
			this.enabled = value;
			if(this.viewListenerCount > 0) this.addListeners();
		}
		return value;
	}
	,injector: null
	,viewListenerCount: null
	,addListeners: function() {
	}
	,removeListeners: function() {
	}
	,onViewAdded: function(view) {
	}
	,onViewRemoved: function(view) {
	}
	,__class__: m.mvc.base.ViewMapBase
	,__properties__: {set_enabled:"set_enabled",set_contextView:"set_contextView"}
}
m.mvc.base.MediatorMap = $hxClasses["m.mvc.base.MediatorMap"] = function(contextView,injector,reflector) {
	m.mvc.base.ViewMapBase.call(this,contextView,injector);
	this.reflector = reflector;
	this.mediatorByView = new m.data.Dictionary(true);
	this.mappingConfigByView = new m.data.Dictionary(true);
	this.mappingConfigByViewClassName = new m.data.Dictionary();
	this.mediatorsMarkedForRemoval = new m.data.Dictionary();
	this.hasMediatorsMarkedForRemoval = false;
};
m.mvc.base.MediatorMap.__name__ = ["m","mvc","base","MediatorMap"];
m.mvc.base.MediatorMap.__interfaces__ = [m.mvc.api.IMediatorMap];
m.mvc.base.MediatorMap.__super__ = m.mvc.base.ViewMapBase;
m.mvc.base.MediatorMap.prototype = $extend(m.mvc.base.ViewMapBase.prototype,{
	mediatorByView: null
	,mappingConfigByView: null
	,mappingConfigByViewClassName: null
	,mediatorsMarkedForRemoval: null
	,hasMediatorsMarkedForRemoval: null
	,reflector: null
	,mapView: function(viewClassOrName,mediatorClass,injectViewAs,autoCreate,autoRemove) {
		if(autoRemove == null) autoRemove = true;
		if(autoCreate == null) autoCreate = true;
		var viewClassName = this.reflector.getFQCN(viewClassOrName);
		if(this.mappingConfigByViewClassName.get(viewClassName) != null) throw new m.mvc.base.ContextError(m.mvc.base.ContextError.E_MEDIATORMAP_OVR + " - " + mediatorClass);
		if(this.reflector.classExtendsOrImplements(mediatorClass,m.mvc.api.IMediator) == false) throw new m.mvc.base.ContextError(m.mvc.base.ContextError.E_MEDIATORMAP_NOIMPL + " - " + mediatorClass);
		var config = new m.mvc.base.MappingConfig();
		config.mediatorClass = mediatorClass;
		config.autoCreate = autoCreate;
		config.autoRemove = autoRemove;
		if(injectViewAs) {
			if(Std["is"](injectViewAs,Array)) config.typedViewClasses = ((function($this) {
				var $r;
				var $t = injectViewAs;
				if(Std["is"]($t,Array)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this))).copy(); else if(Std["is"](injectViewAs,Class)) config.typedViewClasses = [injectViewAs];
		} else if(Std["is"](viewClassOrName,Class)) config.typedViewClasses = [viewClassOrName];
		this.mappingConfigByViewClassName.set(viewClassName,config);
		if(autoCreate || autoRemove) {
			this.viewListenerCount++;
			if(this.viewListenerCount == 1) this.addListeners();
		}
		if(autoCreate && this.contextView != null && viewClassName == Type.getClassName(Type.getClass(this.contextView))) this.createMediatorUsing(this.contextView,viewClassName,config);
	}
	,unmapView: function(viewClassOrName) {
		var viewClassName = this.reflector.getFQCN(viewClassOrName);
		var config = this.mappingConfigByViewClassName.get(viewClassName);
		if(config != null && (config.autoCreate || config.autoRemove)) {
			this.viewListenerCount--;
			if(this.viewListenerCount == 0) this.removeListeners();
		}
		this.mappingConfigByViewClassName["delete"](viewClassName);
	}
	,createMediator: function(viewComponent) {
		return this.createMediatorUsing(viewComponent);
	}
	,registerMediator: function(viewComponent,mediator) {
		this.mediatorByView.set(viewComponent,mediator);
		var mapping = this.mappingConfigByViewClassName.get(Type.getClassName(Type.getClass(viewComponent)));
		this.mappingConfigByView.set(viewComponent,mapping);
		mediator.setViewComponent(viewComponent);
		mediator.preRegister();
	}
	,removeMediator: function(mediator) {
		if(mediator != null) {
			var viewComponent = mediator.getViewComponent();
			this.mediatorByView["delete"](viewComponent);
			this.mappingConfigByView["delete"](viewComponent);
			mediator.preRemove();
			mediator.setViewComponent(null);
		}
		return mediator;
	}
	,removeMediatorByView: function(viewComponent) {
		return this.removeMediator(this.retrieveMediator(viewComponent));
	}
	,retrieveMediator: function(viewComponent) {
		return this.mediatorByView.get(viewComponent);
	}
	,hasMapping: function(viewClassOrName) {
		var viewClassName = this.reflector.getFQCN(viewClassOrName);
		return this.mappingConfigByViewClassName.get(viewClassName) != null;
	}
	,hasMediatorForView: function(viewComponent) {
		return this.mediatorByView.get(viewComponent) != null;
	}
	,hasMediator: function(mediator) {
		var $it0 = this.mediatorByView.iterator();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			if(this.mediatorByView.get(key) == mediator) return true;
		}
		return false;
	}
	,addListeners: function() {
		if(this.contextView != null && this.enabled) {
			this.contextView.viewAdded = this.onViewAdded.$bind(this);
			this.contextView.viewRemoved = this.onViewRemoved.$bind(this);
		}
	}
	,removeListeners: function() {
		if(this.contextView != null) {
			this.contextView.viewAdded = null;
			this.contextView.viewRemoved = null;
		}
	}
	,onViewAdded: function(view) {
		if(this.mediatorsMarkedForRemoval.get(view) != null) {
			this.mediatorsMarkedForRemoval["delete"](view);
			return;
		}
		var viewClassName = Type.getClassName(Type.getClass(view));
		var config = this.mappingConfigByViewClassName.get(viewClassName);
		if(config != null && config.autoCreate) this.createMediatorUsing(view,viewClassName,config);
	}
	,onViewRemoved: function(view) {
		var config = this.mappingConfigByView.get(view);
		if(config != null && config.autoRemove) this.removeMediatorByView(view);
	}
	,removeMediatorLater: function() {
		var $it0 = this.mediatorsMarkedForRemoval.iterator();
		while( $it0.hasNext() ) {
			var view = $it0.next();
			if(!this.contextView.isAdded(view)) this.removeMediatorByView(view);
			this.mediatorsMarkedForRemoval["delete"](view);
		}
		this.hasMediatorsMarkedForRemoval = false;
	}
	,createMediatorUsing: function(viewComponent,viewClassName,config) {
		var mediator = this.mediatorByView.get(viewComponent);
		if(mediator == null) {
			if(viewClassName == null) viewClassName = Type.getClassName(Type.getClass(viewComponent));
			if(config == null) config = this.mappingConfigByViewClassName.get(viewClassName);
			if(config != null) {
				var _g = 0, _g1 = config.typedViewClasses;
				while(_g < _g1.length) {
					var claxx = _g1[_g];
					++_g;
					this.injector.mapValue(claxx,viewComponent);
				}
				mediator = this.injector.instantiate(config.mediatorClass);
				var _g = 0, _g1 = config.typedViewClasses;
				while(_g < _g1.length) {
					var clazz = _g1[_g];
					++_g;
					this.injector.unmap(clazz);
				}
				this.registerMediator(viewComponent,mediator);
			}
		}
		return mediator;
	}
	,__class__: m.mvc.base.MediatorMap
});
m.mvc.base.MappingConfig = $hxClasses["m.mvc.base.MappingConfig"] = function() {
};
m.mvc.base.MappingConfig.__name__ = ["m","mvc","base","MappingConfig"];
m.mvc.base.MappingConfig.prototype = {
	mediatorClass: null
	,typedViewClasses: null
	,autoCreate: null
	,autoRemove: null
	,__class__: m.mvc.base.MappingConfig
}
m.mvc.base.ViewMap = $hxClasses["m.mvc.base.ViewMap"] = function(contextView,injector) {
	m.mvc.base.ViewMapBase.call(this,contextView,injector);
	this.mappedPackages = new Array();
	this.mappedTypes = new m.data.Dictionary();
	this.injectedViews = new m.data.Dictionary(true);
};
m.mvc.base.ViewMap.__name__ = ["m","mvc","base","ViewMap"];
m.mvc.base.ViewMap.__interfaces__ = [m.mvc.api.IViewMap];
m.mvc.base.ViewMap.__super__ = m.mvc.base.ViewMapBase;
m.mvc.base.ViewMap.prototype = $extend(m.mvc.base.ViewMapBase.prototype,{
	mapPackage: function(packageName) {
		if(!Lambda.has(this.mappedPackages,packageName)) {
			this.mappedPackages.push(packageName);
			this.viewListenerCount++;
			if(this.viewListenerCount == 1) this.addListeners();
		}
	}
	,unmapPackage: function(packageName) {
		var index = Lambda.indexOf(this.mappedPackages,packageName);
		if(index > -1) {
			this.mappedPackages.splice(index,1);
			this.viewListenerCount--;
			if(this.viewListenerCount == 0) this.removeListeners();
		}
	}
	,mapType: function(type) {
		if(this.mappedTypes.get(type) != null) return;
		this.mappedTypes.set(type,type);
		this.viewListenerCount++;
		if(this.viewListenerCount == 1) this.addListeners();
		if(this.contextView != null && Std["is"](this.contextView,type)) this.injectInto(this.contextView);
	}
	,unmapType: function(type) {
		var mapping = this.mappedTypes.get(type);
		this.mappedTypes["delete"](type);
		if(mapping != null) {
			this.viewListenerCount--;
			if(this.viewListenerCount == 0) this.removeListeners();
		}
	}
	,hasType: function(type) {
		return this.mappedTypes.get(type) != null;
	}
	,hasPackage: function(packageName) {
		return Lambda.has(this.mappedPackages,packageName);
	}
	,mappedPackages: null
	,mappedTypes: null
	,injectedViews: null
	,addListeners: function() {
		if(this.contextView != null && this.enabled) {
			this.contextView.viewAdded = this.onViewAdded.$bind(this);
			this.contextView.viewRemoved = this.onViewAdded.$bind(this);
		}
	}
	,removeListeners: function() {
		if(this.contextView != null) {
			this.contextView.viewAdded = null;
			this.contextView.viewRemoved = null;
		}
	}
	,onViewAdded: function(view) {
		if(this.injectedViews.get(view) != null) return;
		var $it0 = this.mappedTypes.iterator();
		while( $it0.hasNext() ) {
			var type = $it0.next();
			if(Std["is"](view,type)) {
				this.injectInto(view);
				return;
			}
		}
		var len = this.mappedPackages.length;
		if(len > 0) {
			var className = Type.getClassName(Type.getClass(view));
			var _g = 0;
			while(_g < len) {
				var i = _g++;
				var packageName = this.mappedPackages[i];
				if(className.indexOf(packageName) == 0) {
					this.injectInto(view);
					return;
				}
			}
		}
	}
	,onViewRemoved: function(view) {
		haxe.Log.trace("TODO",{ fileName : "ViewMap.hx", lineNumber : 165, className : "m.mvc.base.ViewMap", methodName : "onViewRemoved"});
	}
	,injectInto: function(view) {
		this.injector.injectInto(view);
		this.injectedViews.set(view,true);
	}
	,__class__: m.mvc.base.ViewMap
});
m.signal.Signal1 = $hxClasses["m.signal.Signal1"] = function(type) {
	m.signal.Signal.call(this,[type]);
};
m.signal.Signal1.__name__ = ["m","signal","Signal1"];
m.signal.Signal1.__super__ = m.signal.Signal;
m.signal.Signal1.prototype = $extend(m.signal.Signal.prototype,{
	dispatch: function(value) {
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute(value);
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new m.signal.Slot1(this,listener,once,priority);
	}
	,__class__: m.signal.Signal1
});
m.signal.Signal2 = $hxClasses["m.signal.Signal2"] = function(type1,type2) {
	m.signal.Signal.call(this,[type1,type2]);
};
m.signal.Signal2.__name__ = ["m","signal","Signal2"];
m.signal.Signal2.__super__ = m.signal.Signal;
m.signal.Signal2.prototype = $extend(m.signal.Signal.prototype,{
	dispatch: function(value1,value2) {
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute(value1,value2);
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new m.signal.Slot2(this,listener,once,priority);
	}
	,__class__: m.signal.Signal2
});
m.signal.Slot = $hxClasses["m.signal.Slot"] = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	this.signal = signal;
	this.set_listener(listener);
	this.once = once;
	this.priority = priority;
	this.enabled = true;
};
m.signal.Slot.__name__ = ["m","signal","Slot"];
m.signal.Slot.prototype = {
	listener: null
	,once: null
	,priority: null
	,enabled: null
	,signal: null
	,remove: function() {
		this.signal.remove(this.listener);
	}
	,set_listener: function(value) {
		if(value == null) throw "listener cannot be null";
		return this.listener = value;
	}
	,__class__: m.signal.Slot
	,__properties__: {set_listener:"set_listener"}
}
m.signal.Slot0 = $hxClasses["m.signal.Slot0"] = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	m.signal.Slot.call(this,signal,listener,once,priority);
};
m.signal.Slot0.__name__ = ["m","signal","Slot0"];
m.signal.Slot0.__super__ = m.signal.Slot;
m.signal.Slot0.prototype = $extend(m.signal.Slot.prototype,{
	execute: function() {
		if(!this.enabled) return;
		if(this.once) this.remove();
		this.listener();
	}
	,__class__: m.signal.Slot0
});
m.signal.Slot1 = $hxClasses["m.signal.Slot1"] = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	m.signal.Slot.call(this,signal,listener,once,priority);
};
m.signal.Slot1.__name__ = ["m","signal","Slot1"];
m.signal.Slot1.__super__ = m.signal.Slot;
m.signal.Slot1.prototype = $extend(m.signal.Slot.prototype,{
	param: null
	,execute: function(value1) {
		if(!this.enabled) return;
		if(this.once) this.remove();
		if(this.param != null) value1 = this.param;
		this.listener(value1);
	}
	,__class__: m.signal.Slot1
});
m.signal.Slot2 = $hxClasses["m.signal.Slot2"] = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	m.signal.Slot.call(this,signal,listener,once,priority);
};
m.signal.Slot2.__name__ = ["m","signal","Slot2"];
m.signal.Slot2.__super__ = m.signal.Slot;
m.signal.Slot2.prototype = $extend(m.signal.Slot.prototype,{
	param1: null
	,param2: null
	,execute: function(value1,value2) {
		if(!this.enabled) return;
		if(this.once) this.remove();
		if(this.param1 != null) value1 = this.param1;
		if(this.param2 != null) value2 = this.param2;
		this.listener(value1,value2);
	}
	,__class__: m.signal.Slot2
});
m.signal.SlotList = $hxClasses["m.signal.SlotList"] = function(head,tail) {
	this.nonEmpty = false;
	if(head == null && tail == null) {
		if(m.signal.SlotList.NIL != null) throw new m.exception.ArgumentException("Parameters head and tail are null. Use the NIL element instead.",null,{ fileName : "SlotList.hx", lineNumber : 40, className : "m.signal.SlotList", methodName : "new"});
		this.nonEmpty = false;
	} else if(head == null) throw new m.exception.ArgumentException("Parameter head cannot be null.",null,{ fileName : "SlotList.hx", lineNumber : 48, className : "m.signal.SlotList", methodName : "new"}); else {
		this.head = head;
		this.tail = tail == null?m.signal.SlotList.NIL:tail;
		this.nonEmpty = true;
	}
};
m.signal.SlotList.__name__ = ["m","signal","SlotList"];
m.signal.SlotList.NIL = null;
m.signal.SlotList.prototype = {
	head: null
	,tail: null
	,nonEmpty: null
	,length: null
	,get_length: function() {
		if(!this.nonEmpty) return 0;
		if(this.tail == m.signal.SlotList.NIL) return 1;
		var result = 0;
		var p = this;
		while(p.nonEmpty) {
			++result;
			p = p.tail;
		}
		return result;
	}
	,prepend: function(slot) {
		return new m.signal.SlotList(slot,this);
	}
	,append: function(slot) {
		if(slot == null) return this;
		if(!this.nonEmpty) return new m.signal.SlotList(slot);
		if(this.tail == m.signal.SlotList.NIL) return new m.signal.SlotList(slot).prepend(this.head);
		var wholeClone = new m.signal.SlotList(this.head);
		var subClone = wholeClone;
		var current = this.tail;
		while(current.nonEmpty) {
			subClone = subClone.tail = new m.signal.SlotList(current.head);
			current = current.tail;
		}
		subClone.tail = new m.signal.SlotList(slot);
		return wholeClone;
	}
	,insertWithPriority: function(slot) {
		if(!this.nonEmpty) return new m.signal.SlotList(slot);
		var priority = slot.priority;
		if(priority > this.head.priority) return this.prepend(slot);
		var wholeClone = new m.signal.SlotList(this.head);
		var subClone = wholeClone;
		var current = this.tail;
		while(current.nonEmpty) {
			if(priority > current.head.priority) {
				subClone.tail = current.prepend(slot);
				return wholeClone;
			}
			subClone = subClone.tail = new m.signal.SlotList(current.head);
			current = current.tail;
		}
		subClone.tail = new m.signal.SlotList(slot);
		return wholeClone;
	}
	,filterNot: function(listener) {
		if(!this.nonEmpty || listener == null) return this;
		if(Reflect.compareMethods(this.head.listener,listener)) return this.tail;
		var wholeClone = new m.signal.SlotList(this.head);
		var subClone = wholeClone;
		var current = this.tail;
		while(current.nonEmpty) {
			if(Reflect.compareMethods(current.head.listener,listener)) {
				subClone.tail = current.tail;
				return wholeClone;
			}
			subClone = subClone.tail = new m.signal.SlotList(current.head);
			current = current.tail;
		}
		return this;
	}
	,contains: function(listener) {
		if(!this.nonEmpty) return false;
		var p = this;
		while(p.nonEmpty) {
			if(Reflect.compareMethods(p.head.listener,listener)) return true;
			p = p.tail;
		}
		return false;
	}
	,find: function(listener) {
		if(!this.nonEmpty) return null;
		var p = this;
		while(p.nonEmpty) {
			if(Reflect.compareMethods(p.head.listener,listener)) return p.head;
			p = p.tail;
		}
		return null;
	}
	,__class__: m.signal.SlotList
	,__properties__: {get_length:"get_length"}
}
if(!m.util) m.util = {}
m.util.ReflectUtil = $hxClasses["m.util.ReflectUtil"] = function() { }
m.util.ReflectUtil.__name__ = ["m","util","ReflectUtil"];
m.util.ReflectUtil.setProperty = function(object,property,value) {
	var hasSetter = object["set_" + property] != null;
	if(hasSetter) Reflect.field(object,"set_" + property).apply(object,[value]); else object[property] = value;
	return value;
}
m.util.ReflectUtil.hasProperty = function(object,property) {
	var properties = Type.getInstanceFields(Type.getClass(object));
	return Lambda.has(properties,property);
}
m.util.ReflectUtil.getFields = function(object) {
	return (function($this) {
		var $r;
		var $e = (Type["typeof"](object));
		switch( $e[1] ) {
		case 6:
			var c = $e[2];
			$r = Type.getInstanceFields(c);
			break;
		default:
			$r = Reflect.fields(object);
		}
		return $r;
	}(this));
}
m.util.ReflectUtil.here = function(info) {
	return info;
}
m.util.ReflectUtil.callMethod = function(o,func,args) {
	if(args == null) args = [];
	try {
		return func.apply(o,args);
	} catch( e ) {
		throw new m.exception.Exception("Error calling method " + Type.getClassName(Type.getClass(o)) + "." + func + "(" + args.toString() + ")",e,{ fileName : "ReflectUtil.hx", lineNumber : 100, className : "m.util.ReflectUtil", methodName : "callMethod"});
	}
}
m.util.ReflectUtil.prototype = {
	__class__: m.util.ReflectUtil
}
m.util.TypeUtil = $hxClasses["m.util.TypeUtil"] = function() { }
m.util.TypeUtil.__name__ = ["m","util","TypeUtil"];
m.util.TypeUtil.isSubClassOf = function(object,type) {
	return Std["is"](object,type) && Type.getClass(object) != type;
}
m.util.TypeUtil.createInstance = function(forClass,args) {
	if(args == null) args = [];
	try {
		return Type.createInstance(forClass,args);
	} catch( e ) {
		throw new m.exception.Exception("Error creating instance of " + Type.getClassName(forClass) + "(" + args.toString() + ")",e,{ fileName : "TypeUtil.hx", lineNumber : 42, className : "m.util.TypeUtil", methodName : "createInstance"});
	}
}
m.util.TypeUtil.prototype = {
	__class__: m.util.TypeUtil
}
js.Boot.__res = {}
js.Boot.__init();
{
	var d = Date;
	d.now = function() {
		return new Date();
	};
	d.fromTime = function(t) {
		var d1 = new Date();
		d1["setTime"](t);
		return d1;
	};
	d.fromString = function(s) {
		switch(s.length) {
		case 8:
			var k = s.split(":");
			var d1 = new Date();
			d1["setTime"](0);
			d1["setUTCHours"](k[0]);
			d1["setUTCMinutes"](k[1]);
			d1["setUTCSeconds"](k[2]);
			return d1;
		case 10:
			var k = s.split("-");
			return new Date(k[0],k[1] - 1,k[2],0,0,0);
		case 19:
			var k = s.split(" ");
			var y = k[0].split("-");
			var t = k[1].split(":");
			return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
		default:
			throw "Invalid date format : " + s;
		}
	};
	d.prototype["toString"] = function() {
		var date = this;
		var m = date.getMonth() + 1;
		var d1 = date.getDate();
		var h = date.getHours();
		var mi = date.getMinutes();
		var s = date.getSeconds();
		return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d1 < 10?"0" + d1:"" + d1) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
	};
	d.prototype.__class__ = $hxClasses["Date"] = d;
	d.__name__ = ["Date"];
}
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	$hxClasses["Math"] = Math;
	Math.isFinite = function(i) {
		return isFinite(i);
	};
	Math.isNaN = function(i) {
		return isNaN(i);
	};
}
{
	String.prototype.__class__ = $hxClasses["String"] = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = $hxClasses["Array"] = Array;
	Array.__name__ = ["Array"];
	var Int = $hxClasses["Int"] = { __name__ : ["Int"]};
	var Dynamic = $hxClasses["Dynamic"] = { __name__ : ["Dynamic"]};
	var Float = $hxClasses["Float"] = Number;
	Float.__name__ = ["Float"];
	var Bool = $hxClasses["Bool"] = Boolean;
	Bool.__ename__ = ["Bool"];
	var Class = $hxClasses["Class"] = { __name__ : ["Class"]};
	var Enum = { };
	var Void = $hxClasses["Void"] = { __ename__ : ["Void"]};
}
{
	Xml.Element = "element";
	Xml.PCData = "pcdata";
	Xml.CData = "cdata";
	Xml.Comment = "comment";
	Xml.DocType = "doctype";
	Xml.Prolog = "prolog";
	Xml.Document = "document";
}
if(typeof(JSON) != "undefined") haxe.Json = JSON;
{
	if(typeof document != "undefined") js.Lib.document = document;
	if(typeof window != "undefined") {
		js.Lib.window = window;
		js.Lib.window.onerror = function(msg,url,line) {
			var f = js.Lib.onerror;
			if(f == null) return false;
			return f(msg,[url + ":" + line]);
		};
	}
}
js["XMLHttpRequest"] = window.XMLHttpRequest?XMLHttpRequest:window.ActiveXObject?function() {
	try {
		return new ActiveXObject("Msxml2.XMLHTTP");
	} catch( e ) {
		try {
			return new ActiveXObject("Microsoft.XMLHTTP");
		} catch( e1 ) {
			throw "Unable to create XMLHttpRequest object.";
		}
	}
}:(function($this) {
	var $r;
	throw "Unable to create XMLHttpRequest object.";
	return $r;
}(this));
m.signal.SlotList.NIL = new m.signal.SlotList(null,null);
Xml.enode = new EReg("^<([a-zA-Z0-9:._-]+)","");
Xml.ecdata = new EReg("^<!\\[CDATA\\[","i");
Xml.edoctype = new EReg("^<!DOCTYPE ","i");
Xml.eend = new EReg("^</([a-zA-Z0-9:._-]+)>","");
Xml.epcdata = new EReg("^[^<]+","");
Xml.ecomment = new EReg("^<!--","");
Xml.eprolog = new EReg("^<\\?[^\\?]+\\?>","");
Xml.eattribute = new EReg("^\\s*([a-zA-Z0-9:_-]+)\\s*=\\s*([\"'])([^\\2]*?)\\2","");
Xml.eclose = new EReg("^[ \r\n\t]*(>|(/>))","");
Xml.ecdata_end = new EReg("\\]\\]>","");
Xml.edoctype_elt = new EReg("[\\[|\\]>]","");
Xml.ecomment_end = new EReg("-->","");
m.mvc.api.IContext.__meta__ = { obj : { 'interface' : null}};
m.mvc.api.IViewContainer.__meta__ = { obj : { 'interface' : null}};
m.mvc.api.IMediator.__meta__ = { obj : { 'interface' : null}};
m.mvc.impl.Mediator.__meta__ = { fields : { injector : { name : ["injector"], type : ["m.inject.IInjector"], inject : null}, contextView : { name : ["contextView"], type : ["m.mvc.api.IViewContainer"], inject : null}, mediatorMap : { name : ["mediatorMap"], type : ["m.mvc.api.IMediatorMap"], inject : null}}};
m.mvc.api.ICommand.__meta__ = { obj : { 'interface' : null}};
m.mvc.impl.Command.__meta__ = { fields : { contextView : { name : ["contextView"], type : ["m.mvc.api.IViewContainer"], inject : null}, commandMap : { name : ["commandMap"], type : ["m.mvc.api.ICommandMap"], inject : null}, injector : { name : ["injector"], type : ["m.inject.IInjector"], inject : null}, mediatorMap : { name : ["mediatorMap"], type : ["m.mvc.api.IMediatorMap"], inject : null}}};
example.todo.command.LoadTodoListCommand.__meta__ = { fields : { list : { name : ["list"], type : ["example.todo.model.TodoList"], inject : null}, signal : { name : ["signal"], type : ["example.todo.signal.LoadTodoList"], inject : null}}};
m.signal.Signal.__meta__ = { fields : { createSlot : { IgnoreCover : null}}};
example.todo.view.TodoListViewMediator.__meta__ = { fields : { loadTodoList : { name : ["loadTodoList"], type : ["example.todo.signal.LoadTodoList"], inject : null}}};
haxe.Http.__meta__ = { obj : { IgnoreCover : null}};
js.Lib.onerror = null;
m.inject.IInjector.__meta__ = { obj : { 'interface' : null}};
m.inject.IReflector.__meta__ = { obj : { 'interface' : null}};
m.inject.injectionpoints.InjectionPoint.__meta__ = { fields : { applyInjection : { IgnoreCover : null}, initializeInjection : { IgnoreCover : null}}};
m.inject.injectionresults.InjectionResult.__meta__ = { fields : { getResponse : { IgnoreCover : null}}};
m.loader.Loader.__meta__ = { obj : { 'interface' : null}};
m.mvc.api.ICommandMap.__meta__ = { obj : { 'interface' : null}};
m.mvc.api.IMediatorMap.__meta__ = { obj : { 'interface' : null}};
m.mvc.api.IViewMap.__meta__ = { obj : { 'interface' : null}};
m.mvc.base.ContextError.E_COMMANDMAP_NOIMPL = "Command Class does not implement an execute() method";
m.mvc.base.ContextError.E_COMMANDMAP_OVR = "Cannot overwrite map";
m.mvc.base.ContextError.E_MEDIATORMAP_NOIMPL = "Mediator Class does not implement IMediator";
m.mvc.base.ContextError.E_MEDIATORMAP_OVR = "Mediator Class has already been mapped to a View Class in this context";
m.mvc.base.ContextError.E_EVENTMAP_NOSNOOPING = "Listening to the context eventDispatcher is not enabled for this EventMap";
m.mvc.base.ContextError.E_CONTEXT_INJECTOR = "The ContextBase does not specify a concrete IInjector. Please override the injector getter in your concrete or abstract Context.";
m.mvc.base.ContextError.E_CONTEXT_REFLECTOR = "The ContextBase does not specify a concrete IReflector. Please override the reflector getter in your concrete or abstract Context.";
Main.main()