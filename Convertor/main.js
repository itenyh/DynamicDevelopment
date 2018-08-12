require('./JPConvertor')
// require('./product/bundle');

var fs = require('fs');

var data = "@implementation Temp \n " +
    "- (void)lineView:(NSString *)a b:(int)a1 {\n" +
    "    if (!_lineView) {\n" +
    "       _tbView = [UITB new]; \n" +
    "       [_tbView registerClass:iCMCaseAcceptedCell.class forCellReuseIdentifier:NSStringFromClass(iCMCaseAcceptedCell.class)];\n" +
    "    }\n" +
    "    return _lineView;\n" +
    "}\n" +
    "@end";
// console.log(data)
// var data = "[self.datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {\n" +
//     "        }];";
// var data = "@implementation Temp \n - (void)test { [NSArray arrayWithObjects:@\"1\"]; } @end";
// var data = fs.readFileSync('/Users/iten/Desktop/Working____/Demo/Demo/ViewController.m', 'utf8');
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

