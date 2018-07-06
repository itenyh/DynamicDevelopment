require('./JPConvertor')

// convertor("@selector(add);", function (result) {
//    console.log(result);
// });

var content = '_cooo;';
// var content = 'UITableView *a = [UITableView new]';

convertor(content, function (result) {
    console.log(result);
});
