defineClass('ViewController', {
    updateViewConstraints: function() {

        self.lable().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.center().equalTo()(self.view());
            make.height().equalTo()(MMASBoxValue(121));
        }));


        self.super().updateViewConstraints();
    },
});