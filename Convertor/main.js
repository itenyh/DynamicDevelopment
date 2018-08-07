require('./JPConvertor')
// require('./product/bundle');

var fs = require('fs');

var data = "@implementation Temp \n " +
    "- (void)lineView {\n" +
    "    if (!_lineView) {\n" +
    "       _tbView = [UITB new]; \n" +
    "       [_tbView registerClass:iCMCaseAcceptedCell.class forCellReuseIdentifier:NSStringFromClass(iCMCaseAcceptedCell.class)];\n" +
    "    }\n" +
    "    return _lineView;\n" +
    "}\n" +
    "@end";
// var data = "[_tbView registerClass:iCMCaseAcceptedCell.class forCellReuseIdentifier:NSStringFromClass(iCMCaseAcceptedCell.class)];";
// var data = "@implementation Temp \n - (void)test { [NSArray arrayWithObjects:@\"1\"]; } @end";
// var data = fs.readFileSync('/Users/iten/Desktop/iOS_BigData/cqBigData/cqBigData/Debug/ViewController.m', 'utf8');
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

