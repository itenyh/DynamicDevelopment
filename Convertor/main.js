require('./JPConvertor')
var fs = require('fs');

var data = fs.readFileSync('/Users/itenyh/Desktop/Working____/Demo/Demo/ViewController.m', 'utf8');


var t1 = new Date().getTime();
convertor(data, function (result, className) {
    console.log(new Date().getTime() - t1);
    // console.log(result, className);
});

