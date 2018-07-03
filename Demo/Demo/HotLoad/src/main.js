include('macro.js');
require('UILabel,UIColor');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();

        self.view().addSubview(self.test());
        self.test().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.center().equalTo()(self.view());
        }));
    },
    test: function() {
        if (!self.getProp('test')) {
            self.setProp_forKey(UILabel.new(), 'test');
            self.getProp('test').setText("测试");
            self.getProp('test').setTextColor(UIColor.whiteColor());
        }
        return self.getProp('test');
    },
});