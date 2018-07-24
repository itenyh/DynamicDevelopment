require('./JPConvertor')
var fs = require('fs');

var data = fs.readFileSync('/Users/iten/iten的文档/Code/SmallCity/SmallCity/iCMCity/HeatMapModule/View/iCMCityMapChartView.m', 'utf8');
// var data = "((NSObject *)[[UIView new] new]);";
//
var t1 = new Date().getTime();
convertor(data, function (result, className, err) {
    // console.log(result, className, (err == undefined) ? '' : err);
    // console.log('Time Used: ' + (new Date().getTime() - t1));
});

