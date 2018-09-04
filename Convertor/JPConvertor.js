var antlr4 = require('./parser/antlr4/index');
var ObjCLexer = require('./parser/ObjectiveCLexer').ObjectiveCLexer
var ObjCParser = require('./parser/ObjectiveCParser').ObjectiveCParser
var JPObjCListener = require('./JPObjCListener').JPObjCListener
var JPErrorListener = require('./JPErrorListener').JPErrorListener
var JPScriptProcessor = require('./JPScriptProcessor').JPScriptProcessor

var convertor = function(script, cb) {

    var translateErrors = [];

    script = script.replace(/(^\s*)/g,'');
    if (script.indexOf('@implementation') == -1) {
        if (script[0] != '-' && script[0] != '+') {
            script = '@implementation tmp \n -(void)tmp{' + script + '\n}\n@end'
        } else {
            script = '@implementation tmp \n' + script + '\n@end'
        }
    }

    var processor = require('./JPObjCProcessor').processor;
    try {
        script = processor(script);
    }
    catch(e) {
        translateErrors.push({error:e, msg:'Script Preprocess Error'});
    }

    var errorListener = new JPErrorListener(function(e) {
        translateErrors.push({error:e, msg:'Script Parse Listener Error'});
    });
    errorListener.lines = script.split("\n");

    var chars = new antlr4.InputStream(script);
    var lexer = new ObjCLexer(chars);
    lexer.addErrorListener(errorListener);
    var tokens  = new antlr4.CommonTokenStream(lexer);

    var parser = new ObjCParser(tokens);
    parser.addErrorListener(errorListener);
    var tree = parser.translationUnit();
    var listener = new JPObjCListener(function(result, className){
        var processor = new JPScriptProcessor(result)
        if (cb) cb(processor.finalScript(), className, translateErrors.length > 0 ? translateErrors : null);
    });

    try {
        antlr4.tree.ParseTreeWalker.DEFAULT.walk(listener, tree);
    } catch(e) {
        translateErrors.push({error:e, msg:'ParseTreeWalker Error'});
        if (cb) cb(null, null, translateErrors.length > 0 ? translateErrors : null);
    }
    
}

global.convertor = convertor;
exports.convertor = convertor;
