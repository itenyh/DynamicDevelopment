include('macro.js');
require('UITableView, VCTableViewCell');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();

        self.view().addSubview(self.tableView());
        self.tableView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.edges().equalTo()(self.view());
        }));
    },
    tableView_numberOfRowsInSection: function(tableView, section) {
        return 10;
    },
    tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = tableView.dequeueReusableCellWithIdentifier("test");
        cell.textLabel().setText("123");
        return cell;
    },
    tableView: function() {
        if (!self.getProp('tableView')) {
            self.setProp_forKey(UITableView.new(), 'tableView');
            self.getProp('tableView').setDelegate(self);
            self.getProp('tableView').setDataSource(self);
            self.getProp('tableView').registerClass_forCellReuseIdentifier(VCTableViewCell.class(), "test");
        }
        return self.getProp('tableView');
    },
});
