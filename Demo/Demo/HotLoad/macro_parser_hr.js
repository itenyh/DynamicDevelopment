var global = {};
(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
/*

C Preprocessor


© 2017 - Guillaume Gonnet
License GPLv2

Sources at https://github.com/ParksProjets/C-Preprocessor

*/

var ignoreCmd = {'enum' : 1,
				 'endenum' : 1,
	             'error' : 1,
	             'pragma' : 1,
	             'endif' : 1,
	             'else' : 1,
	             'elif' : 1,
				 'ifndef' : 1,
	             'ifdef' : 1,
	             'undef' : 1,
				 'if' : 1,
				 'include' : 1};

// Libraries
var EventEmitter = require('events'),
	fs = require("fs"),
	path = require("path");



// Return the last character of the string
String.prototype.last = function() {
	return this.slice(-1);
};



// Remove and add some text in the same time
String.prototype.splice = function(idx, rem, s) {
	return (this.slice(0,idx) + s + this.slice(idx + rem));
};



// Get the next "..." string
String.prototype.getNextString = function() {
	var str = this.match(/^"([A-Za-z0-9\-_\. \/\\]+)"/);
	return (!str || !str[1]) ? '' : str[1];
};




// Test if a character is alpha numeric or _
var StringArray = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";

String.prototype.isAlpha = function(i) {
	return StringArray.indexOf(this[i]) != -1;
};
var Compiler = function(opt) {

	// Inherit of EventEmitter
	EventEmitter.call(this);


	// Options object
	this.options = {};
	this.options.newLine = '\n';
	this.options.commentEscape = false;
	this.options.includeSpaces = 0;
	this.options.emptyLinesLimit = 0;
	this.options.basePath = './';
	this.options.stopOnError = true;
	this.options.enumInHex = true;

	// Apply options
	opt = opt || {};
	for (var i in opt)
		this.options[i] = opt[i];


	// List of defined macros/constants
	this.defines = {};

	// Stack for macros/constants
	this.stack = {};

	// List of #pragma once
	this.includeOnce = {};


	// Global constants
	var date = new Date();
	this._compConst('TIME', date.toLocaleTimeString());
	this._compConst('DATE', date.toLocaleDateString());
	this._compConst('LINE', '0');
	this._compConst('FILE', 'main');


	// User defined constants
	var c = opt.constants || {};
	for (var i in c)
		this.createConstant(i, c[i].toString(), false);

	// User defined macros
	var m = opt.macros || {};
	for (var i in m)
		this.createMacro(i, m[i]);
};



// Inherit of EventEmitter, constructor and exports
Compiler.prototype = Object.create(EventEmitter.prototype);
Compiler.prototype.constructor = Compiler;
exports.Compiler = Compiler;




// Compile a text code
Compiler.prototype.compile = function(code, filename) {
	if (filename)
		this.options.filename = filename;

	var processor = new Processor(this, code);
	processor.run();
};





// Compile a file
Compiler.prototype.compileFile = function(file) {
	var _this = this;
	
	fs.readFile(_this.options.basePath + file, 'utf8', function(err, code) {

		if (err)
			return _this._error(`can't read file "${file}"`);

		_this.options.filename = file;

		var processor = new Processor(_this, code);
		processor.run();
	});
};





// Emit an error
Compiler.prototype._error = function(text) {
	this.emit('error', text);
};


// Emit a success
Compiler.prototype._success = function(code) {
	this.emit('success', code);
};
var Processor = function(parent, code) {

	// Parent compiler
	this.parent = parent;
	this.options = parent.options;


	// List of defined macros/constants & stack
	this.defines = parent.defines;
	this.stack = parent.stack;

	// Is the processor running ?
	this.running = false;


	// Code & result text
	this.code = code;
	this.result = '';

	// Number of empty lines
	this.emptyLines = 0;

	// Current line & file
	this.currentLine = 0;
	this.currentFile = this.options.filename || 'main';
	this._compConst('FILE', this.currentFile);

	// Current path
	var p = path.dirname(this.currentFile);
	this.path = (p == '.') ? '' : p + '/';


	// Bind some functions
	this.parseNext = this.parseNext.bind(this);
	this.next = this.next.bind(this);
};



// Constructor
Processor.prototype.constructor = Processor;




// Run the processor
Processor.prototype.run = function() {
	var _this = this;

	// Set the processor as running
	this.running = true;
	

	// Get an array of all lines
	var lines = this.code.split(/\r?\n/);
	this.linesCount = lines.length;

	// Return the next line
	function nextLine() {
		_this._compConst('LINE', _this.currentLine+1);
		return lines[_this.currentLine++];
	}

	this.nextLine = nextLine;


	// Parse the first line
	this.next();
};




// Parse the next lines (doing it synchronously until an asynchronous command)
Processor.prototype.next = function() {

	var running = true;
	while (this.running && running && this.currentLine < this.linesCount)
		running = (this.parseNext() !== false);

	if (this.running && running && this.currentLine >= this.linesCount)
		this.success();
};




// Append a line to the result
Processor.prototype.addLine = function(line) {
	this.result += line + this.options.newLine;
	this.emptyLines = 0;
};






// Emit an error
Processor.prototype.error = function(msg) {
	if (this.options.stopOnError)
		this.running = false;

	msg = `(line ${this.currentLine} in "${this.currentFile}") ${msg}`;
	this.parent._error(msg);

	return !this.options.stopOnError;
};



// Emit the success
Processor.prototype.success = function() {
	this.running = false;

	if (this.onsuccess)
		this.onsuccess();
	else
		this.parent._success(this.result);
};
Processor.prototype.parseNext = function() {

	// No more line to parse: stop this function
	if (this.currentLine >= this.linesCount)
		return;


	// Get the next line text
	var line = this.nextLine(),
		text = line.trimLeft();


	// If the line is empty: apply empty lines limit option
	if (text.length == 0) {
		if (this.options.emptyLinesLimit && this.emptyLines >= this.options.emptyLinesLimit)
			return;

		this.emptyLines++;
		return this.addLine(line);
	}


	// If the line starts with a # comment: delete it
	if (this.options.commentEscape && text.startsWith("//#"))
		return;

	if (this.options.commentEscape && text.startsWith("/*#"))
		return this.commentEnd();



	// If the line doesn't start with #
	if (text[0] != '#')
		return this.addLine(this.addDefines(line));


	// Get the # directive and the remaing text
	var i = text.indexOf(' '), name;

	if (i != -1) {
		name = text.substr(1, i - 1);
		text = text.substr(i + 1);
	} else {
		name = text.substr(1);
	}



	// Get the # directive
	var cmd = Directives[name.trimLeft()];
	if (ignoreCmd[name]) {
        return this.addLine(this.addDefines(line));
    }

	// If the command exists: call the corresponding function
	if (cmd)
		return cmd.call(this, text);


	// Else: remove the line if 'commentEscape' is enabled
	if (!this.options.commentEscape)
		this.addLine(this.addDefines(line));
};
// Add defined objects to a line
Processor.prototype.addDefines = 
Compiler.prototype.addDefines = function(line, withConst, withMacros) {

	// Local variables
	var i1 = -1, i2;
	var d, r;


	// Check if the constant is present in the line
	for (var i in this.defines) {

		d = this.defines[i];
		
		if (d.count && withMacros === false)
			continue;
		if (!d.count && withConst === false)
			continue;

		i2 = i.length;
		i1 = -1;

		// It can have the same constant more than one time
		for (;;) {

			// Get the position of the constant (-1 if not present)
			i1 = line.indexOf(i, i1 + 1);
			if (i1 == -1)
				break;

			// Check that the constant isn't in a middle of a word and add the constant if not
			if (line.isAlpha(i1 - 1) || line.isAlpha(i1 + i2))
				continue;

			// Add the macro or the constant
			if (d.count)
				r = this.addMacro(line, i1, d);
			else
				r = this.addConstant(line, i1, d);

			line = r.line;
			i1 = r.index;
			continue;
		}
	}

	return line;
};





// Create a constant
Processor.prototype.createConstant =
Compiler.prototype.createConstant = function(name, value, addDefines) {

	// Add constants value to the constant value
	if (addDefines !== false)
		value = this.addDefines(value);

	// Store the constant
	this.defines[name] = {
		name: name,
		value: value
	};
};





// Set a compiler constant
Processor.prototype._compConst =
Compiler.prototype._compConst = function(name, value) {
	this.createConstant('__' + name + '__', value, false);
};





// Add a constant in a line
Processor.prototype.addConstant =
Compiler.prototype.addConstant = function(line, i, constant) {
	
	line = line.splice(i, constant.name.length, constant.value);
	i += constant.value.length;

	return { line: line, index: i };
};
// Create a macro (text must have the macro arguments, like this: '(a,b) a+b')
Processor.prototype.createMacro =
Compiler.prototype.createMacro = function(name, text) {

	// First, get macro arguments
	var args = [];

	var end = text.indexOf(")"),
		i1 = 1,
		i2 = 0;


	// If there is no closing parenthesis
	if (end == -1)
		return this.error(`no closing parenthesis in the #define of marcro ${name}`);
	

	// Get arguments
	while( (i2 = text.indexOf(",", i2 + 1)) != -1 && i2 < end) {
		args.push(text.substring(i1, i2).trim());
		i1 = i2 + 1;
	}

	args.push(text.substring(i1, end));


	// Remove arguments in the text
	text = text.substr(end + 1).trimLeft();

	// Execute defined macros
	text = this.addDefines(text, false, true);


	// Secondly, makes breaks and store variables positions
	var breaks = [];

	for (var i = 0, l = args.length, p; i < l; i++) {

		i1 = -1;
		p = args[i];
		i2 = p.length;

		for(;;) {
			i1 = text.indexOf(p, i1+1);
			if (i1 == -1)
				break;

			if (text.isAlpha(i1-1) || text.isAlpha(i1+i2))
				continue;

			breaks.push([ i1, i, i2 ]);
		}
	}


	// Sort variables in order of their positions in the macro text
	breaks.sort(function(a, b) {
		return a[0] - b[0]
	});



	// Thirdly, cut the text into parts without variable and add defined constants
	var offset = 0,
		content = [],
		pos = [];
		i = 0;

	for (; i < breaks.length; i++) {
		content[i] = this.addDefines(text.slice(offset, breaks[i][0]), true, false);
		offset = breaks[i][0] + breaks[i][2];
		pos[i] = breaks[i][1];
	}

	content[i] = this.addDefines(text.slice(offset));



	// Fourthly, store the macro
	this.defines[name] = {
		content: content,
		count: args.length,
		pos: pos,
		name: name
	};
};








// Read a line and transform macro by adding their value
Processor.prototype.addMacro =
Compiler.prototype.addMacro = function(line, i, macro) {

	// Local variables
	var m = 0,
		e = i + macro.name.length,
		s = e,
		l = 0,
		args = [];


	// Get arguments between parenthesis (by counting parenthesis)
	for (var v, l = line.length; e < l; e++) {

		v = line[e];

		if (v == "(") {
			m++;
			if (m == 1)
				s = e + 1;
		}

		else if (v == "," && m == 1) {
			args.push(line.slice(s, e));
			s = e + 1;
		}

		else if (v == ")") {
			if (m == 1)
				break;
			m--;
		}

		else if (v != ' ' && m == 0) {
			return this.error(`there is no openning parenthesis for macro ${macro.name}`);
		}
	}


	// If the closing parenthesis is missing
	if (m != 1)
		return this.error(`the closing parenthesis is missing for macro ${macro.name}`);

	// Add the last argument
	args.push(line.slice(s, e));


	// Check if there is the right number of arguments
	if (args.length > macro.count)
		return this.error(`too many arguments for macro ${macro.name}`);

	if (args.length < macro.count)
		return this.error(`too few arguments for macro ${macro.name}`);
	

	// Execute 'addDefines' on each argument
	for (var j = 0; j < macro.count; j++)
		args[j] = this.addDefines(args[j]);


	// Replace macro variables with the given arguments
	var str = macro.content[0];

	for (s = 0, l = macro.pos.length; s < l; s++)
		str += args[ macro.pos[s] ] + macro.content[s+1];


	// Add the result into the line
	line = line.splice(i, e - i + 1, str);
	i += str.length;

	return { line: line, index: i };
};
// Save the current value of a macro on top of the stack
Processor.prototype.pushMacro = function(name) {

	if (this.defines[name] === undefined)
		return this.error(`macro ${name} is not defined, cannot push it`);
	
	
	if (this.stack[name] === undefined)
		this.stack[name] = [];

	this.stack[name].push(this.defines[name]);
};




// Set current value of the specified macro to previously saved value
Processor.prototype.popMacro = function(name) {

	if (this.stack[name] === undefined || this.stack[name].length == 0)
		return this.error(`stack for macro ${name} is empty, cannot pop from it`);

	
	this.defines[name] = this.stack[name].pop();
};
// Go to the next #elif, #else or #endif
Processor.prototype.conditionNext = function(end) {
	
	// #if directives to start a condition
	var ifCmd = ['if', 'ifdef', 'ifndef'];

	// #else directives
	var elseCmd = ['elif', 'else'];


	// Local variables
	var line, s, n = 1;


	// Count unexploited conditions
	while (this.currentLine < this.linesCount) {

		line = this.nextLine().trimLeft();
		if (line[0] != '#')
			continue;

		s = line.substr(1).trimLeft().split(' ')[0];

		if (ifCmd.indexOf(s) != -1)
			n++;

		else if (!end && n == 1 && elseCmd.indexOf(s) != -1)
			return this.callCondition(line);

		else if (s == "endif") {
			n--;
			if (n == 0)
				return;
		}
	}
};





// Call a #else or #elif condition
Processor.prototype.callCondition = function(text) {
	
	// Get the directive name
	var split = text.substr(1).trimLeft().split(' '),
		name = split[0];

	// Get the remaining text (without the # directive)
	split.shift();
	text = split.join(' ').trimLeft();


	// Call the corresponding directive
	Directives[name].call(this, text, true);
};





// Go to the end of the condtion (#endif)
Processor.prototype.conditionEnd = function() {
	this.conditionNext(true);
};
// Go to the end of a multilines comment
Processor.prototype.commentEnd = function() {

	this.currentLine--;
	var line, i;
	
	// Find the end of the comment
	while (this.currentLine < this.linesCount) {
		line = this.nextLine();

		if (line.indexOf("*/") != -1)
			break;
	}
};
// List of all directives
var Directives = {};



// Create a directive
function createDirective(name, fn) {
	Directives[name] = fn;
}



createDirective("include", function(text) {
	var _this = this;

	// Get the name of the file to include
	var name = text.getNextString();
	if (!name)
		return this.error('invalid include');


	// File to read
	var file = this.path + name;

	// If the file is already included and #pragma once
	if (this.parent.includeOnce[file])
		return;


	// Read the file asynchronously and parse it
	fs.readFile(this.options.basePath + file, 'utf8', function(err, code) {

		if (err)
			return _this.error(`can't read file "${file}"`);

		_this.options.filename = file;
		var processor = new Processor(_this.parent, code);

		// On success: add the file content to the result
		processor.onsuccess = function() {
			processor.onsuccess = null;

			var e = '';
			for (var i = 0, l = _this.options.includeSpaces; i < l; i++)
				e += _this.options.newLine;

			_this.addLine(e + processor.result.trim() + e);

			_this._compConst('FILE', _this.currentFile);
			_this.next();
		};

		processor.run();
	});


	// Block the synchronous loop
	return false;
});
// #define directive
createDirective("define", function(text) {

	// Get the constant/macro name
	var i = 0;
	while (text.isAlpha(i))
		i++;

	var name = text.substr(0, i),
		isMacro = text[i] == '(';

	text = text.substr(name.length).trimLeft();


	// Read a multilines constants/macro if there is an '\' at the end of the line
	var str = text.trimRight();
	text = '';

	while (str.last() == "\\") {
		text += str.substr(0, str.length - 1) + this.options.newLine;
		str = this.nextLine().trimRight();
	}

	text += str;


	// Strip comments from the definition
	var posBegin;
	var posEnd;

	while ((posBegin = text.indexOf('/*')) != -1) {
		posEnd = text.indexOf('*/', 1 + posBegin);
		if (posEnd == -1)
			posEnd = text.length;

		text = text.substring(0, posBegin) + ' ' + text.substring(2 + posEnd);
	}

	if ((posBegin = text.indexOf('//')) != -1)
		text = text.substring(0, posBegin) + ' ';

	text.trimRight();


	// If there is an '(' after the name: define a macro
	if (isMacro)
		this.createMacro(name, text);

	// Else: create a constant
	else
		this.createConstant(name, text);
});





// #undef directive
createDirective("undef", function(text) {

	// Get the constant/macro name
	var i = 0;
	while (text.isAlpha(i))
		i++;

	var name = text.substr(0, i);


	// Delete the constant/macro
	delete this.defines[name];
});
// #if directive
// See README to know how to use this directive
createDirective("if", function(expr) {
	// Exectute 'defined' function
	var i, i2, name;
	var _this = this;

	expr = expr.replace(/defined\s*\(\s*([\s\S]+?)\s*\)/g, function(match, p1){
		return _this.defines[p1] === undefined ? 'false' : 'true';
	});

	// Replace constants by their values
	expr = this.addDefines(expr);


	// Evaluate the expression
	try {
		var r = eval(expr);
	} catch(e) {
		return this.error('error when evaluating #if expression');
	}


	// If the expr is 'false', go to the next #elif, #else or #endif
	if (!r)
		this.conditionNext();
});





// #ifdef directive (note: '#ifdef VARIABLE' is faster than '#if defined(VARIABLE)')
createDirective("ifdef", function(text) {

	// Get the constant/macro name
	var name = text.split(' ')[0];

	// Check if the constant/macro exists
	if (this.defines[name] === undefined)
		this.conditionNext();
});





// #ifndef directive (note: '#ifndef VARIABLE' is faster than '#if !defined(VARIABLE)')
createDirective("ifndef", function(text) {

	// Get the constant/macro name
	var name = text.split(' ')[0];

	// Check if the constant/macro doesn't exist
	if (this.defines[name] !== undefined)
		this.conditionNext();
});




// #elif directive
createDirective("elif", function(expr, called) {

	// If this directive wasn't callaed by 'this.callCondition'
	if (!called)
		return this.conditionEnd();

	// Else: execute this directive as an #if directive
	Directives.if.call(this, expr);
});




// #else directive
createDirective("else", function(expr, called) {

	// If this directive wasn't called by 'this.callCondition'
	if (!called)
		return this.conditionEnd();

	// Else: nothing to compute, parse the next line
});







// #endif directive
createDirective("endif", function(expr, called) {
	// Do nothing beacause this directive is already evaluated by 'this.conditionNext'
});
// #pragma directive
createDirective("pragma", function(text) {

	text = text.trim();


	// #pragma once: include a file once
	if (text == 'once')
		this.parent.includeOnce[this.currentFile] = true;


	// #pragma push_macro(...): save value of a macro on top of the stack
	else if (text.startsWith('push_macro')) {

		var match = text.match(/push_macro\("([^"]+)"\)/);

		if (match === null || match[1].length == 0)
			this.error(`wrong pragma format`);
		else
			this.pushMacro(match[1]);
	}


	// #pragma pop_macro(...): set value of the a macro to saved value
	else if (text.startsWith('pop_macro')) {

		var match = text.match(/pop_macro\("([^"]+)"\)/);

		if (match === null || match[1].length == 0)
			this.error(`wrong pragma format`);
		else
			this.popMacro(match[1]);
	}


	// Else: error
	else
		this.error(`unknown pragma "${text}"`);
});





// #error directive
createDirective("error", function(text) {
	this.error(text.trim());
});






// #enum directive: c like enumeration
createDirective("enum", function(text) {

	// Get the enum options
	text = text.replace(/=/g, ':');

	try {
		eval(`var opt = { ${text} }`);
	} catch(e) {
		var opt = {};
	}


	// Default options
	opt.start = opt.start || 0;
	opt.step = opt.step || 1;


	// Get all names of constants to create
	var line, str = '';

	while (this.currentLine < this.linesCount) {
		line = this.nextLine();
		if (line.trimLeft().startsWith("#endenum"))
			break;

		str += line;
	}


	// Create an array of constant names
	var split = str.split(','),
		name, v;

	// Create the constants and add their value
	for (var i = 0, l = split.length; i < l; i++) {

		name = split[i].trim();
		v = opt.start + i * opt.step;

		this.defines[name] = {
			value: this.options.enumInHex ? '0x'+v.toString(16) : v.toString(),
			name: name
		};
	}
});



// #endenum directive
createDirective("endenum", function() {
	// Do nothing beacause this directive is already evaluated by #enum
});


},{"events":4,"fs":3,"path":5}],2:[function(require,module,exports){
(function (global){
var Compiler = require("./compiler").Compiler;
var c = new Compiler();

function parse(code, cb) {
    c.on('success', function (code) {
        cb(null, code);
    });
    c.on('error', function (error) {
        cb(error, null);
    });
    c.compile(code);
}

global.parse = parse;
}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./compiler":1}],3:[function(require,module,exports){

},{}],4:[function(require,module,exports){
// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

var objectCreate = Object.create || objectCreatePolyfill
var objectKeys = Object.keys || objectKeysPolyfill
var bind = Function.prototype.bind || functionBindPolyfill

function EventEmitter() {
  if (!this._events || !Object.prototype.hasOwnProperty.call(this, '_events')) {
    this._events = objectCreate(null);
    this._eventsCount = 0;
  }

  this._maxListeners = this._maxListeners || undefined;
}
module.exports = EventEmitter;

// Backwards-compat with node 0.10.x
EventEmitter.EventEmitter = EventEmitter;

EventEmitter.prototype._events = undefined;
EventEmitter.prototype._maxListeners = undefined;

// By default EventEmitters will print a warning if more than 10 listeners are
// added to it. This is a useful default which helps finding memory leaks.
var defaultMaxListeners = 10;

var hasDefineProperty;
try {
  var o = {};
  if (Object.defineProperty) Object.defineProperty(o, 'x', { value: 0 });
  hasDefineProperty = o.x === 0;
} catch (err) { hasDefineProperty = false }
if (hasDefineProperty) {
  Object.defineProperty(EventEmitter, 'defaultMaxListeners', {
    enumerable: true,
    get: function() {
      return defaultMaxListeners;
    },
    set: function(arg) {
      // check whether the input is a positive number (whose value is zero or
      // greater and not a NaN).
      if (typeof arg !== 'number' || arg < 0 || arg !== arg)
        throw new TypeError('"defaultMaxListeners" must be a positive number');
      defaultMaxListeners = arg;
    }
  });
} else {
  EventEmitter.defaultMaxListeners = defaultMaxListeners;
}

// Obviously not all Emitters should be limited to 10. This function allows
// that to be increased. Set to zero for unlimited.
EventEmitter.prototype.setMaxListeners = function setMaxListeners(n) {
  if (typeof n !== 'number' || n < 0 || isNaN(n))
    throw new TypeError('"n" argument must be a positive number');
  this._maxListeners = n;
  return this;
};

function $getMaxListeners(that) {
  if (that._maxListeners === undefined)
    return EventEmitter.defaultMaxListeners;
  return that._maxListeners;
}

EventEmitter.prototype.getMaxListeners = function getMaxListeners() {
  return $getMaxListeners(this);
};

// These standalone emit* functions are used to optimize calling of event
// handlers for fast cases because emit() itself often has a variable number of
// arguments and can be deoptimized because of that. These functions always have
// the same number of arguments and thus do not get deoptimized, so the code
// inside them can execute faster.
function emitNone(handler, isFn, self) {
  if (isFn)
    handler.call(self);
  else {
    var len = handler.length;
    var listeners = arrayClone(handler, len);
    for (var i = 0; i < len; ++i)
      listeners[i].call(self);
  }
}
function emitOne(handler, isFn, self, arg1) {
  if (isFn)
    handler.call(self, arg1);
  else {
    var len = handler.length;
    var listeners = arrayClone(handler, len);
    for (var i = 0; i < len; ++i)
      listeners[i].call(self, arg1);
  }
}
function emitTwo(handler, isFn, self, arg1, arg2) {
  if (isFn)
    handler.call(self, arg1, arg2);
  else {
    var len = handler.length;
    var listeners = arrayClone(handler, len);
    for (var i = 0; i < len; ++i)
      listeners[i].call(self, arg1, arg2);
  }
}
function emitThree(handler, isFn, self, arg1, arg2, arg3) {
  if (isFn)
    handler.call(self, arg1, arg2, arg3);
  else {
    var len = handler.length;
    var listeners = arrayClone(handler, len);
    for (var i = 0; i < len; ++i)
      listeners[i].call(self, arg1, arg2, arg3);
  }
}

function emitMany(handler, isFn, self, args) {
  if (isFn)
    handler.apply(self, args);
  else {
    var len = handler.length;
    var listeners = arrayClone(handler, len);
    for (var i = 0; i < len; ++i)
      listeners[i].apply(self, args);
  }
}

EventEmitter.prototype.emit = function emit(type) {
  var er, handler, len, args, i, events;
  var doError = (type === 'error');

  events = this._events;
  if (events)
    doError = (doError && events.error == null);
  else if (!doError)
    return false;

  // If there is no 'error' event listener then throw.
  if (doError) {
    if (arguments.length > 1)
      er = arguments[1];
    if (er instanceof Error) {
      throw er; // Unhandled 'error' event
    } else {
      // At least give some kind of context to the user
      var err = new Error('Unhandled "error" event. (' + er + ')');
      err.context = er;
      throw err;
    }
    return false;
  }

  handler = events[type];

  if (!handler)
    return false;

  var isFn = typeof handler === 'function';
  len = arguments.length;
  switch (len) {
      // fast cases
    case 1:
      emitNone(handler, isFn, this);
      break;
    case 2:
      emitOne(handler, isFn, this, arguments[1]);
      break;
    case 3:
      emitTwo(handler, isFn, this, arguments[1], arguments[2]);
      break;
    case 4:
      emitThree(handler, isFn, this, arguments[1], arguments[2], arguments[3]);
      break;
      // slower
    default:
      args = new Array(len - 1);
      for (i = 1; i < len; i++)
        args[i - 1] = arguments[i];
      emitMany(handler, isFn, this, args);
  }

  return true;
};

function _addListener(target, type, listener, prepend) {
  var m;
  var events;
  var existing;

  if (typeof listener !== 'function')
    throw new TypeError('"listener" argument must be a function');

  events = target._events;
  if (!events) {
    events = target._events = objectCreate(null);
    target._eventsCount = 0;
  } else {
    // To avoid recursion in the case that type === "newListener"! Before
    // adding it to the listeners, first emit "newListener".
    if (events.newListener) {
      target.emit('newListener', type,
          listener.listener ? listener.listener : listener);

      // Re-assign `events` because a newListener handler could have caused the
      // this._events to be assigned to a new object
      events = target._events;
    }
    existing = events[type];
  }

  if (!existing) {
    // Optimize the case of one listener. Don't need the extra array object.
    existing = events[type] = listener;
    ++target._eventsCount;
  } else {
    if (typeof existing === 'function') {
      // Adding the second element, need to change to array.
      existing = events[type] =
          prepend ? [listener, existing] : [existing, listener];
    } else {
      // If we've already got an array, just append.
      if (prepend) {
        existing.unshift(listener);
      } else {
        existing.push(listener);
      }
    }

    // Check for listener leak
    if (!existing.warned) {
      m = $getMaxListeners(target);
      if (m && m > 0 && existing.length > m) {
        existing.warned = true;
        var w = new Error('Possible EventEmitter memory leak detected. ' +
            existing.length + ' "' + String(type) + '" listeners ' +
            'added. Use emitter.setMaxListeners() to ' +
            'increase limit.');
        w.name = 'MaxListenersExceededWarning';
        w.emitter = target;
        w.type = type;
        w.count = existing.length;
        if (typeof console === 'object' && console.warn) {
          console.warn('%s: %s', w.name, w.message);
        }
      }
    }
  }

  return target;
}

EventEmitter.prototype.addListener = function addListener(type, listener) {
  return _addListener(this, type, listener, false);
};

EventEmitter.prototype.on = EventEmitter.prototype.addListener;

EventEmitter.prototype.prependListener =
    function prependListener(type, listener) {
      return _addListener(this, type, listener, true);
    };

function onceWrapper() {
  if (!this.fired) {
    this.target.removeListener(this.type, this.wrapFn);
    this.fired = true;
    switch (arguments.length) {
      case 0:
        return this.listener.call(this.target);
      case 1:
        return this.listener.call(this.target, arguments[0]);
      case 2:
        return this.listener.call(this.target, arguments[0], arguments[1]);
      case 3:
        return this.listener.call(this.target, arguments[0], arguments[1],
            arguments[2]);
      default:
        var args = new Array(arguments.length);
        for (var i = 0; i < args.length; ++i)
          args[i] = arguments[i];
        this.listener.apply(this.target, args);
    }
  }
}

function _onceWrap(target, type, listener) {
  var state = { fired: false, wrapFn: undefined, target: target, type: type, listener: listener };
  var wrapped = bind.call(onceWrapper, state);
  wrapped.listener = listener;
  state.wrapFn = wrapped;
  return wrapped;
}

EventEmitter.prototype.once = function once(type, listener) {
  if (typeof listener !== 'function')
    throw new TypeError('"listener" argument must be a function');
  this.on(type, _onceWrap(this, type, listener));
  return this;
};

EventEmitter.prototype.prependOnceListener =
    function prependOnceListener(type, listener) {
      if (typeof listener !== 'function')
        throw new TypeError('"listener" argument must be a function');
      this.prependListener(type, _onceWrap(this, type, listener));
      return this;
    };

// Emits a 'removeListener' event if and only if the listener was removed.
EventEmitter.prototype.removeListener =
    function removeListener(type, listener) {
      var list, events, position, i, originalListener;

      if (typeof listener !== 'function')
        throw new TypeError('"listener" argument must be a function');

      events = this._events;
      if (!events)
        return this;

      list = events[type];
      if (!list)
        return this;

      if (list === listener || list.listener === listener) {
        if (--this._eventsCount === 0)
          this._events = objectCreate(null);
        else {
          delete events[type];
          if (events.removeListener)
            this.emit('removeListener', type, list.listener || listener);
        }
      } else if (typeof list !== 'function') {
        position = -1;

        for (i = list.length - 1; i >= 0; i--) {
          if (list[i] === listener || list[i].listener === listener) {
            originalListener = list[i].listener;
            position = i;
            break;
          }
        }

        if (position < 0)
          return this;

        if (position === 0)
          list.shift();
        else
          spliceOne(list, position);

        if (list.length === 1)
          events[type] = list[0];

        if (events.removeListener)
          this.emit('removeListener', type, originalListener || listener);
      }

      return this;
    };

EventEmitter.prototype.removeAllListeners =
    function removeAllListeners(type) {
      var listeners, events, i;

      events = this._events;
      if (!events)
        return this;

      // not listening for removeListener, no need to emit
      if (!events.removeListener) {
        if (arguments.length === 0) {
          this._events = objectCreate(null);
          this._eventsCount = 0;
        } else if (events[type]) {
          if (--this._eventsCount === 0)
            this._events = objectCreate(null);
          else
            delete events[type];
        }
        return this;
      }

      // emit removeListener for all listeners on all events
      if (arguments.length === 0) {
        var keys = objectKeys(events);
        var key;
        for (i = 0; i < keys.length; ++i) {
          key = keys[i];
          if (key === 'removeListener') continue;
          this.removeAllListeners(key);
        }
        this.removeAllListeners('removeListener');
        this._events = objectCreate(null);
        this._eventsCount = 0;
        return this;
      }

      listeners = events[type];

      if (typeof listeners === 'function') {
        this.removeListener(type, listeners);
      } else if (listeners) {
        // LIFO order
        for (i = listeners.length - 1; i >= 0; i--) {
          this.removeListener(type, listeners[i]);
        }
      }

      return this;
    };

function _listeners(target, type, unwrap) {
  var events = target._events;

  if (!events)
    return [];

  var evlistener = events[type];
  if (!evlistener)
    return [];

  if (typeof evlistener === 'function')
    return unwrap ? [evlistener.listener || evlistener] : [evlistener];

  return unwrap ? unwrapListeners(evlistener) : arrayClone(evlistener, evlistener.length);
}

EventEmitter.prototype.listeners = function listeners(type) {
  return _listeners(this, type, true);
};

EventEmitter.prototype.rawListeners = function rawListeners(type) {
  return _listeners(this, type, false);
};

EventEmitter.listenerCount = function(emitter, type) {
  if (typeof emitter.listenerCount === 'function') {
    return emitter.listenerCount(type);
  } else {
    return listenerCount.call(emitter, type);
  }
};

EventEmitter.prototype.listenerCount = listenerCount;
function listenerCount(type) {
  var events = this._events;

  if (events) {
    var evlistener = events[type];

    if (typeof evlistener === 'function') {
      return 1;
    } else if (evlistener) {
      return evlistener.length;
    }
  }

  return 0;
}

EventEmitter.prototype.eventNames = function eventNames() {
  return this._eventsCount > 0 ? Reflect.ownKeys(this._events) : [];
};

// About 1.5x faster than the two-arg version of Array#splice().
function spliceOne(list, index) {
  for (var i = index, k = i + 1, n = list.length; k < n; i += 1, k += 1)
    list[i] = list[k];
  list.pop();
}

function arrayClone(arr, n) {
  var copy = new Array(n);
  for (var i = 0; i < n; ++i)
    copy[i] = arr[i];
  return copy;
}

function unwrapListeners(arr) {
  var ret = new Array(arr.length);
  for (var i = 0; i < ret.length; ++i) {
    ret[i] = arr[i].listener || arr[i];
  }
  return ret;
}

function objectCreatePolyfill(proto) {
  var F = function() {};
  F.prototype = proto;
  return new F;
}
function objectKeysPolyfill(obj) {
  var keys = [];
  for (var k in obj) if (Object.prototype.hasOwnProperty.call(obj, k)) {
    keys.push(k);
  }
  return k;
}
function functionBindPolyfill(context) {
  var fn = this;
  return function () {
    return fn.apply(context, arguments);
  };
}

},{}],5:[function(require,module,exports){
(function (process){
// .dirname, .basename, and .extname methods are extracted from Node.js v8.11.1,
// backported and transplited with Babel, with backwards-compat fixes

// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

// resolves . and .. elements in a path array with directory names there
// must be no slashes, empty elements, or device names (c:\) in the array
// (so also no leading and trailing slashes - it does not distinguish
// relative and absolute paths)
function normalizeArray(parts, allowAboveRoot) {
  // if the path tries to go above the root, `up` ends up > 0
  var up = 0;
  for (var i = parts.length - 1; i >= 0; i--) {
    var last = parts[i];
    if (last === '.') {
      parts.splice(i, 1);
    } else if (last === '..') {
      parts.splice(i, 1);
      up++;
    } else if (up) {
      parts.splice(i, 1);
      up--;
    }
  }

  // if the path is allowed to go above the root, restore leading ..s
  if (allowAboveRoot) {
    for (; up--; up) {
      parts.unshift('..');
    }
  }

  return parts;
}

// path.resolve([from ...], to)
// posix version
exports.resolve = function() {
  var resolvedPath = '',
      resolvedAbsolute = false;

  for (var i = arguments.length - 1; i >= -1 && !resolvedAbsolute; i--) {
    var path = (i >= 0) ? arguments[i] : process.cwd();

    // Skip empty and invalid entries
    if (typeof path !== 'string') {
      throw new TypeError('Arguments to path.resolve must be strings');
    } else if (!path) {
      continue;
    }

    resolvedPath = path + '/' + resolvedPath;
    resolvedAbsolute = path.charAt(0) === '/';
  }

  // At this point the path should be resolved to a full absolute path, but
  // handle relative paths to be safe (might happen when process.cwd() fails)

  // Normalize the path
  resolvedPath = normalizeArray(filter(resolvedPath.split('/'), function(p) {
    return !!p;
  }), !resolvedAbsolute).join('/');

  return ((resolvedAbsolute ? '/' : '') + resolvedPath) || '.';
};

// path.normalize(path)
// posix version
exports.normalize = function(path) {
  var isAbsolute = exports.isAbsolute(path),
      trailingSlash = substr(path, -1) === '/';

  // Normalize the path
  path = normalizeArray(filter(path.split('/'), function(p) {
    return !!p;
  }), !isAbsolute).join('/');

  if (!path && !isAbsolute) {
    path = '.';
  }
  if (path && trailingSlash) {
    path += '/';
  }

  return (isAbsolute ? '/' : '') + path;
};

// posix version
exports.isAbsolute = function(path) {
  return path.charAt(0) === '/';
};

// posix version
exports.join = function() {
  var paths = Array.prototype.slice.call(arguments, 0);
  return exports.normalize(filter(paths, function(p, index) {
    if (typeof p !== 'string') {
      throw new TypeError('Arguments to path.join must be strings');
    }
    return p;
  }).join('/'));
};


// path.relative(from, to)
// posix version
exports.relative = function(from, to) {
  from = exports.resolve(from).substr(1);
  to = exports.resolve(to).substr(1);

  function trim(arr) {
    var start = 0;
    for (; start < arr.length; start++) {
      if (arr[start] !== '') break;
    }

    var end = arr.length - 1;
    for (; end >= 0; end--) {
      if (arr[end] !== '') break;
    }

    if (start > end) return [];
    return arr.slice(start, end - start + 1);
  }

  var fromParts = trim(from.split('/'));
  var toParts = trim(to.split('/'));

  var length = Math.min(fromParts.length, toParts.length);
  var samePartsLength = length;
  for (var i = 0; i < length; i++) {
    if (fromParts[i] !== toParts[i]) {
      samePartsLength = i;
      break;
    }
  }

  var outputParts = [];
  for (var i = samePartsLength; i < fromParts.length; i++) {
    outputParts.push('..');
  }

  outputParts = outputParts.concat(toParts.slice(samePartsLength));

  return outputParts.join('/');
};

exports.sep = '/';
exports.delimiter = ':';

exports.dirname = function (path) {
  if (typeof path !== 'string') path = path + '';
  if (path.length === 0) return '.';
  var code = path.charCodeAt(0);
  var hasRoot = code === 47 /*/*/;
  var end = -1;
  var matchedSlash = true;
  for (var i = path.length - 1; i >= 1; --i) {
    code = path.charCodeAt(i);
    if (code === 47 /*/*/) {
        if (!matchedSlash) {
          end = i;
          break;
        }
      } else {
      // We saw the first non-path separator
      matchedSlash = false;
    }
  }

  if (end === -1) return hasRoot ? '/' : '.';
  if (hasRoot && end === 1) {
    // return '//';
    // Backwards-compat fix:
    return '/';
  }
  return path.slice(0, end);
};

function basename(path) {
  if (typeof path !== 'string') path = path + '';

  var start = 0;
  var end = -1;
  var matchedSlash = true;
  var i;

  for (i = path.length - 1; i >= 0; --i) {
    if (path.charCodeAt(i) === 47 /*/*/) {
        // If we reached a path separator that was not part of a set of path
        // separators at the end of the string, stop now
        if (!matchedSlash) {
          start = i + 1;
          break;
        }
      } else if (end === -1) {
      // We saw the first non-path separator, mark this as the end of our
      // path component
      matchedSlash = false;
      end = i + 1;
    }
  }

  if (end === -1) return '';
  return path.slice(start, end);
}

// Uses a mixed approach for backwards-compatibility, as ext behavior changed
// in new Node.js versions, so only basename() above is backported here
exports.basename = function (path, ext) {
  var f = basename(path);
  if (ext && f.substr(-1 * ext.length) === ext) {
    f = f.substr(0, f.length - ext.length);
  }
  return f;
};

exports.extname = function (path) {
  if (typeof path !== 'string') path = path + '';
  var startDot = -1;
  var startPart = 0;
  var end = -1;
  var matchedSlash = true;
  // Track the state of characters (if any) we see before our first dot and
  // after any path separator we find
  var preDotState = 0;
  for (var i = path.length - 1; i >= 0; --i) {
    var code = path.charCodeAt(i);
    if (code === 47 /*/*/) {
        // If we reached a path separator that was not part of a set of path
        // separators at the end of the string, stop now
        if (!matchedSlash) {
          startPart = i + 1;
          break;
        }
        continue;
      }
    if (end === -1) {
      // We saw the first non-path separator, mark this as the end of our
      // extension
      matchedSlash = false;
      end = i + 1;
    }
    if (code === 46 /*.*/) {
        // If this is our first dot, mark it as the start of our extension
        if (startDot === -1)
          startDot = i;
        else if (preDotState !== 1)
          preDotState = 1;
    } else if (startDot !== -1) {
      // We saw a non-dot and non-path separator before our dot, so we should
      // have a good chance at having a non-empty extension
      preDotState = -1;
    }
  }

  if (startDot === -1 || end === -1 ||
      // We saw a non-dot character immediately before the dot
      preDotState === 0 ||
      // The (right-most) trimmed path component is exactly '..'
      preDotState === 1 && startDot === end - 1 && startDot === startPart + 1) {
    return '';
  }
  return path.slice(startDot, end);
};

function filter (xs, f) {
    if (xs.filter) return xs.filter(f);
    var res = [];
    for (var i = 0; i < xs.length; i++) {
        if (f(xs[i], i, xs)) res.push(xs[i]);
    }
    return res;
}

// String.prototype.substr - negative index don't work in IE8
var substr = 'ab'.substr(-1) === 'b'
    ? function (str, start, len) { return str.substr(start, len) }
    : function (str, start, len) {
        if (start < 0) start = str.length + start;
        return str.substr(start, len);
    }
;

}).call(this,require('_process'))
},{"_process":6}],6:[function(require,module,exports){
// shim for using process in browser
var process = module.exports = {};

// cached from whatever global is present so that test runners that stub it
// don't break things.  But we need to wrap it in a try catch in case it is
// wrapped in strict mode code which doesn't define any globals.  It's inside a
// function because try/catches deoptimize in certain engines.

var cachedSetTimeout;
var cachedClearTimeout;

function defaultSetTimout() {
    throw new Error('setTimeout has not been defined');
}
function defaultClearTimeout () {
    throw new Error('clearTimeout has not been defined');
}
(function () {
    try {
        if (typeof setTimeout === 'function') {
            cachedSetTimeout = setTimeout;
        } else {
            cachedSetTimeout = defaultSetTimout;
        }
    } catch (e) {
        cachedSetTimeout = defaultSetTimout;
    }
    try {
        if (typeof clearTimeout === 'function') {
            cachedClearTimeout = clearTimeout;
        } else {
            cachedClearTimeout = defaultClearTimeout;
        }
    } catch (e) {
        cachedClearTimeout = defaultClearTimeout;
    }
} ())
function runTimeout(fun) {
    if (cachedSetTimeout === setTimeout) {
        //normal enviroments in sane situations
        return setTimeout(fun, 0);
    }
    // if setTimeout wasn't available but was latter defined
    if ((cachedSetTimeout === defaultSetTimout || !cachedSetTimeout) && setTimeout) {
        cachedSetTimeout = setTimeout;
        return setTimeout(fun, 0);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedSetTimeout(fun, 0);
    } catch(e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't trust the global object when called normally
            return cachedSetTimeout.call(null, fun, 0);
        } catch(e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error
            return cachedSetTimeout.call(this, fun, 0);
        }
    }


}
function runClearTimeout(marker) {
    if (cachedClearTimeout === clearTimeout) {
        //normal enviroments in sane situations
        return clearTimeout(marker);
    }
    // if clearTimeout wasn't available but was latter defined
    if ((cachedClearTimeout === defaultClearTimeout || !cachedClearTimeout) && clearTimeout) {
        cachedClearTimeout = clearTimeout;
        return clearTimeout(marker);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedClearTimeout(marker);
    } catch (e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't  trust the global object when called normally
            return cachedClearTimeout.call(null, marker);
        } catch (e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error.
            // Some versions of I.E. have different rules for clearTimeout vs setTimeout
            return cachedClearTimeout.call(this, marker);
        }
    }



}
var queue = [];
var draining = false;
var currentQueue;
var queueIndex = -1;

function cleanUpNextTick() {
    if (!draining || !currentQueue) {
        return;
    }
    draining = false;
    if (currentQueue.length) {
        queue = currentQueue.concat(queue);
    } else {
        queueIndex = -1;
    }
    if (queue.length) {
        drainQueue();
    }
}

function drainQueue() {
    if (draining) {
        return;
    }
    var timeout = runTimeout(cleanUpNextTick);
    draining = true;

    var len = queue.length;
    while(len) {
        currentQueue = queue;
        queue = [];
        while (++queueIndex < len) {
            if (currentQueue) {
                currentQueue[queueIndex].run();
            }
        }
        queueIndex = -1;
        len = queue.length;
    }
    currentQueue = null;
    draining = false;
    runClearTimeout(timeout);
}

process.nextTick = function (fun) {
    var args = new Array(arguments.length - 1);
    if (arguments.length > 1) {
        for (var i = 1; i < arguments.length; i++) {
            args[i - 1] = arguments[i];
        }
    }
    queue.push(new Item(fun, args));
    if (queue.length === 1 && !draining) {
        runTimeout(drainQueue);
    }
};

// v8 likes predictible objects
function Item(fun, array) {
    this.fun = fun;
    this.array = array;
}
Item.prototype.run = function () {
    this.fun.apply(null, this.array);
};
process.title = 'browser';
process.browser = true;
process.env = {};
process.argv = [];
process.version = ''; // empty string to avoid regexp issues
process.versions = {};

function noop() {}

process.on = noop;
process.addListener = noop;
process.once = noop;
process.off = noop;
process.removeListener = noop;
process.removeAllListeners = noop;
process.emit = noop;
process.prependListener = noop;
process.prependOnceListener = noop;

process.listeners = function (name) { return [] }

process.binding = function (name) {
    throw new Error('process.binding is not supported');
};

process.cwd = function () { return '/' };
process.chdir = function (dir) {
    throw new Error('process.chdir is not supported');
};
process.umask = function() { return 0; };

},{}]},{},[2]);
