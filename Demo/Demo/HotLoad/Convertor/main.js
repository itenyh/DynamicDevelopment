require('UIColor,UILabel');
defineClass('ViewController', {
    viewDidLoad: function() {



        var rect = self.test1(self.view().frame());
        NSLog("====== %@", rect);
    },
    test1: function(rect) {
        NSLog("rect: %f", rect.size().width());
        return rect;
    },
});
