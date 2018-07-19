require('UILabel,UIColor');
defineClass('ViewController', {
    viewDidLoad: function() {
//        var frame = self.test1();
//        var madeFrame = self.test2();
//        NSLog("%@", frame.sx());
        var a = UIEdgeInsetsMake(1,2,3,4);
            NSLog("%@", a.top());
    },
//    lable: function() {
//        if (!self.getProp('lable')) {
//            self.setProp_forKey(UILabel.new(), 'lable');
//            self.getProp('lable').setBackgroundColor(UIColor.orangeColor());
//            self.getProp('lable').setText("流星");
//            self.getProp('lable').setTextAlignment(NSTextAlignmentCenter);
//        }
//        return self.getProp('lable');
//    },
});
