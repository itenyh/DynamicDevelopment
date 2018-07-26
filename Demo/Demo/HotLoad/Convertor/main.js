require('UIColor,UIView,UITableViewCell,UITableView');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.view().setBackgroundColor(UIColor.lightTextColor());

        UIView.animateWithDuration_animations(10, block('void', function() {
            self.view().layer().setCornerRadius(2);
        }));
    },
    tableView_numberOfRowsInSection: function(tableView, section) {
        return 1;
    },
    tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = UITableViewCell.alloc().initWithStyle_reuseIdentifier(UITableViewCellStyleDefault, "123321");
        cell.textLabel().setText(NSStringFormat("你景12：%ld", indexPath.row()));
        cell.textLabel().setTextColor(UIColor.grayColor());
        return cell;
    },
    tbView: function() {
        if (!self.getProp('tbView')) {
            self.setProp_forKey(UITableView.new(), 'tbView');
            self.getProp('tbView').setDataSource(self);
            self.getProp('tbView').setDelegate(self);
        }
        return self.getProp('tbView');
    },
});