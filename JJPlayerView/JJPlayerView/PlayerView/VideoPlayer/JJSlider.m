//
//  JJSlider.m
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/26.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJSlider.h"
#import "UIImage+JJPlayer.h"
@implementation JJSlider


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImage *thumbImage = [UIImage imageWithName:@"JJRoundButton"];
    [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}

@end
