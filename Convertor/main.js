require('./JPConvertor')
var fs = require('fs');

var data = fs.readFileSync('/Users/itenyh/Desktop/Working____/Demo/Demo/ViewController.m', 'utf8');
// var data = "- (void) test:(NSString *)p1 p2:(id)p2 {\n" +
//     "self.view = [UIView new];\n" +
//     "}";
// var data = "UITableViewCell *cell;";
var t1 = new Date().getTime();
convertor(data, function (result, className, err) {
    console.log(result, className, (err == undefined) ? '' : err);
    console.log('Time Used: ' + (new Date().getTime() - t1));
});

