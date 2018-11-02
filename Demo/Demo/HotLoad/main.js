require('UIColor');
defineClass('Manager:NSObject', null, {
            color: function() {
            return UIColor.redColor();
            }
                }, {
                    shareInstance: function() {
                        var pred = 0;
                        var instance = null;
                        dispatch_once(pred, block('void', function() {
                            instance = self.alloc().init();
                        }));
            console.log(pred);
                        return instance;
                    }
            }, {
            color: 'UIColor*',
            shareInstance: 'Manager*'
            });


require('Manager');
defineClass('ViewController', null, {
    viewDidLoad: function() {
        self.super().viewDidLoad();

        self.view().setBackgroundColor(Manager.shareInstance().color());


    }
}, null, {
    viewDidLoad: 'void'
});


