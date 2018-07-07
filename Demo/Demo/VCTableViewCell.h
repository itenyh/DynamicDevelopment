//
//  VCTableViewCell.h
//  Demo
//
//  Created by itenyh on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCTableViewCell : UITableViewCell

- (void)testBlock:(void(^)(NSString *param))blockParam;

@end
