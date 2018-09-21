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