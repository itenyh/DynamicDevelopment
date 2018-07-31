//
//  PinterestLayout.h
//  Demo
//
//  Created by Iten on 2018/7/30.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PinterestLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PinterestLayout : UICollectionViewLayout

@property (nonatomic, weak) id<PinterestLayoutDelegate> delegate;

@end
