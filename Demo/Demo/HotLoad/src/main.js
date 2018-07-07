include('system_macro.js');
require('VCTableViewCell,NSDate');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();

        //    [self.view() addSubview:self.tableView]();
        //    [self.tableView() mas__makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges().equalTo()(self.view());
        //    }];

        var c = VCTableViewCell.new();
        c.testBlock(block('void, NSString*', function(param) {
            NSLog("cell block param: %", param);
        }));

        //    [self testBlock:^(NSDate *param) {
        //        NSLog("param:%", param);
        //    }];

        void( ^ BK)(NSString * ) = block('void, NSString*', function(a) {
            NSLog("%", a);
        });

        BK("");

    },
    testBlock: function() {

    },
    testBlock: function(blockParam) {
        blockParam(NSDate.date());
    },
});