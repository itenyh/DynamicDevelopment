defineClass('TestViewController', null, {
    viewDidLoad: function() {

        var c = 1;
        self.get(c);
        NSLog("%d", c);


    }
}, null, {
    viewDidLoad: 'void'
});
