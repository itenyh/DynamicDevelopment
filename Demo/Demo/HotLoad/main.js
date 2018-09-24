require('UIView,UIColor,UITableViewCell,UITableView,ReferenceCycleView');
defineClass('TestViewController', null, {
    viewDidLoad: function() {

        self.super().viewDidLoad();

        var view = UIView.new();
        view.setBackgroundColor(UIColor.redColor());
        self.view().addSubview(view);
        var rec = self.rect1(self.view().frame());
        view.setFrame(rec);


    },
    point: function() {
        return CGPointMake(32, 3);
    },
    a_arg1: function(arg, arg1) {
        return arg + arg1;
    },
    tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
        return 50;
    },
    tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = UITableViewCell.alloc().initWithStyle_reuseIdentifier(UITableViewCellStyleDefault, "fasfasd");
        cell.textLabel().setText(NSStringFormat("第 %ld 排: %@", indexPath.row(), "sadjkfa"));
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
    point: 'CGPoint',
    a_arg1: 'int,int,int',
    tableView_heightForRowAtIndexPath: 'CGFloat,UITableView*,NSIndexPath*',
    tableView_cellForRowAtIndexPath: 'UITableViewCell*,UITableView*,NSIndexPath*',
    tableView_numberOfRowsInSection: 'NSInteger,UITableView*,NSInteger',
    tbView: 'UITableView*',
    cycleView: 'ReferenceCycleView*'
});