defineClass('AnnotatedPhotoCell', {
    initWithFrame: function(frame) {
        self = self.super().initWithFrame(frame);
        if (self) {
            self.setup();
        }
        return self;
    },
    setup: function() {
        NSLog("13123");
    },
});