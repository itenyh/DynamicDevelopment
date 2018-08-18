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
    JPPostFixContext = c.JPPostfixContext,
    JPPostfixContentContext = c.JPPostfixContentContext,
    JPForInContext = c.JPForInContext,
    JPForInContentContext = c.JPForInContentContext,
    JPBridgeContext = c.JPBridgeContext,
    JPForInVariableSetContext = c.JPForInVariableSetContext,
    JPArrayContext = c.JPArrayContext,
    JPArrayContentContext = c.JPArrayContentContext,
    JPDictionaryContext = c.JPDictionaryContext,
    JPDictionaryContentContext = c.JPDictionaryContentContext,
    JPDictionaryObjContext = c.JPDictionaryObjContext,
    JPProtocolContext = c.JPProtocolContext

var treeView = require('./HHTreeViewer')

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
    this.cb = cb;
    this.messageCtxStack = [];
    this.contextBinder = new JPContextBinder();

    return this;
}

JPObjCListener.prototype = Object.create(ObjCListener.prototype);

JPObjCListener.prototype.buildScript = function() {
    this.cb(this.rootContext.parse(), this.rootContext.className);
    // treeView.view(this.rootContext);
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
};

// Exit a parse tree produced by ObjectiveCParser#classImplementation.
JPObjCListener.prototype.exitClassImplementation = function(ctx) {
    this.buildScript();
};

// Enter a parse tree produced by ObjectiveCParser#classMethodDefinition.
JPObjCListener.prototype.enterClassMethodDefinition = function(ctx) {
    var methodContext = new JPMethodContext();
    this.rootContext.classMethods.push(methodContext);
    this.currContext = methodContext;
};

// Exit a parse tree produced by ObjectiveCParser#classMethodDefinition.
JPObjCListener.prototype.exitClassMethodDefinition = function(ctx) {};

// Enter a parse tree produced by ObjectiveCParser#instanceMethodDefinition.
JPObjCListener.prototype.enterInstanceMethodDefinition = function(ctx) {
    var methodContext = new JPMethodContext();
    this.rootContext.instanceMethods.push(methodContext);
    this.currContext = methodContext;
};

// Exit a parse tree produced by ObjectiveCParser#instanceMethodDefinition.
JPObjCListener.prototype.exitInstanceMethodDefinition = function(ctx) {};

// Enter a parse tree produced by ObjectiveCParser#methodDefinition.
JPObjCListener.prototype.enterMethodDefinition = function(ctx) {
    var names = [],
        params = [],
        types = [];
    types.push(ctx.methodType().typeName().getText());
    var methodSelectorContext = ctx.methodSelector();
    for (var i in methodSelectorContext.children) {
        var keywordDeclaratorContext = methodSelectorContext.children[i];
        names.push(keywordDeclaratorContext.start.text);
        if (keywordDeclaratorContext.stop.start != keywordDeclaratorContext.start.start) {
            params.push(keywordDeclaratorContext.stop.text)
        }
        // console.log(keywordDeclaratorContext.methodType)
        if (keywordDeclaratorContext.methodType)
            types.push(keywordDeclaratorContext.methodType()[0].typeName().getText());
    }

    //currContext is JPMethodContext
    this.currContext.names = names;
    this.currContext.params = params;
    this.currContext.types = types;
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
            var paramsCtx = paramsCtxs[i].typeVariableDeclarator();
            var paramsString = paramsCtx.getText();
            var name = paramsCtx.stop.text;
            var type = paramsString.substring(0, paramsString.length - name.length);
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
    this.messageCtxStack.push(newMsgContext);
    this.currContext = newMsgContext;
};

// Exit a parse tree produced by ObjectiveCParser#messageExpression.
JPObjCListener.prototype.exitMessageExpression = function(ctx) {
    if (this.currContext.preMsg) {
        this.currContext = this.currContext.preMsg
    } else {
        this.currContext = this.currContext.pre;
    }
    this.messageCtxStack.pop();
    this.currContext.currIdx = ctx.stop.stop + 1
};

// Enter a parse tree produced by ObjectiveCParser#receiver.
JPObjCListener.prototype.enterReceiver = function(ctx) {
    if (ctx.start.text != '[') {
        var bridgeCtx = new JPBridgeContext();
        this.currContext.receiver = bridgeCtx;
        this.currContext = bridgeCtx;
        this.currContext.currIdx = ctx.start.start;
    }
};

// Exit a parse tree produced by ObjectiveCParser#receiver.
JPObjCListener.prototype.exitReceiver = function(ctx) {
    this.addStrContext(ctx.stop.stop + 1);
    this.currContext = this.messageCtxStack[this.messageCtxStack.length - 1];
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
    this.contextBinder.bind(ctx, this.currContext);
    if (ctx.assignmentOperator() && ctx.assignmentOperator().getText() == '=') {
            var assignContext = new JPAssignContext();

            var assignLeftContext = new JPAssignLeftContext();
            assignLeftContext.parent = assignContext;
            assignContext.left = assignLeftContext;

            var strContext = this.addStrContext(ctx.start.start)
            strContext.setNext(assignContext);

            this.currContext = assignLeftContext;
            this.currContext.currIdx = ctx.start.start;
    }
};

// Exit a parse tree produced by ObjectiveCParser#expressions.
JPObjCListener.prototype.exitExpression = function(ctx) {
    var context = this.contextBinder.unbind(ctx);
    if (ctx.assignmentOperator() && ctx.assignmentOperator().getText() == '=') {
            this.addStrContext(ctx.stop.stop + 1)

            var preContext = this.currContext;
            do {
                if (preContext instanceof JPAssignRightContext) {
                    this.currContext = preContext.parent;
                    this.currContext.currIdx = ctx.stop.stop + 1;
                    break;
                }
            } while (preContext = preContext.pre)
    }
    else if (context instanceof JPForInVariableSetContext) {
        this.addStrContext(ctx.stop.stop + 1);
        var forInContext = context.parent;
        this.currContext = forInContext.content;
        this.currContext.currIdx = ctx.stop.stop + 2;
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
                var assignContext = preContext.parent;
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

// Enter a parse tree produced by ObjectiveCParser#forInStatement.
JPObjCListener.prototype.enterForInStatement = function(ctx) {
    var strContext = this.addStrContext(ctx.start.start);
    this.currContext = strContext;

    var forInContext = new JPForInContext();
    this.currContext.setNext(forInContext);

    var forInVariableSetContext = new JPForInVariableSetContext();
    forInVariableSetContext.parent = forInContext;
    forInContext.variableSet = forInVariableSetContext;

    forInContext.variableDeclarator = ctx.typeVariableDeclarator().declarator().directDeclarator().getText();
    var forInContentContext = new JPForInContentContext();
    forInContentContext.parent = forInContext;
    forInContext.content = forInContentContext;

    this.currContext = forInVariableSetContext;
    this.currContext.currIdx = ctx.children[3].symbol.stop + 1;
};

// Exit a parse tree produced by ObjectiveCParser#forInStatement.
JPObjCListener.prototype.exitForInStatement = function(ctx) {
    var strContext = this.addStrContext(ctx.stop.stop + 1);
    this.currContext = strContext;

    var preContext = this.currContext;
    while (!preContext.parent) {
        preContext = preContext.pre;
        if (!preContext) {
            throw new Error('forIn parse fail');
        }
    }
    this.currContext = preContext.parent;
    this.currContext.currIdx = ctx.stop.stop + 1;
};

// Enter a parse tree produced by ObjectiveCParser#castExpression.
JPObjCListener.prototype.enterCastExpression = function(ctx) {
    if (this.currContext instanceof JPDictionaryContentContext) {
        var dicContentContext = this.currContext;
        var dicObjContext = new JPDictionaryObjContext();
        dicObjContext.parent = dicContentContext;
        dicContentContext.objs.push(dicObjContext);
        this.contextBinder.bind(ctx, dicObjContext);
        this.currContext = dicObjContext;
        this.currContext.currIdx = ctx.start.start;
    }
    if (ctx.typeName()) {
        this.addStrContext(ctx.start.start);
        this.currContext.currIdx = ctx.typeName().stop.stop + 2;
    }
};

// Enter a parse tree produced by ObjectiveCParser#castExpression.
JPObjCListener.prototype.exitCastExpression = function(ctx) {
    var context = this.contextBinder.unbind(ctx);
    if (context instanceof JPDictionaryObjContext) {
        this.addStrContext(ctx.stop.stop + 1);
        var dicContentContext = context.parent;
        this.currContext = dicContentContext;
        this.currContext.currIdx = ctx.stop.stop + 1;
    }
};

// Enter a parse tree produced by ObjectiveCParser#postfix.
JPObjCListener.prototype.enterPostfix = function(ctx) {
    if (ctx.start.text == '[') {
        var strContext = this.addStrContext(ctx.start.start);
        this.currContext = strContext;
        var postfixContext = new JPPostFixContext();
        this.currContext.setNext(postfixContext);

        var postfixContentContext = new JPPostfixContentContext();
        postfixContentContext.parent = postfixContext;
        postfixContext.content = postfixContentContext;

        this.currContext = postfixContentContext;
        this.currContext.currIdx = ctx.start.start + 1;
    }
};

// Exit a parse tree produced by ObjectiveCParser#postfix.
JPObjCListener.prototype.exitPostfix = function(ctx) {
    if (ctx.start.text == '[') {
        this.addStrContext(ctx.stop.start);
        var preContext = this.currContext;
        while (preContext) {
            if (preContext instanceof JPPostfixContentContext) {
                break;
            }
            preContext = preContext.pre;
        }
        this.currContext = preContext.parent;
        this.currContext.currIdx = ctx.stop.stop + 1;
    }
};

// Enter a parse tree produced by ObjectiveCParser#arrayExpression.
JPObjCListener.prototype.enterArrayExpression = function(ctx) {
    var strContext = this.addStrContext(ctx.start.start);
    this.currContext = strContext;

    var arrayContext = new JPArrayContext();
    this.currContext.setNext(arrayContext);

    var arrayContentContext = new JPArrayContentContext();
    arrayContext.content = arrayContentContext;
    arrayContentContext.parent = arrayContext;

    this.currContext = arrayContentContext;
    this.currContext.currIdx = ctx.children[1].symbol.stop + 1;
};

// Exit a parse tree produced by ObjectiveCParser#arrayExpression.
JPObjCListener.prototype.exitArrayExpression = function(ctx) {
    this.addStrContext(ctx.stop.start);

    var preContext = this.currContext;
    while (preContext) {
        if (preContext instanceof JPArrayContentContext) {
            break;
        }
        preContext = preContext.pre;
    }
    this.currContext = preContext.parent;
    this.currContext.currIdx = ctx.stop.stop + 1;
};

// Enter a parse tree produced by ObjectiveCParser#dictionaryExpression.
JPObjCListener.prototype.enterDictionaryExpression = function(ctx) {
    var strContext = this.addStrContext(ctx.start.start);
    this.currContext = strContext;

    var dictContext = new JPDictionaryContext();
    this.currContext.setNext(dictContext);

    var dictContentContext = new JPDictionaryContentContext();
    dictContext.content = dictContentContext;
    dictContentContext.parent = dictContext;

    this.currContext = dictContentContext;
    this.currContext.currIdx = ctx.children[1].symbol.stop + 1;
};

// Exit a parse tree produced by ObjectiveCParser#dictionaryExpression.
JPObjCListener.prototype.exitDictionaryExpression = function(ctx) {
    this.addStrContext(ctx.stop.start);

    var preContext = this.currContext;
    while (preContext) {
        if (preContext instanceof JPDictionaryContentContext) {
            break;
        }
        preContext = preContext.pre;
    }
    this.currContext = preContext.parent;
    this.currContext.currIdx = ctx.stop.stop + 1;
};

// Enter a parse tree produced by ObjectiveCParser#categoryInterface.
JPObjCListener.prototype.enterCategoryInterface = function(ctx) {
    this.rootContext.protocols = ctx.protocolList.getText();
};

// Exit a parse tree produced by ObjectiveCParser#categoryInterface.
JPObjCListener.prototype.exitCategoryInterface = function(ctx) {
};

//Helper Methods
function showIndexIndicator(source, index) {
    console.log(source.substring(0, index) + '|' + source.substring(index));
}

var JPContextBinder = function () {
    this.mapper = {},
    this.filter = {},
    this.bind = function (ctx, context) {
        if (!this.filter[context]) {
            this.mapper[ctx] = context;
            this.filter[context] = 1;
        }
    },
    this.unbind = function (ctx) {
        var context = this.mapper[ctx];
        delete this.filter[context];
        delete this.mapper[ctx];
        return context;
    }
    this.isContextBind = function (context) {
        return !!this.filter[context];
    }
};