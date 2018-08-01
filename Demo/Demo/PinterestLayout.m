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
    
    [super prepareLayout];
    
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
        CGFloat photoHeight = [self.delegate collectionView:self.collectionView heightForPhotoAtIndexPath:indexPath];
        CGFloat height = self.cellPadding * 2 + photoHeight;
        CGRect frame = CGRectMake([xOffset[column] floatValue], [yOffset[column] floatValue], columnWidth, height);
        CGRect insetFrame = CGRectMake(frame.origin.x + self.cellPadding, frame.origin.y + self.cellPadding, frame.size.width - 2 * self.cellPadding, frame.size.height - 2 * self.cellPadding);
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = insetFrame;
        [self.cache addObject:attributes];
        
        self.contentHeight = [self findMax:self.contentHeight n2:frame.origin.y];
        yOffset[column] = [NSNumber numberWithFloat:[yOffset[column] floatValue] + height];
        column = column < (self.numberOfColumns - 1) ? (column + 1) : 0;
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *visibleLayoutAttributes = [NSMutableArray array];
    for (int i = 0;i < self.cache.count;i++) {
        UICollectionViewLayoutAttributes *attributes = self.cache[i];
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [visibleLayoutAttributes addObject:attributes];
        }
    }
    return visibleLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cache[indexPath.item];
}

#pragma )(
- (CGFloat)findMax:(CGFloat)n1 n2:(CGFloat)n2 {
    return MAX(n1, n2);
}

- (CGFloat)cellPadding {
    return 6;
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

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)cache {
    if (!_cache) {
        _cache = [NSMutableArray array];
    }
    return _cache;
}

@end
