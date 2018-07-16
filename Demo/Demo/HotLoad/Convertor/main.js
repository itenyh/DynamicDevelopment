require('UIColor, UIView');

defineCFunction("NSClassFromString", "Class, NSString *")

defineClass('ViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();
        self.view().setBackgroundColor(UIColor.whiteColor());
            var test = NSClassFromString("UIView");
            console.log(test);
    },
});
