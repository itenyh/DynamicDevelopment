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

@end

@implementation ViewController

- (void)viewDidLoad {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.view.backgroundColor = [UIColor lightTextColor];
}

#pragma CollectionView Delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath {
    return 100 / (indexPath.row + 1.52);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AnnotatedPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(AnnotatedPhotoCell.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}

#pragma )(
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        PinterestLayout *layout = [PinterestLayout new];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        [_collectionView registerClass:AnnotatedPhotoCell.class forCellWithReuseIdentifier:NSStringFromClass(AnnotatedPhotoCell.class)];
    }
    return _collectionView;
}


@end
