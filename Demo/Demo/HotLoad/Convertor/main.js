require('UIColor');
defineClass('ViewController', {
    viewDidLoad: function() {

        self.view().addSubview(self.tbView());
        self.tbView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.size().equalTo()(MMASBoxValue(CGSizeMake(200, 100)));
        }));


        self.view().setBackgroundColor(UIColor.brownColor());

    },
});