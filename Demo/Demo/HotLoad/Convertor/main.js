defineClass('ViewController', {
    viewDidLoad: function() {


            self.test1(self.view().frame());

    },
    test1: function(rect) {
        NSLog("rect: %f", rect.size().width());
        return rect;
    },
});
