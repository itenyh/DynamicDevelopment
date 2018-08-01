//
//  AnnotatedPhotoCell.m
//  Demo
//
//  Created by Iten on 2018/7/30.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "AnnotatedPhotoCell.h"

@interface AnnotatedPhotoCell ()

@property (nonatomic, strong) UIImageView *image;

@end

@implementation AnnotatedPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIImageView *)image {
    if (!_image) {
        _image = [UIImageView new];
        _image
    }
    return _image;
}

@end
