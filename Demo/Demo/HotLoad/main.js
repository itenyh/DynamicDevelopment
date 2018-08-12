require('ViewController,indexPath,UITableViewCell,UITableView');
defineClass('TestViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();
        self.view().addSubview(self.tbView());
        self.tbView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.edges().equalTo()(self.view());
        }));



        var vc = ViewController.new();
        var a = 4;
        vc.bb(a);


    },
    numberOfSectionsInTableView: function(tableView) {
        return 2;
    },
    tableView_numberOfRowsInSection: function(tableView, section) {
        return 5 + section;
    },
    tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        if (indexPath.section() == 0) {
            var cell = UITableViewCell.new();
            cell.textLabel().setText("123");
            return cell;
        } else if (indexPath.section() == 1) {
            var cell = UITableViewCell.new();
            cell.textLabel().setText("789");
            return cell;
        }
        return null;
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