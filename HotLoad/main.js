require('SDSettingCell,SDWordPropertyExplainViewController,UITableView,UIColor');
defineClass('SDSettingViewController', null, {
    setupUI: function() {
        self.setTitle("设置");
        self.contentView().addSubview(self.tbView());
    },
    setupConstraints: function() {
        self.tbView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.edges().equalTo()(self.contentView());
        }));
    },
    tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = tableView.dequeueReusableCellWithIdentifier(SDSettingCell.description());
        switch (indexPath.row()) {
            case 0:
                cell.textLabel().setText("词性缩写对照表");
                break;
            case 1:
                cell.textLabel().setText("关于");
                break;
            default:
                break;
        }
        return cell;
    },
    tableView_numberOfRowsInSection: function(tableView, section) {
        return 2;
    },
    tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
        return 44;
    },
    tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
        switch (indexPath.row()) {
            case 0:
                self.navigationController().pushViewController_animated(SDWordPropertyExplainViewController.new(), YES);
                break;

            default:
                break;
        }
    },
    tbView: function() {
        if (!self.getProp('tbView')) {
            self.setProp_forKey(UITableView.new(), 'tbView');
            self.getProp('tbView').setDataSource(self);
            self.getProp('tbView').setDelegate(self);
            self.getProp('tbView').setBackgroundColor(UIColor.clearColor());
            self.getProp('tbView').setSeparatorStyle(UITableViewCellSelectionStyleNone);
            self.getProp('tbView').registerClass_forCellReuseIdentifier(SDSettingCell.class(), SDSettingCell.description());
            self.getProp('tbView').setShowsVerticalScrollIndicator(NO);
        }
        return self.getProp('tbView');
    },
}, null, {
    setupUI: 'void',
    setupConstraints: 'void',
    tableView_cellForRowAtIndexPath: 'UITableViewCell*,UITableView*,NSIndexPath*',
    tableView_numberOfRowsInSection: 'NSInteger,UITableView*,NSInteger',
    tableView_heightForRowAtIndexPath: 'CGFloat,UITableView*,NSIndexPath*',
    tableView_didSelectRowAtIndexPath: 'void,UITableView*,NSIndexPath*',
    tbView: 'UITableView*'
});