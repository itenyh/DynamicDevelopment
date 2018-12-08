require('UIColor,UILabel,UIFont');
defineClass('TestViewController', null, {
    viewDidLoad: function() {
        self.super().viewDidLoad();
        self.view().addSubview(self.label());

        self.label().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.center().equalTo()(self.view());
        }));

        self.view().setBackgroundColor(UIColor.redColor());
    },
    label: function() {
        if (!self.getProp('label')) {
            self.setProp_forKey(UILabel.new(), 'label');
            self.getProp('label').setText("Hello World");
            self.getProp('label').setFont(UIFont.systemFontOfSize(40));
        }
        return self.getProp('label');
    },
}, null, {
    viewDidLoad: 'void',
    label: 'UILabel*'
});