require('NSArray,EXChartView');
defineClass('PlaygroundViewController', {
    updateViewConstraints: function() {

        self.chartView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.left().right().equalTo()(self.view());
            make.height().equalTo()(290);
            make.center().equalTo()(self.view());
        }));
        self.super().updateViewConstraints();
    },
    viewDidLoad: function() {
        self.super().viewDidLoad();
    },
    addSubViews: function() {
        self.chartView().setChartType(EXChartViewTypePie);
        self.chartView().setDatas(NSArray.arrayWithObjects(24, 21, 24, null));
        self.chartView().setCategories(NSArray.arrayWithObjects("4", "5", "6", null));
        self.chartView().setCategoryNames(NSArray.arrayWithObjects("去年", "今年", "明年", null));
        self.chartView().setColors(NSArray.arrayWithObjects("#a1100f1", "#00b0ff", "#33cc99", null));
        self.chartView().reload();
        self.view().addSubview(self.chartView());
    },
    willDealloc: function() {
        return NO;
    },
    chartView: function() {
        if (!self.getProp('chartView')) {
            self.setProp_forKey(EXChartView.new(), 'chartView');
        }
        return self.getProp('chartView');
    },
});