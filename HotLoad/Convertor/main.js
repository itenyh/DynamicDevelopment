require('UILabel,UIColor');
defineClass('ViewController', {
    viewDidLoad: function() {

        self.view().frame();


    },
    lable: function() {
        if (!self.getProp('lable')) {
            self.setProp_forKey(UILabel.new(), 'lable');
            self.getProp('lable').setBackgroundColor(UIColor.orangeColor());
            self.getProp('lable').setText("流星");
            self.getProp('lable').setTextAlignment(NSTextAlignmentCenter);
        }
        return self.getProp('lable');
    },
});