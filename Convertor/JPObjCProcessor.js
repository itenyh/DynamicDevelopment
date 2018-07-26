
var JPMethodObject = function() {
    this.script = null;
    this.isIn = null;
    this.isOut = null;
}

exports.processor = function (script) {

    //Remove comments
    var replaceComments = function(script) {
        return script.replace(/\/\*[\s\S]*?\*\/|([^:]|^)\/\/.*$/gm, '');
    }
    script = replaceComments(script);

    //Get Method Script
    var matches = /(@implementation[\s\S]*?\n+\s*([\s\S]*?)\s+@end)/gm.exec(script);
    var implementation = matches[1];
    var implementationBody = matches[2];

    var bracesDeep = 0;
    var didInBody = false;
    var willLeftBody = false;
    var methodScript = ''

    var methodObjects = [];

    for (var i = 0;i < implementationBody.length;i++) {

        var curChar = implementationBody[i];
        methodScript += curChar;

        if (curChar == '{') {
            bracesDeep++;
        }
        else if (curChar == '}') {
            bracesDeep--;
        }

        willLeftBody = (didInBody && bracesDeep == 0);
        didInBody = bracesDeep >= 1;

        if (willLeftBody) {
            var ms = new JPMethodObject();
            ms.script = methodScript;
            methodObjects.push(ms);
            methodScript = '';
        }

    }

    //Init Method Object
    for (var method in methodObjects) {
        var ms = methodObjects[method];
        ms.isIn = /#pragma\s+\(\)\s*\n/gm.test(ms.script);
        ms.isOut = /#pragma\s+\)\(\s*\n/gm.test(ms.script);
    }

    //Filter Method Object
    var hasInMethodScript = false;
    for (var method in methodObjects) {
        var ms = methodObjects[method];
        if (ms.isIn) {
            hasInMethodScript = true;
            break;
        }
    }

    var finalMethodObjects = [];
    for (var method in methodObjects) {
        var ms = methodObjects[method];
        if (hasInMethodScript) {
            if (ms.isIn) {
                finalMethodObjects.push(ms);
            }
        }
        else {
            if (!ms.isOut) {
                finalMethodObjects.push(ms);
            }
        }
    }

    //Get Result script
    var finalMethodBodyScript = '';
    for (var method in finalMethodObjects) {
        var ms = finalMethodObjects[method];
        finalMethodBodyScript += ms.script;
    }
    script = implementation.replace(/(@implementation[\s\S]*?\n+\s+)[\s\S]*?(\s+@end)/gm, "$1" + finalMethodBodyScript + "$2");

    //去掉<>，包括了协议和泛型
    script = script.replace(/<.+?>/gm, "");

    return script;
}