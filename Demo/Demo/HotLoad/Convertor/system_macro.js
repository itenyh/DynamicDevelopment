global.NSLog = function () {
    
    require('NSString');
    console.log(arguments);
    var logContent = "";
    if (arguments.length == 1) { logContent = arguments[0]; }
    else if (arguments.length == 2) { logContent = NSString.stringWithFormat(arguments[0], arguments[1]); }
    else if (arguments.length == 3) { logContent = NSString.stringWithFormat(arguments[0], arguments[1], arguments[2]); }
    else if (arguments.length == 4) { logContent = NSString.stringWithFormat(arguments[0], arguments[1], arguments[2], arguments[3]); }
    else if (arguments.length == 5) { logContent = NSString.stringWithFormat(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]); }
    else if (arguments.length == 6) { logContent = NSString.stringWithFormat(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]); }
    else if (arguments.length == 7) { logContent = NSString.stringWithFormat(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]); }
    else if (arguments.length == 8) { logContent = NSString.stringWithFormat(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]); }
    else if (arguments.length == 9) { logContent = NSString.stringWithFormat(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]); }
    else if (arguments.length == 10) { logContent = NSString.stringWithFormat(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9]); }
    console.log(logContent);
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
