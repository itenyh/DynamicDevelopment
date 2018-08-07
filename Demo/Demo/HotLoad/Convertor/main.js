require('UIColor,UITableViewCell,UITableView,NSArray');
defineClass('TestViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();

        self.view().setBackgroundColor(UIColor.purpleColor());
        self.view().addSubview(self.tbView());
        self.tbView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.edges().equalTo()(self.view());
        }));
    },
    tableView_numberOfRowsInSection: function(tableView, section) {
        return self.datas().count();
    },
    tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = UITableViewCell.new();
        cell.setBackgroundColor(UIColor.blueColor())
        cell.textLabel().setText(self.datas().jp_element(indexPath.row()));
        return cell;
    },
    tbView: function() {
        if (!self.getProp('tbView')) {
            self.setProp_forKey(UITableView.new(), 'tbView');
            self.getProp('tbView').setDataSource(self);
            self.getProp('tbView').setDelegate(self);
            self.getProp('tbView').setSeparatorStyle(UITableViewCellSeparatorStyleNone);
        }
        return self.getProp('tbView');
    },
    datas: function() {
        if (!self.getProp('datas')) {
            self.setProp_forKey(NSArray.arrayWithObjects("陈", "呆", "诗", "汉", "汉12", null), 'datas');
        }
        return self.getProp('datas');
    },
});