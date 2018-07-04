require('./JPConvertor')

// convertor("@selector(add);", function (result) {
//    console.log(result);
// });

var content = 'iCMTimeSerial *a = [iCMTimeSerial new];';
// var content = 'UITableView *a = [UITableView new]';

convertor(content, function (result) {
    console.log(result);
});
