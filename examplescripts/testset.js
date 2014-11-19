/*
 * Common test code
 */

/*
 * Tests scripts should first call describe(), then test() for each test, 
 * and then call finish() at the end.
 */

var failures = 0;
var total = 0;
var saved_desc;

/** Describes the current test. Should be the first function called! */
function describe(desc) {
	trace()
	trace("===============================")
	trace("Test: " + desc)
	trace()
	saved_desc = desc;
}

/* Literalise a string for printing purposes */
function literal(v) {
    if (v === NO_EXCEPTION) return "NO_EXCEPTION";
    if (v === ANY_EXCEPTION) return "ANY_EXCEPTION";
    try {
	switch (typeof v) {
	case "string":
		var t = '"' + v.replace(/[\\'"]/g, "\\$&") + '"';
		var s = "";
		for (var i = 0; i < t.length; i++) {
		    var c = t.charCodeAt(i);
		    if (c == '\n'.charCodeAt(0)) s = s + "\\n";
		    else if (c == '\t'.charCodeAt(0)) s = s + "\\t";
		    else if (c == '\r'.charCodeAt(0)) s = s + "\\r";
		    else if (c < 16) s = s + "\\x0" + c.toString(16);
		    else if (c < 32) s = s + "\\x" + c.toString(16);
		    else if (c < 127) s = s + t.charAt(i);
		    else if (c < 0x100) s = s + "\\x" + c.toString(16);
		    else if (c < 0x1000) s = s + "\\u0" + c.toString(16);
		    else s = s + "\\u" + c.toString(16);
		}
		return s;
	default:
		return String(v);
	}
    } catch (e) {
	return "<cannot represent " + typeof v + " value as string>";
    }
}

/*
 * instances of ExceptionClass are treated specially by the test() function.
 * They only match values that have been thrown.
 */
function Exception(value) {
    switch (value) {
    /* For error classes, we match by constructor only */
    case Error:	case EvalError: case RangeError:
    case ReferenceError: case SyntaxError: case TypeError: case URIError:
	return new ExceptionInstance(value);
    /* Everything else we match exactly */
    default:
	return new ExceptionValue(value); 
    }
}

/* Exception base class */
function ExceptionBase() {}
ExceptionBase.prototype = {}

/* Exceptions that match a particular value (usually not an object) */
function ExceptionValue(value) { 
    this.value = value; }
ExceptionValue.prototype = new ExceptionBase();
ExceptionValue.prototype.matches = function(v) { 
    return this.value == v
};
ExceptionValue.prototype.toString = function() { 
    return "throw " + literal(this.value);
};

/* Exceptions that match when they are an instance of a error class */
function ExceptionInstance(base) { 
    this.base = base; }
ExceptionInstance.prototype = new ExceptionBase();
ExceptionInstance.prototype.toString = function() { 
    return "throw " + this.base.prototype.name + "(...)";
};
ExceptionInstance.prototype.matches = function(v) { 
    /* Strict ECMA forbids Error.[[HasInstance]] so we have to hack */
    return (typeof v == "object") && v && v.constructor == this.base;
};

var NO_EXCEPTION = {}
var ANY_EXCEPTION = {}


/* Indicates the successful conculsion of a test */
function pass(msg) {
    trace(msg + " - PASS");
	total++;
}

/* Indicates the unsuccessful conclusion of a test */
function fail(msg, extra) {
	var s;
    s = msg + " - FAIL";
	if (extra) s += "\n\t\t(" + extra + ")";
	trace(s);
	failures++;
	total++;
}

/* Evaluates a JS expression, checks that the result is that expected
 * and calls either pass() or fail(). */
function test(expr, expected) {

	var result, msg, ok, result_str;
	try {
		result = eval(expr);
     	if (expected instanceof ExceptionBase)
		    ok = false;
		else if (expected === NO_EXCEPTION)
		    ok = true;
		else if (typeof expected == "number" && isNaN(expected))
		    ok = typeof result == "number" && isNaN(result);
		else
		    ok = (result === expected);
		result_str = literal(result);
	} catch (e) {
		if (expected === ANY_EXCEPTION)
		    ok = true;
		else if (expected instanceof ExceptionBase)
		    ok = expected.matches(e);
		else
		    ok = false;
		result_str = "throw " + literal(e);
	}

	msg = expr + ' = ' + result_str;
	if (ok) {
		pass(msg);
	} else {
		fail(msg, "expected " + literal(expected));
	}
}

/* Displays a summary of the test passes and failures, and throws a
 * final Error if there were any failures. */
function finish() {
	trace();
	trace("End: " + saved_desc);
	trace("     " + (total - failures) + " of " +
		      total + " sub-tests passed");
	trace("===============================")

	/* Throw an error on failure */
	if (failures > 0)
		throw new Error("tests failure");
}

/* Returns the class of an object */
function getClass(v) {
    return /^\[object (.*)\]$/.exec(Object.prototype.toString.apply(v))[1];
}

describe("Exercises every production in the grammar"); 

test("1 + +1", 2);
test("1 - +1", 0);
test("1 + -1", 0);
test("1 + +1", 2);                      

test("this", this);
test("null", null);
test("undefined", undefined);
test("'\\u0041'", "A");
test('"\\x1b\\x5bm"', "[m");
test('"\\33\\133m"', "[m");
ident = "ident"; test("ident", "ident");
test("[1,2,3].length", 3);
test("({'foo':5}.foo)", 5);
test("((((3))))", 3);

function constr() {
	return constr;
}
constr.prototype = Object.prototype

test("new new new constr()", constr);
test("(1,2,3)", 3);
test("i = 3; i++", 3); test("i", 4);
test("i = 3; ++i", 4); test("i", 4);
test("i = 3; i--", 3); test("i", 2);
test("i = 3; --i", 2); test("i", 2);
test("i@", Exception(SyntaxError));
test("i = 3; i ++ ++", Exception(SyntaxError));
test("i = 3; --i++", Exception(ReferenceError));
test("i = 3; ++i--", Exception(ReferenceError));

test("!true", false);
test("~0", -1);
test("void 'hi'", undefined);
test("i = 3; delete i", true); test("i", Exception(ReferenceError));  

test("3 * 6 + 1", 19);
test("1 + 3 * 6", 19);
test("17 % 11 * 5", 30);
test("30 / 3 / 5", 2);
test("30 / 3 * 5", 50);

test("1 - 1 - 1", -1);

test("i=3;j=5; i*=j+=i", 24);
 
/* instanceof's rhs must be an object */
test("1 instanceof 1", Exception(TypeError));
test("null instanceof null", Exception(TypeError));

/* Only function objects should support HasInstance: */
test("1 instanceof Number.prototype", Exception(TypeError));
test("new Number(1) instanceof Number.prototype", Exception(TypeError));

/* Test the instanceof keyword and the new operator applied to functions. */
function Employee(age, name) {
	this.age = age;
	this.name = name;
}
Employee.prototype = new Object()
Employee.prototype.constructor = Employee
Employee.prototype.toString = function() {
	return "Name: " + this.name + ", age: " + this.age;
}
Employee.prototype.retireable = function() { return this.age > 55; }

function Manager(age, name, group) {
	this.age = age;
	this.name = name;
	this.group = group;
}
Manager.prototype = new Employee();
Manager.prototype.toString = function() {
	return "Name: " + this.name + ", age: " + this.age
	       + ", group: " + this.group;
}

e = new Employee(24, "Tony");
m = new Manager(62, "Paul", "Finance");
test("m.retireable()", true);
test("m instanceof Employee", true);
test("e instanceof Manager", false);
 
test("{true;}", true);
test(";", undefined);
test("label:;", undefined);
test("label:label2:;", undefined);
test("label:label2:label3:;", undefined);
test("label:label2:label3:break label;", undefined);
test("{}", undefined);

test("i=0; do { i++; } while(i<10); i", 10);
test("i=0; while (i<10) { i++; }; i", 10);
test("for (i = 0; i < 10; i++); i", 10);
test("i=0; for (; i < 10; i++); i", 10);
test("i=0; for (; i < 10; ) i++; i", 10);
test("i=0; for (; ;i++) if (i==10) break; i", 10);
test("a=[1,2,3,4]; c=0; for (var v in a) c+=a[v]; c", 10);
test("delete t; t", Exception(ReferenceError));
test("{var t;} t", undefined);
test("continue", Exception(SyntaxError));
test("return", Exception(SyntaxError));
test("break", Exception(SyntaxError));
test("x = 0; outer: for (;;) { for (;;) break outer; x++; }; x", 0);
test("x = 0; for (i = 0; i < 3; i++) { continue; x++; } x", 0);
test("x = 0; it:for (i = 0; i < 3; i++) { for (;;) continue it; x++; } x", 0);
test("c = 9; o = { a:'a', b: { c: 'c' }, c:7 }; with (o.b) x = c; x", 'c');
test("x = ''; for (i = 0; i < 8; i++) switch (i) {" +
     "case 0: x+='a'; case 1: x+='b'; break;" +
     "case 2: x+='c'; break; case 3: x+='d'; default: x+='e';" +
     "case 4: x+='f'; break; case 5: x+='g'; case 6: x+='h';}; x",
     "abbcdeffghhef");
test("foo:bar:baz:;", undefined);
var obj = {};
test("throw obj", Exception(obj));
test("x=0;try{throw {a:1}} catch(e){x=e.a};x", 1);
test("x=y=0;try{" +
     " try { throw {a:1} } finally {x=2}; " +
     "} catch(e) {y=e.a}; x+y", 3);
test("x=y=0; try{throw {a:2};y=1;} catch(e){x=e.a;y=-7;} finally{y=3}; x+y", 5);
compat("js");
test("var x='pass';a:{b:break a;x='fail';};x", 'pass');
test("if (0) function foo(){}", undefined); 

finish();
                    