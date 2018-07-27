require('UIColor,UITableViewCell,UITableView');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.view().addSubview(self.tbView());
        self.tbView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.edges().equalTo()(self.view()).valueOffset()(MMASBoxValue(UIEdgeInsetsMake(0, 0, 0, 0)));
        }));
        self.view().setBackgroundColor(UIColor.lightTextColor());

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