include('system_macro.js');
require('UIColor,FileTransferServiceBrowser');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();
        //    [self.broswer() startBrowsering];
        self.view().setBackgroundColor(UIColor.redColor());
    },
    broswer: function() {
        if (!self.getProp('broswer')) {
            self.setProp_forKey(FileTransferServiceBrowser.new(), 'broswer');
        }
        return self.getProp('broswer');
    },
});