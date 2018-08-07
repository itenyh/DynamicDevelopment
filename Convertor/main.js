require('./JPConvertor')
// require('./product/bundle');

var fs = require('fs');

// var data = "@implementation Temp \n " +
//     "- (void)test {\n" +
//         "for (NSObject *obj in drr) {\n" +
//         "for (NSString *ooo in [NSArray array]) {" +
//         " int a = ooo;  " +
//     "}" +
//         "}\n" +
//         "return 1;\n" +
//     "}\n" +
//     "@end";
// var data = "if (a) { }";
// var data = "@implementation Temp \n - (void)test { [NSArray arrayWithObjects:@\"1\"]; } @end";
// var data = fs.readFileSync('/Users/mkeqi/Desktop/Working____/Demo/Demo/ViewController.m', 'utf8');
// var data = "@{@\"sdfsdf\":@{@\"a\": @\"b\"}};";
// var data = "[self animateWithDuration:1 animations:^id(NSString *tt){\n" +
//     "        \n" +
//     "    }];";
// var data = 'self.test(123)';
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

