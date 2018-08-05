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
    [self.image sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534053321&di=9a14c9575d76b0e523a02ec9f98f8db9&imgtype=jpg&er=1&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1605%2F31%2Fc2%2F22216357_1464695319646_320x480.jpg"]];
}

- (UIImageView *)image {
    if (!_image) {
        _image = [UIImageView new];
    }
    return _image;
}

@end
