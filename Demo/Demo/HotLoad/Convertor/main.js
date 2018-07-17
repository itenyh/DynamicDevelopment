require('UIColor,UILabel');
defineClass('ViewController', {
    viewDidLoad: function() {

        self.super().viewDidLoad();
        self.view().setBackgroundColor(UIColor.grayColor());
        self.view().addSubview(self.lable());
        self.lable().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.center().equalTo()(self.view());
            make.size().equalTo()(MMASBoxValue(CGSizeMake(100, 50)));
        }));

    },
    lable: function() {
        if (!self.getProp('lable')) {
            self.setProp_forKey(UILabel.new(), 'lable');
            self.getProp('lable').setBackgroundColor(UIColor.orangeColor());
            self.getProp('lable').setText("流星花园");
            self.getProp('lable').setTextAlignment(NSTextAlignmentCenter);
        }
        return self.getProp('lable');
    },
});