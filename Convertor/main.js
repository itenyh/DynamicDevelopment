require('./JPConvertor')
// require('./product/bundle');

var fs = require('fs');

// var data = "@implementation Temp \n - (void)test { [[self d] floatValue]; } @end";
var data = "@implementation Temp \n - (void)test { _e[@\"fsdf\"] = 3; } @end";
// var data = fs.readFileSync('/Users/iten/Desktop/Working____/Demo/Demo/PinterestLayout.m', 'utf8');
// var data = "- (void)viewDidLoad {\n" +
//     "     [super viewDidLoad\n" +
//     "}\n" +
//     "\n" +
//     "- (void)didReceiveMemoryWarning {\n" +
//     "    [super didReceiveMemoryWarning];\n" +
//     "}";
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

