require('./JPConvertor')
// require('./product/bundle');

var fs = require('fs');

var data = "@implementation Temp \n " +
    "- (void)addExtensions:(NSArray *)extensionNames {\n" +
    "    [JPEngine addExtensions:extensionNames];\n" +
    "    for (NSString *extension in extensionNames) {\n" +
    "        Class extensionClass = NSClassFromString(extension);\n" +
    "        [self.extensions addObject:extensionClass];\n" +
    "    }\n" +
    "}\n" +
    "@end";
// console.log(data)
// var data = "[self.datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {\n" +
//     "        }];";
// var data = "@implementation Temp \n - (void)test { [NSArray arrayWithObjects:@\"1\"]; } @end";
// var data = fs.readFileSync('/Users/mkeqi/Desktop/Working____/Demo/Demo/HotLoad/HotComplileEngine.m', 'utf8');
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

