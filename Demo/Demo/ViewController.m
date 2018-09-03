//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"
#import "AnnotatedPhotoCell.h"
#import "PinterestLayout.h"

@interface ViewController () <UICollectionViewDataSource, PinterestLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *photoHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma CollectionView Delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath {
    return [self.photoHeight[indexPath.row] floatValue];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoHeight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AnnotatedPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(AnnotatedPhotoCell.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        PinterestLayout *layout = [PinterestLayout new];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:AnnotatedPhotoCell.class forCellWithReuseIdentifier:NSStringFromClass(AnnotatedPhotoCell.class)];
    }
    return _collectionView;
}

- (NSArray *)photoHeight {
    if (!_photoHeight) {
        _photoHeight = [NSArray arrayWithObjects:@210, @90, @91, @94, @111, @67, @120, @119, @189, nil];
    }
    return _photoHeight;
}

- (void)dealloc {
    NSLog(@"viewcontroller dealloc");
}

@end
