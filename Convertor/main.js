require('./JPConvertor')

// convertor("@selector(add);", function (result) {
//    console.log(result);
// });

var content = 'VCTableViewCell.class;';
// var content = 'UITableView *a = [UITableView new]';

convertor(content, function (result) {
    console.log(result);
});
