require('./JPConvertor')
var fs = require('fs');

var data = fs.readFileSync('/Users/iten/iten的文档/Code/SmallCity/SmallCity/iCMCity/HeatMapModule/View/iCMCityMapView.m', 'utf8');


var t1 = new Date().getTime();
convertor(data, function (result, className, err) {
    console.log(result, className, (err == undefined) ? '' : err);
    console.log('Time Used: ' + (new Date().getTime() - t1));
});

