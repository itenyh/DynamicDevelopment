// JPObjCListener
var ObjCListener = require('./parser/ObjectiveCParserListener').ObjectiveCParserListener
var c = require('./JPContext')
var JPCommonContext = c.JPCommonContext,
    JPMsgContext = c.JPMsgContext,
    JPParamContext = c.JPParamContext,
    JPBlockContext = c.JPBlockContext,
    JPBlockContentContext = c.JPBlockContentContext,
    JPAssignContext = c.JPAssignContext,
    JPAssignLeftContext = c.JPAssignLeftContext,
    JPAssignRightContext = c.JPAssignRightContext,
    JPDeclarationContext = c.JPDeclarationContext,
    JPClassContext = c.JPClassContext,
    JPMethodContext = c.JPMethodContext,
    JPPropertyCallingContext = c.JPPropertyCallingContext,
    JPPropertyCallerContext = c.JPPropertyCallerContext;

var excludeClassNames = [
    'BOOL',
    'NSInteger',
    'NSUInteger',
    'CGFloat',
    'CGRect',
    'NSRange',
    'CGSize',
    'CGPoint'
];


var JPObjCListener = function(cb) {

    ObjCListener.call(this);
    this.rootContext = new JPClassContext();
    this.currContext = this.rootContext;
    this.ocScript = '';
    this.requireClasses = [];
    this.ignoreClass = 0;
    this.ignoreMethod = 0;
    this.cb = cb;

    return this;
}

JPObjCListener.prototype = Object.create(ObjCListener.prototype);

JPObjCListener.prototype.buildScript = function() {
    var requires = '';
    if (this.requireClasses.length) {
        requires = "require('" + this.requireClasses.join(',') + "');\n";
    }
    this.cb(requires + this.rootContext.parse(), this.rootContext.className);
}

JPObjCListener.prototype.addStrContext = function(stop) {
    var strContext = new JPCommonContext(this.ocScript.substring(this.currContext.currIdx, stop))
    this.currContext.setNext(strContext);
    return strContext;
}

exports.JPObjCListener = JPObjCListener;

// Enter a parse tree produced by ObjectiveCParser#classImplementation.
JPObjCListener.prototype.enterClassImplementation = function(ctx) {
    this.ocScript = ctx.start.source[1].strdata;
    this.currContext.className = ctx.genericTypeSpecifier().getText();
    this.currContext.ignore = this.ignoreClass;
};

// Exit a parse tree produced by ObjectiveCParser#classImplementation.
JPObjCListener.prototype.exitClassImplementation = function(ctx) {
    this.buildScript();
};

// Enter a parse tree produced by ObjectiveCParser#classMethodDefinition.
JPObjCListener.prototype.enterClassMethodDefinition = function(ctx) {
    var methodContext = new JPMethodContext();
    methodContext.ignore = this.ignoreMethod;
    this.rootContext.classMethods.push(methodContext);
    this.currContext = methodContext;
};

// Exit a parse tree produced by ObjectiveCParser#classMethodDefinition.
JPObjCListener.prototype.exitClassMethodDefinition = function(ctx) {};

// Enter a parse tree produced by ObjectiveCParser#instanceMethodDefinition.
JPObjCListener.prototype.enterInstanceMethodDefinition = function(ctx) {
    var methodContext = new JPMethodContext();
    methodContext.ignore = this.ignoreMethod;
    this.rootContext.instanceMethods.push(methodContext);
    this.currContext = methodContext;
};

// Exit a parse tree produced by ObjectiveCParser#instanceMethodDefinition.
JPObjCListener.prototype.exitInstanceMethodDefinition = function(ctx) {};

// Enter a parse tree produced by ObjectiveCParser#methodDefinition.
JPObjCListener.prototype.enterMethodDefinition = function(ctx) {
    var names = [],
        params = [];
    var methodSelectorContext = ctx.methodSelector();
    for (var i in methodSelectorContext.children) {
        var keywordDeclaratorContext = methodSelectorContext.children[i];
        names.push(keywordDeclaratorContext.start.text);
        if (keywordDeclaratorContext.stop.start != keywordDeclaratorContext.start.start) {
            params.push(keywordDeclaratorContext.stop.text)
        }
    }

    //currContext is JPMethodContext
    this.currContext.names = names;
    this.currContext.params = params;
    this.currContext.currIdx = ctx.compoundStatement().start.start + 1;
};

// Exit a parse tree produced by ObjectiveCParser#methodDefinition.
JPObjCListener.prototype.exitMethodDefinition = function(ctx) {
    this.addStrContext(ctx.stop.stop)
};

// Enter a parse tree produced by ObjectiveCParser#blockExpression.
JPObjCListener.prototype.enterBlockExpression = function(ctx) {
    var strContext = this.addStrContext(ctx.start.start)
    this.currContext = strContext;

    var blockContext = new JPBlockContext();

    var isParamBlock = true;
    var preContext = this.currContext;
    while (!(preContext instanceof JPParamContext)) {
        preContext = preContext.pre;
        if (!preContext) {
            isParamBlock = false;
            break;
        }
    }
    if (isParamBlock) {
        blockContext.msg = preContext.parent;
    }

    this.currContext.setNext(blockContext);
    blockContext.currIdx = ctx.start.stop + 1

    var blockContentContext = new JPBlockContentContext();
    blockContentContext.parent = blockContext;
    blockContext.content = blockContentContext;
    this.currContext = blockContentContext;
};

// Exit a parse tree produced by ObjectiveCParser#blockExpression.
JPObjCListener.prototype.exitBlockExpression = function(ctx) {
    this.addStrContext(ctx.stop.start);

    var preContext = this.currContext;
    while (!preContext.parent) {
        preContext = preContext.pre;
        if (!preContext) {
            throw new Error('block parse fail');
        }
    }
    this.currContext = preContext.parent;

    this.currContext.currIdx = ctx.stop.stop + 1
};

// Enter a parse tree produced by ObjectiveCParser#blockParameters.
JPObjCListener.prototype.enterBlockParameters = function(ctx) {
    if (this.currContext instanceof JPBlockContentContext) {
        var paramsCtxs = ctx.typeVariableDeclaratorOrName();
        for (var i = 0; i < paramsCtxs.length; i ++) {
            var paramsCtx = paramsCtxs[i];
            var paramsString = paramsCtx.getText();
            var name = paramsCtx.stop.text;
            var type = paramsCtx.getText().substring(0, paramsString.length - name.length);
            this.currContext.parent.types.push(type);
            this.currContext.parent.names.push(name);
        }
    }
};

// Exit a parse tree produced by ObjectiveCParser#blockParameters.
JPObjCListener.prototype.exitBlockParameters = function(ctx) {
};

// Enter a parse tree produced by ObjectiveCParser#compoundStatement.
JPObjCListener.prototype.enterCompoundStatement = function(ctx) {
    //if enter block body
    if (this.currContext instanceof JPBlockContentContext) {
        this.currContext.currIdx = ctx.start.stop + 1;
    }
};

// Exit a parse tree produced by ObjectiveCParser#compoundStatement.
JPObjCListener.prototype.exitCompoundStatement = function(ctx) {
};

// Enter a parse tree produced by ObjectiveCParser#messageExpression.
JPObjCListener.prototype.enterMessageExpression = function(ctx) {
    var newMsgContext = new JPMsgContext();
    if (this.currContext instanceof JPMsgContext) {
        //nested method invoke, e.g. [[UIView alloc] init]
        newMsgContext.preMsg = this.currContext;
        this.currContext.receiver = newMsgContext;

    } else {
        var strContext = this.addStrContext(ctx.start.start);
        this.currContext.setNext(strContext);
        strContext.setNext(newMsgContext);
    }
    this.currContext = newMsgContext;
};

// Exit a parse tree produced by ObjectiveCParser#messageExpression.
JPObjCListener.prototype.exitMessageExpression = function(ctx) {
    if (this.currContext.preMsg) {
        this.currContext = this.currContext.preMsg
    } else {
        this.currContext = this.currContext.pre;
    }

    this.currContext.currIdx = ctx.stop.stop + 1
};

// Enter a parse tree produced by ObjectiveCParser#receiver.
JPObjCListener.prototype.enterReceiver = function(ctx) {
    if (ctx.start.text != '[') {
        var receiverName = ctx.start.text;
        if (receiverName[0] >= 'A' && receiverName[0] <= 'Z') {
            // if the first letter is upper case, we take it as a class name
            if (excludeClassNames.indexOf(receiverName) == -1 && this.requireClasses.indexOf(receiverName) == -1) {
                this.requireClasses.push(receiverName);
            }
        }
        this.currContext.receiver = this.ocScript.substring(ctx.start.start, ctx.stop.stop + 1);
    }
};

// Exit a parse tree produced by ObjectiveCParser#receiver.
JPObjCListener.prototype.exitReceiver = function(ctx) {
};


// Enter a parse tree produced by ObjectiveCParser#messageSelector.
JPObjCListener.prototype.enterMessageSelector = function(ctx) {
    for (var i = 0; i < ctx.children.length; i ++) {
        this.currContext.selector.push({
            name: ctx.children[i].start.text,
            param: new JPParamContext()
        })
        this.currContext.argumentIndex = 0;
    }
};

// Exit a parse tree produced by ObjectiveCParser#messageSelector.
JPObjCListener.prototype.exitMessageSelector = function(ctx) {
};

// Enter a parse tree produced by ObjectiveCParser#keywordArgument.
JPObjCListener.prototype.enterKeywordArgument = function(ctx) {
    var paramContext = this.currContext.selector[this.currContext.argumentIndex].param;
    this.currContext.argumentIndex ++;
    paramContext.parent = this.currContext;
    this.currContext = paramContext;
    this.currContext.currIdx = ctx.start.stop + 2
};

// Exit a parse tree produced by ObjectiveCParser#keywordArgument.
JPObjCListener.prototype.exitKeywordArgument = function(ctx) {
    this.addStrContext(ctx.stop.stop + 1)
    var preContext = this.currContext;
    while (!(preContext instanceof JPParamContext)) {
        preContext = preContext.pre;
        if (!preContext) {
            throw new Error('parse argument failed');
        }
    }
    this.currContext = preContext.parent;
};

// Enter a parse tree produced by ObjectiveCParser#declaration.
JPObjCListener.prototype.enterDeclaration = function(ctx) {
    var strContext = this.addStrContext(ctx.start.start);

    var declarationContext = new JPDeclarationContext();
    strContext.setNext(declarationContext);
    this.currContext = declarationContext;

    this.currContext.currIdx = ctx.varDeclaration().initDeclaratorList().initDeclarator()[0].declarator().directDeclarator().start.start;
};

// Exit a parse tree produced by ObjectiveCParser#declaration.
JPObjCListener.prototype.exitDeclaration = function(ctx) {
};

// Enter a parse tree produced by ObjectiveCParser#expressions.
JPObjCListener.prototype.enterExpression = function(ctx) {

    if (ctx.assignmentOperator() && ctx.assignmentOperator().getText() == '=') {
        // var leftStr = ctx.start.source[1].strdata.substring(ctx.children[0].start.start, ctx.children[0].stop.stop + 1)
        // if (leftStr.indexOf('.') > -1 || leftStr.indexOf('_') == 0) {
            var assignContext = new JPAssignContext();

            var assignLeftContext = new JPAssignLeftContext();
            assignLeftContext.parent = assignContext;
            assignContext.left = assignLeftContext;

            var strContext = this.addStrContext(ctx.start.start)
            strContext.setNext(assignContext);

            this.currContext = assignLeftContext;
            this.currContext.currIdx = ctx.start.start;
        // }
    }
};

// Exit a parse tree produced by ObjectiveCParser#expressions.
JPObjCListener.prototype.exitExpression = function(ctx) {
    if (ctx.assignmentOperator() && ctx.assignmentOperator().getText() == '=') {
        // var leftStr = ctx.start.source[1].strdata.substring(ctx.children[0].start.start, ctx.children[0].stop.stop + 1)
        // if (leftStr.indexOf('.') > -1 || leftStr.indexOf('_') == 0) {
            this.addStrContext(ctx.stop.stop + 1)

            var preContext = this.currContext;
            do {
                if (preContext instanceof JPAssignRightContext) {
                    this.currContext = preContext.parent;
                    this.currContext.currIdx = ctx.stop.stop + 1;
                    break;
                }
            } while (preContext = preContext.pre)
        // }
    }
};

// Enter a parse tree produced by ObjectiveCParser#assignmentOperator.
JPObjCListener.prototype.enterAssignmentOperator = function(ctx) {
    if (ctx.getText() == '=') {
        var preContext = this.currContext;
        do {
            if (preContext instanceof JPAssignLeftContext) {
                this.addStrContext(ctx.start.start)

                var assignRightContext = new JPAssignRightContext();
                assignContext = preContext.parent;
                assignContext.right = assignRightContext;
                assignRightContext.parent = assignContext;

                assignRightContext.currIdx = ctx.stop.stop + 1;

                this.currContext = assignRightContext;
                break;
            }
        } while (preContext = preContext.pre)
    }
};

// Enter a parse tree produced by ObjectiveCParser#forStatement.
JPObjCListener.prototype.enterForStatement = function(ctx) {
    if (ctx.forLoopInitializer()) {
        //is Declaration_specifiersContext
        var strContext = this.addStrContext(ctx.forLoopInitializer().start.start);
        var declarationContext = new JPDeclarationContext();
        strContext.setNext(declarationContext);
        this.currContext = declarationContext;

        // if (ctx.children[3].start.text == '*') {
        //     this.currContext.currIdx = ctx.children[3].start.stop + 1
        // } else {
        this.currContext.currIdx = ctx.forLoopInitializer().start.stop + 1;
        // }
    }
};

// Exit a parse tree produced by ObjectiveCParser#forStatement.
JPObjCListener.prototype.exitForStatement = function(ctx) {
};

// Enter a parse tree produced by ObjectiveCParser#castExpression.
JPObjCListener.prototype.enterCastExpression = function(ctx) {
    if (ctx.typeName()) {
        this.addStrContext(ctx.start.start);
        this.currContext.currIdx = ctx.typeName().stop.stop + 2;
    }
};

// Exit a parse tree produced by ObjectiveCParser#castExpression.
JPObjCListener.prototype.exitCastExpression = function(ctx) {
};