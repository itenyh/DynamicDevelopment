var Compiler = require("./compiler").Compiler;
var fs = require('fs');



var code = '#define A 1 \n var n = A + 1; \n //asdfasd ' +
    '';
// var code = fs.readFileSync('/Users/iten/Desktop/iOS_BigData/cqBigData/cqBigData/MainFrame/BDAnalysis/BDMain/ViewController/BDMainViewController.m', 'utf8');

// compiler.compile(code, function(err, result) {
//     console.log(err);
//     console.log(result);
// });

var c = new Compiler();
c.on('success', function (code) {
    console.log(code);
})
c.on('error', function (error) {
    console.log(error);
})

c.compile(code);
// or