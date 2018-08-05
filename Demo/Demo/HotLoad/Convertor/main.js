require('AnnotatedPhotoCell,UIColor,PinterestLayout,UICollectionView,NSArray');
defineClass('ViewController', {
    viewDidLoad: function() {
        self.view().addSubview(self.collectionView());
        self.collectionView().mas__makeConstraints(block('void, MASConstraintMaker*', function(make) {
            make.edges().equalTo()(self.view()).valueOffset()(MMASBoxValue(UIEdgeInsetsMake(0, 0, 0, 0)));
        }));
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
    collectionView: function() {
        if (!self.getProp('collectionView')) {
            var layout = PinterestLayout.new();
            layout.setDelegate(self);
            self.setProp_forKey(UICollectionView.alloc().initWithFrame_collectionViewLayout(CGRectZero, layout), 'collectionView');
            self.getProp('collectionView').setDataSource(self);
            self.getProp('collectionView').setBackgroundColor(UIColor.whiteColor());
            self.getProp('collectionView').registerClass_forCellWithReuseIdentifier(AnnotatedPhotoCell.class(), NSStringFromClass(AnnotatedPhotoCell.class()));
        }
        return self.getProp('collectionView');
    },
    photoHeight: function() {
        if (!self.getProp('photoHeight')) {
            self.setProp_forKey(NSArray.arrayWithObjects(210, 90, 91, 94, 111, 67, 20, 199, 89, null), 'photoHeight');
        }
        return self.getProp('photoHeight');
    },
});