require('./dist/convertor_hr.js').convertor;

// 示例Objective-C代码片段
var data = "@implementation Temp \n " +
    "- (void)addExtensions:(NSArray *)extensionNames {\n" +
    " NSDictionary *params = @{@\"key\" : @\"v1\", @\"key2\" : @\"v2\"};" +
    "    }\n" +
    "}\n" +
    "@end";

convertor(data, (result, className, errors) => {
    console.log('===== 转换结果 =====');
    console.log(result);
    console.log('===== 类名 =====');
    console.log(className);
    if (errors && errors.length > 0) {
        console.log('===== 错误信息 =====');
        console.log(errors);
    } else {
        console.log('无错误');
    }
}); 