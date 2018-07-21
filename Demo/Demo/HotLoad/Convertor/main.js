require('UITableViewCell,UITableView');
defineClass('ViewController', {
    viewDidLoad: function() {

        self.view().addSubview(self.tbView());
        self.tbView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.edges().equalTo()(self.view());
        }));

    },
    tableView_numberOfRowsInSection: function(tableView, section) {
        return 10;
    },
    tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = UITableViewCell.alloc().initWithStyle_reuseIdentifier(UITableViewCellStyleDefault, "123321");
        cell.textLabel().setText(NSStringFormat("%ld", (long) indexPath.row()));
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