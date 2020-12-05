//
//  JJBaseNavigationView.m
//  iOS_Tools
//
//  Created by 播呗网络 on 2020/8/23.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJBaseNavigationView.h"

@implementation JJBaseNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.backgroundImgV];
        [self addSubview:self.titleLabel];
        [self addSubview:self.backBtn];
        
        [self.backgroundImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@17);
            make.width.height.equalTo(@(kNavBarContentHeight));
            make.bottom.equalTo(@0);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(@(kNavBarContentHeight));
            make.bottom.equalTo(@0);
        }];
    }
    return self;
}
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange: previousTraitCollection];
    
    if (@available(iOS 13.0, *)) {
        
    } else {
       
    }
}


- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}

/// 返回按钮点击事件
- (void)backButtonClick{
    if (self.backBtnActionCallBack) {
        self.backBtnActionCallBack();
    }
}

#pragma mark - Getters
- (UIImageView *)backgroundImgV{
    if (!_backgroundImgV) {
        _backgroundImgV = [[UIImageView alloc] init];
        _backgroundImgV.clipsToBounds = YES;
        _backgroundImgV.userInteractionEnabled = YES;
        _backgroundImgV.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImgV.backgroundColor = [UIColor clearColor];
    }
    return _backgroundImgV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont_Medium(17);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [_backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
