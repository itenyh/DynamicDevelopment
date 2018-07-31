defineClass('TestViewController', {
    viewDidLoad: function() {
        var b;
        var blk = block('void, MASConstraintMaker*', function(make) {
            var p1 = make.edges();
            var p2 = self.view();
            var p3 = self.view();
            var p4 = self.view();
            var p5 = self.view();
            var p6 = self.view();
            var a1 = p1.equalTo()(p2);
            var a2 = a1.equalTo()(p3);
            var a3 = a2.equalTo()(p4);
            a3.equalTo()(p5);
        });
        self.view().mas__makeConstraints(blk);
    },
    didReceiveMemoryWarning: function() {
        self.super().didReceiveMemoryWarning();

    },
});