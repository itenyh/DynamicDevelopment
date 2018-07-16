require('./JPConvertor')

// convertor("@selector(add);", function (result) {
//    console.log(result);
// });

// var content = '- (void)testBlock:(NSString *)string block:(void(^)(NSDate *param))blockParam {\n' +
//     '    blockParam([NSDate date]);\n' +
//     '}';
// var content = '[NSDate date:@"today" endDate:@"tomrrow"];';
// var content = '[self.car test:[UIView new] block:^(NSDate *param) {\n' +
//     '        NSLog(@"param:%@", param);\n' +
//     '    }];';
var content = '@implementation ViewController\n' +
    '+ (void)viewDidLoad {\n' +
    '    [super viewDidLoad];\n' +
    '   \n' +
    '    \n' +
    '}\n' +
    '- (void)testBlock {\n' +
    '    \n' +
    '}\n' +
    '@end'


convertor(content, function (result, className) {
    console.log(result, className);
});

// var a = [];
// console.log();
