global.NSLog = function () {
    console.log(arguments);
}

global.CGRectMake = function () {
    return {x:arguments[0], y:arguments[1], width:arguments[2], height:arguments[3]};
}

global.CGSizeMake = function () {
    return {width:arguments[0], height:arguments[1]};
}

global.UILayoutConstraintAxisHorizontal = 0;
global.UILayoutConstraintAxisVertical = 1;

global.UILayoutPriorityRequired = 1000;
global.UILayoutPriorityDefaultHigh = 750;
global.UILayoutPriorityDefaultLow = 250;

global.NSTextAlignmentLeft = 0;
global.NSTextAlignmentCenter = 1;

//UIButtonTextAlign
global.UIControlContentHorizontalAlignmentCenter = 0;
global.UIControlContentHorizontalAlignmentLeft = 1;
global.UIControlContentHorizontalAlignmentRight = 2;
global.UIControlContentHorizontalAlignmentFill = 3;
global.UIControlContentHorizontalAlignmentLeading = 4;
global.UIControlContentHorizontalAlignmentTrailing = 5;

//TableViewCellStyle
global.UITableViewCellStyleDefault = 0;
global.UITableViewCellStyleValue1 = 1;
global.UITableViewCellStyleValue2 = 2;
global.UITableViewCellStyleSubtitle = 3;

global.UIControlStateNormal = 0;
global.UIControlStateHighlighted  = 1;


global.UICollectionElementKindSectionHeader = "UICollectionElementKindSectionHeader";
