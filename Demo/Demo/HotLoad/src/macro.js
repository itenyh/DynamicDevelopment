global.UIControlStateNormal = 0;
global.UIControlStateHighlighted  = 1;
global.UICollectionElementKindSectionHeader = "UICollectionElementKindSectionHeader"

global.NSLog = function () {
    console.log(arguments);
}

global.CGRectMake = function () {
    return {x:arguments[0], y:arguments[1], width:arguments[2], height:arguments[3]};
}

global.CGSizeMake = function () {
    return {width:arguments[0], height:arguments[1]};
}

//global.mas__equalTo = function (varg) {
//    return self.equalTo(require('IJSUtils').test(varg));
//}
