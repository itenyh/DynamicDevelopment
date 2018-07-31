//
//  PinterestLayout.m
//  Demo
//
//  Created by Iten on 2018/7/30.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "PinterestLayout.h"

@interface PinterestLayout ()

@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) CGFloat cellPadding;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *cache;

@end

@implementation PinterestLayout

- (void)prepareLayout {
    CGFloat columnWidth = self.contentWidth / (CGFloat)self.numberOfColumns;
    NSMutableArray *xOffset = [NSMutableArray array];
    int column = 0;
    NSMutableArray *yOffset = [NSMutableArray array];
    for (int i = 0; i < self.numberOfColumns; i++) {
        [xOffset addObject:[NSNumber numberWithFloat:i * columnWidth]];
        [yOffset addObject:[NSNumber numberWithFloat:0]];
    }
    
    for (int i = 0;i < [self.collectionView numberOfItemsInSection:0];i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 4
        CGFloat photoHeight = [self.delegate collectionView:self.collectionView heightForPhotoAtIndexPath:indexPath];
        CGFloat height = self.cellPadding * 2 + photoHeight;
        CGRect frame = CGRectMake([xOffset[column] floatValue], [yOffset[column] floatValue], columnWidth, height);
        CGRect insetFrame = CGRectMake(self.cellPadding, self.cellPadding, frame.size.width - 2 * self.cellPadding, frame.size.height - 2 * self.cellPadding);
        // 5
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = insetFrame;
        [self.cache addObject:attributes];
    }
}

- (CGFloat)cellPadding {
    return 6;
}

- (CGFloat)contentHeight {
    return 0;
}

- (int)numberOfColumns {
    return 2;
}

- (CGFloat)contentWidth {
    if (self.collectionView) {
        UIEdgeInsets insets = self.collectionView.contentInset;
        return self.collectionView.bounds.size.width - (insets.left + insets.right);
    }
    return 0;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

@end
