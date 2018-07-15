include('system_macro.js');
require('FileTransferServiceBrowser');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.super().viewDidLoad();
        self.broswer().startBrowsering();
    },
    broswer: function() {
        if (!self.getProp('broswer')) {
            self.setProp_forKey(FileTransferServiceBrowser.new(), 'broswer');
        }
        return self.getProp('broswer');
    },
});