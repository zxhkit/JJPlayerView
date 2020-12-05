//
//  JJVideoTableHeaderView.m
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/28.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJVideoTableHeaderView.h"
#import "JJPlayer.h"

@interface JJVideoTableHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *coverImgView;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIView *lineView;


@end
@implementation JJVideoTableHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}


#pragma mark - 初始化界面
- (void)setupUI{
    
    [self addSubview:self.coverImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.playButton];
    [self addSubview:self.lineView];

    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).mas_offset(10);
        make.height.mas_equalTo(300);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.coverImgView.mas_bottom).mas_offset(2);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImgView);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(8);
    }];
    
}


- (void)setModel:(JJVideoModel *)model{
    _model = model;
    self.titleLabel.text = _model.title;
    self.coverImgView.image = [UIImage imageNamed:_model.imageName];
}


- (void)playButtonAction:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(jj_videoTableHeaderViewDidPlayButtonInView:)]) {
        [self.delegate jj_videoTableHeaderViewDidPlayButtonInView:self];
    }
}



- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UIImageView *)coverImgView{
    if (_coverImgView == nil) {
        _coverImgView = [[UIImageView alloc] init];
    }
    return _coverImgView;
}

- (UIButton *)playButton{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageWithName:@"JJPlayButton"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageWithName:@"JJPauseButton"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}


- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}




@end
