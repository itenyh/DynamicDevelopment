require('./JPConvertor')
var fs = require('fs');

var data = fs.readFileSync('/Users/iten/Desktop/Working____/Demo/Demo/HotLoad/HotComplileEngine.m', 'utf8');
// var data = "- (void)viewDidLoad {\n" +
//     "     [super viewDidLoad\n" +
//     "}\n" +
//     "\n" +
//     "- (void)didReceiveMemoryWarning {\n" +
//     "    [super didReceiveMemoryWarning];\n" +
//     "}";
// // var data = "[UIView new];";
var t1 = new Date().getTime();
convertor(data, function (result, className, err) {
    console.log(result, className, (err == undefined) ? '' : err);
    console.log('Time Used: ' + (new Date().getTime() - t1));
});

// var t2 = new Date().getTime();
// convertor(data, function (result, className, err) {
//     // console.log(result, className, (err == undefined) ? '' : err);
//     console.log('Time Used: ' + (new Date().getTime() - t2));
// });

