require('UIColor,AnnotatedPhotoCell,NSArray');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.view().addSubview(self.collectionView());
        self.collectionView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.edges().equalTo()(self.view()).valueOffset()(MMASBoxValue(UIEdgeInsetsMake(0, 0, 0, 0)));
        }));
        self.view().setBackgroundColor(UIColor.lightTextColor());
    },
    collectionView_heightForPhotoAtIndexPath: function(collectionView, indexPath) {
        return self.photoHeight().jp_element(indexPath.row()).floatValue();
    },
    collectionView_numberOfItemsInSection: function(collectionView, section) {
        return self.photoHeight().count();
    },
    collectionView_cellForItemAtIndexPath: function(collectionView, indexPath) {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier_forIndexPath(NSStringFromClass(AnnotatedPhotoCell.class()), indexPath);
        cell.setBackgroundColor(UIColor.purpleColor());
        return cell;
    },
    photoHeight: function() {
        if (!self.getProp('photoHeight')) {
            self.setProp_forKey(NSArray.arrayWithObjects(20, 90, 53, 94, 111, 67, 20, 99, null), 'photoHeight');
        }
        return self.getProp('photoHeight');
    },
});