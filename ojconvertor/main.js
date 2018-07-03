require('./JPConvertor')

// convertor("@selector(add);", function (result) {
//    console.log(result);
// });

var content = '[a setNumber:@"1"];';

convertor(content, function (result) {
    console.log(result);
});
