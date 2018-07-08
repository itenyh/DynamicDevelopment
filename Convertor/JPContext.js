var allParesedLocalSelectors = [];
var delayParsedContexts = [];	//{locationMark:"###1###", context:context}
var hasExclusiveMethod = false;
var isFinishedParsed = false;

/////////////////Base
var JPContext = function() {
	this.next = null;
	this.pre = null;
	this.currIdx = 0;
}

JPContext.prototype.parse = function() {
	return ''
}

JPContext.prototype.setNext = function(ctx) {
	ctx.pre = this;
	if (this.next) {
		this.next.next = ctx;
	} else {
		this.next = ctx;
	}
}


/////////////////JPCommonContext
var JPCommonContext = function(str) {
	//找到property属性
    if (/(\.[a-zA-z_]{1}[a-zA-z_1-9]*)/g.test(str)) {
    	var isStartWith_ = str.indexOf('_') == 0;
    	if (isStartWith_) {
    		str = str.substring(1);
		}
        str = str.replace(/_/g,'__');
    	if (isStartWith_) {
    		str = '_' + str;
		}
    }
    this.str = str;
}

JPCommonContext.prototype = Object.create(JPContext.prototype);
JPCommonContext.prototype.parse = function() {
	return this.str ? this.str : '';
}


/////////////////JPBridgeContext
var JPBridgeContext = function() {

}
JPBridgeContext.prototype = Object.create(JPContext.prototype);
JPBridgeContext.prototype.parse = function() {
	var ctx = this;
	var script = '';
	while (ctx = ctx.next) {
		script += ctx.parse();
	}
	return script;
}



/////////////////JPClassContext

var JPClassContext = function(className) {
	this.className = className;
	this.instanceMethods = [];
	this.classMethods = [];
	this.ignore = 0;
    this.startStopIndex = null;
}
JPClassContext.prototype = Object.create(JPContext.prototype);
JPClassContext.prototype.parse = function(){

    for (var i = 0; i < this.instanceMethods.length; i ++) {
        if (this.instanceMethods[i].exclusive) {
            hasExclusiveMethod = true;
            break;
        }
    }

    for (var i = 0; i < this.classMethods.length; i ++) {
        if (this.classMethods[i].exclusive) {
            hasExclusiveMethod = true;
            break;
        }
    }

	var script = this.ignore ? '' : "defineClass('" + this.className + "', {";
	for (var i = 0; i < this.instanceMethods.length; i ++) {
		if (hasExclusiveMethod && !this.instanceMethods[i].exclusive) {
			continue;
		}
		var separator = this.ignore && this.instanceMethods.length <= 1 ? '': ',';
		script += this.instanceMethods[i].parse() + separator;
	}
	script += this.ignore ? '' : '}';
	if (this.classMethods.length) {
		script += this.ignore ? '' : ',{';
		for (var i = 0; i < this.classMethods.length; i ++) {
            if (hasExclusiveMethod && !this.classMethods[i].exclusive) {
                continue;
            }
			var separator = this.ignore && this.classMethods.length <= 1 ? '': ','
			script += this.classMethods[i].parse() + separator;
		}
		script += this.ignore ? '' : '}'
	}
	script += this.ignore ? '' : ');';

	isFinishedParsed = true;
	for (var i in delayParsedContexts) {
		var locationMark = delayParsedContexts[i]['locationMark'];
		var context = delayParsedContexts[i]['context'];
        script = script.replace(locationMark, context.parse());
	}

	return script;
 }


/////////////////JPMethodContext

var JPMethodContext = function() {
	this.names = [];
	this.params = [];
	this.ignore = 0;

	this.exclusive = false;
	this.stopIndex = null;
	this.preMethod = null;
	this.nextMethod = null;
}
JPMethodContext.prototype = Object.create(JPContext.prototype);
JPMethodContext.prototype.parse = function(){
	var ctx = this;
	var script = ''
	if (!this.ignore) {
		var firstName = this.names[0]
		if (firstName[0] == '_') {
			// 处理下划线开头函数名
			firstName = "_" + firstName;
			this.names[0] = firstName;
		}
		script = this.names.join('_') + ": function(" + this.params.join(',') + ") {"
	}

	while (ctx = ctx.next) {
		script += ctx.parse();
	} 
	script += this.ignore ? '' : '}'
	return script;
}


/////////////////JPMsgContext

var JPMsgContext = function() {
	this.receiver = null;
	this.selector = [];
	this.parsedSelector = null;
	this.preMsg = null;

	this.argumentIndex = 0;
}

JPMsgContext.prototype = Object.create(JPContext.prototype);

JPMsgContext.prototype.parse = function() {
	var code = '';
	if (typeof this.receiver == "string") {
        if (this.receiver.indexOf('_') == 0) {
        	var receivers = this.receiver.split('.');
            code += 'self' + '|__dot__|' + "getProp('" + receivers.shift().substr(1).trim() + "')";
            if (receivers.length > 0) {
            	code += '.' + receivers.join('.');
			}
        }
        else {
            code += this.receiver;
        }
	} else {
		code += this.receiver.parse();
	}

	var funcName = [];
	var params = [];
	for (var i = 0; i < this.selector.length; i ++) {
		var name = this.selector[i].name.replace(/_/g, '__');
		funcName.push(name);
		if (typeof this.selector[i].param == "string") {
			params.push(this.selector[i].param);
		} else if (this.selector[i].param) {
			params.push(this.selector[i].param.parse());
		}
	}

	this.parsedSelector = funcName.join('_');
	if (this.receiver === 'self') {
		allParesedLocalSelectors.push(this.parsedSelector);
    }
	code += '|__dot__|' + this.parsedSelector + '(' + params.join(',') + ')';
	return code;
}

/////////////////JPParamContext

var JPParamContext = function() {
	this.parent = null;
}

JPParamContext.prototype = Object.create(JPBridgeContext.prototype);


/////////////////JPBlockContext

var JPBlockContext = function() {
	this.types = [];
	this.names = [];
	this.msg = null;
	this.content = null;
}

JPBlockContext.prototype = Object.create(JPContext.prototype);
JPBlockContext.prototype.parse = function(){

	//如果作为参数的block，要等所有的解析完成后，再解析
	if (this.msg && !isFinishedParsed) {
		var locationMark = '####' + delayParsedContexts.length + '####';
		delayParsedContexts.push({locationMark:locationMark, context:this});
		return locationMark;
	}

    var blockSelector = this.msg.parsedSelector;
	var isLocalMethod = false;
	for (var i in allParesedLocalSelectors) {
		var selector = allParesedLocalSelectors[i];
		if (selector === blockSelector) {
			isLocalMethod = true;
			break;
		}
	}

	if (isLocalMethod) {
        var script = 'function(' + this.names.join(',') + ') {';
        return script + this.content.parse() + "}";
	}
	else {
        var paramTypes = this.types.length ? "'void, " + this.types.join(',') + "', " : '';
        var script = 'block(' + paramTypes + 'function(' + this.names.join(',') + ') {';
        return script + this.content.parse() + "})";
	}
}


var JPBlockContentContext = function() {
	this.parent = null;
}

JPBlockContentContext.prototype = Object.create(JPBridgeContext.prototype);


/////////////////JPAssignContext

var JPAssignContext = function() {
	this.left = null;
	this.right = null;
}

JPAssignContext.prototype = Object.create(JPContext.prototype);
JPAssignContext.prototype.parse = function(){
    var leftStr = this.left.parse();
    var leftArr = leftStr.split('.')
    var lastProperty = leftArr[leftArr.length - 1];
    var firstProperty = leftArr[0];
    //动态获取属性值
    if (leftArr.length == 1 && lastProperty[0] == '_') {
        return 'self' + '|__dot__|' + 'setProp_forKey(' + this.right.parse() + ", '" + lastProperty.substr(1).trim() + "')";
    }
    else if (firstProperty[0] == '_' && leftArr.length > 1) {
        leftArr.splice(-1);
        leftArr.splice(0);
        leftStr = 'self' + '|__dot__|' + "getProp('" + firstProperty.substr(1).trim() +"')" + leftArr.join('.') + '|__dot__|' + 'set' + lastProperty[0].toUpperCase() + lastProperty.substr(1);
        return leftStr + '(' + this.right.parse() + ')';
    }
    else {
        leftArr.splice(-1);
        leftStr = leftArr.join('.') + '|__dot__|' + 'set' + lastProperty[0].toUpperCase() + lastProperty.substr(1);
        return leftStr + '(' + this.right.parse() + ')'
    }
}



var JPAssignLeftContext = function() {
	this.parent = null;
}
JPAssignLeftContext.prototype = Object.create(JPBridgeContext.prototype);


var JPAssignRightContext = function() {
	this.parent = null;
}
JPAssignRightContext.prototype = Object.create(JPBridgeContext.prototype);




/////////////////JPDeclarationContext

var JPDeclarationContext = function() {
	this.parent = null;
}
JPDeclarationContext.prototype = Object.create(JPContext.prototype);
JPDeclarationContext.prototype.parse = function(){
	return 'var ';
}


/////////////////exports

exports.JPCommonContext = JPCommonContext;
exports.JPMsgContext = JPMsgContext;
exports.JPParamContext = JPParamContext;
exports.JPBlockContext = JPBlockContext;
exports.JPBlockContentContext = JPBlockContentContext;
exports.JPAssignContext = JPAssignContext;
exports.JPAssignLeftContext = JPAssignLeftContext;
exports.JPAssignRightContext = JPAssignRightContext;
exports.JPDeclarationContext = JPDeclarationContext;
exports.JPClassContext = JPClassContext;
exports.JPMethodContext = JPMethodContext;
