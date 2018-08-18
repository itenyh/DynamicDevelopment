require('UITableViewCell,UITableView');
defineClass('TestViewController', ['c'], {
    viewDidLoad: function() {
        self.super().viewDidLoad();

        self.setC(UITableView.new());
        NSLog("%@", self.c().class());







    },
}, null, {
    viewDidLoad: 'void',
    numberOfSectionsInTableView: 'NSInteger,UITableView*',
    tableView_numberOfRowsInSection: 'NSInteger,UITableView*,NSInteger',
    tableView_cellForRowAtIndexPath: 'UITableViewCell*,UITableView*,NSIndexPath*',
    tbView: 'UITableView*'
});
