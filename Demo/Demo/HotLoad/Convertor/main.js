require('UIColor,UIView');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();
        self.view().setBackgroundColor(UIColor.whiteColor());

        self.view().addSubview(self.subView());

        self.subView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.size().equalTo()(MMASBoxValue(CGSizeMake(80, 80)));
            make.center().equalTo()(self.view());
        }));

        //    CGSize size;
        //     __typeof__(size);

        //    #define MASBoxValue(value) _MASBoxValue(@encode(__typeof__((value))), (value))
        //    NSValue *value = MMASBoxValue(@encode(CGSize), CGSizeMake(10, 20));
        //    NSLog("value: %", value);
        //    int sum = addemUp(1, 2, 3, 0);
        //    NSLog("sum: %d", sum);
        //    [self MMASBoxValue:<#(NSString *)#> struct:<#(void *)#>]
        //     NSSting *a = @encode(CGSize);
        //    funcC([self createPoint]);
        //    CGSize size = CGSizeMake(12, 32);
        //    NSLog("%", [self funD:&size]);

    },
}, {});