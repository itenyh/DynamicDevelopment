require('NSMutableArray,NSArray,NSMutableDictionary,UITableViewCell,NSDate,UITableView,ReferenceCycleView');
defineClass('TestViewController', null, {
    viewDidLoad: function() {

        self.super().viewDidLoad();



        var arr = NSMutableArray.arrayWithArray(NSArray.arrayWithObjects("123", "445", null));
        arr.setJp__element_obj(1, "55");

        var dic = NSMutableDictionary.dictionaryWithObjectsAndKeys("obj", "key", null);
        dic.setJp__element_obj("key1", "obj1");
        NSLog("%@", dic.jp__element("key1"));

    },
    tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
        return 50;
    },
    tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = UITableViewCell.alloc().initWithStyle_reuseIdentifier(UITableViewCellStyleDefault, "fasfasd");
        cell.textLabel().setText(NSStringFormat("第 %ld 排: %@", indexPath.row(), NSDate.date()));
        return cell;
    },
    tableView_numberOfRowsInSection: function(tableView, section) {
        return 20;
    },
    tbView: function() {
        if (!self.getProp('tbView')) {
            self.setProp_forKey(UITableView.new(), 'tbView');
            self.getProp('tbView').setDataSource(self);
            self.getProp('tbView').setDelegate(self);
        }
        return self.getProp('tbView');
    },
    cycleView: function() {
        if (!self.getProp('cycleView')) {
            self.setProp_forKey(ReferenceCycleView.new(), 'cycleView');
        }
        return self.getProp('cycleView');
    },
}, null, {
    viewDidLoad: 'void',
    tableView_heightForRowAtIndexPath: 'CGFloat,UITableView*,NSIndexPath*',
    tableView_cellForRowAtIndexPath: 'UITableViewCell*,UITableView*,NSIndexPath*',
    tableView_numberOfRowsInSection: 'NSInteger,UITableView*,NSInteger',
    tbView: 'UITableView*',
    cycleView: 'ReferenceCycleView*'
});