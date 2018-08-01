//
//  AnnotatedPhotoCell.m
//  Demo
//
//  Created by Iten on 2018/7/30.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "AnnotatedPhotoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    [self.image sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533125211232&di=e48cf12310987884fb706e6c3b4812ad&imgtype=0&src=http%3A%2F%2Fc15.eoemarket.net%2Fapp0%2F816%2F816897%2Fscreen%2F4755890.jpg"]];
}

- (UIImageView *)image {
    if (!_image) {
        _image = [UIImageView new];
    }
    return _image;
}

@end
