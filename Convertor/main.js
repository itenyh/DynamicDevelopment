require('./JPConvertor')
var fs = require('fs');

var data = fs.readFileSync('/Users/iten/Desktop/iOS_BigData/cqBigData/cqBigData/MainFrame/iCMCity/MainPageModule/View/ChartView/EXChartView.m', 'utf8');
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

