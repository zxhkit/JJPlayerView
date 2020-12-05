//
//  JJPlayerMaskView.m
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/21.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJPlayerMaskView.h"


#define Margin 10  //间隙
#define ToolBarHeight 40  //顶部底部工具条高度

@interface JJPlayerMaskView ()

@end

@implementation JJPlayerMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化界面
- (void)setupUI
{
    [self addSubview:self.topToolBar];
    [self.topToolBar addSubview:self.backButton];
    [self.topToolBar addSubview:self.titleLabel];
    
    [self addSubview:self.lockButton];
    
    [self addSubview:self.bottomToolBar];
    [self.bottomToolBar addSubview:self.playButton];
    [self.bottomToolBar addSubview:self.fullButton];
    [self.bottomToolBar addSubview:self.currentTimeLabel];
    [self.bottomToolBar addSubview:self.totalTimeLabel];
    [self.bottomToolBar addSubview:self.progressView];
    [self.bottomToolBar addSubview:self.slider];
    
    [self addSubview:self.loadingView];
    [self addSubview:self.failButton];

    self.topToolBar.backgroundColor    = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.20000f];
    self.bottomToolBar.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.20000f];
    
    
    
    //顶部工具条
    [self.topToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    // 底部工具条
    [self.bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    //转子动画
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    //返回按钮
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.topToolBar.mas_safeAreaLayoutGuideLeft).mas_offset(Margin*2);
        } else {
            make.left.mas_equalTo(-Margin*2);
        }
        make.bottom.mas_equalTo(-Margin);
        make.width.mas_equalTo(self.backButton.mas_height);
    }];
    //标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).mas_offset(Margin);
        make.centerY.equalTo(self.backButton);
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.topToolBar.mas_safeAreaLayoutGuideRight).mas_offset(-Margin);
        } else {
            make.right.mas_equalTo(-Margin);
        }
    }];
    //播放按钮
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.bottomToolBar.mas_safeAreaLayoutGuideLeft).mas_offset(Margin*2);
        } else {
            make.left.mas_equalTo(Margin*2);
        }
        make.bottom.mas_equalTo(-Margin);
        make.width.mas_equalTo(self.playButton.mas_height);
    }];
    //锁定按钮
    [self.lockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(kStatusBarHeight-20+44);
        make.width.height.mas_equalTo(44);
        make.centerY.equalTo(self);
    }];
    
    //全屏按钮
    [self.fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-Margin);
        make.top.mas_equalTo(Margin);
        make.width.mas_equalTo(self.fullButton.mas_height);
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.bottomToolBar.mas_safeAreaLayoutGuideRight).mas_offset(-Margin);
        } else {
            make.right.mas_equalTo(-Margin);
        }
    }];
    //当前播放时间
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).mas_offset(Margin);
        make.width.mas_equalTo(45);
        make.centerY.equalTo(self.bottomToolBar);
    }];
    //总时间
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullButton.mas_left).mas_offset(-Margin);
        make.width.mas_equalTo(45);
        make.centerY.equalTo(self.bottomToolBar);
    }];
    //缓冲条
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).mas_offset(Margin);
        make.right.equalTo(self.totalTimeLabel.mas_left).mas_offset(-Margin);
        make.height.mas_equalTo(2);
        make.centerY.equalTo(self.bottomToolBar);
    }];
    //滑杆
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.progressView);
    }];
    //失败按钮
    [self.failButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
 
    
}


#pragma mark - setter

- (void)setProgressBackGroundColor:(UIColor *)progressBackGroundColor{
    _progressBackGroundColor = progressBackGroundColor;
    _progressView.trackTintColor = _progressBackGroundColor;
}

- (void)setProgressBufferColor:(UIColor *)progressBufferColor{
    _progressBufferColor = progressBufferColor;
    _progressView.progressTintColor = _progressBufferColor;
}

- (void)setProgressPlayFinishColor:(UIColor *)progressPlayFinishColor{
    _progressPlayFinishColor = progressPlayFinishColor;
    _slider.minimumTrackTintColor = _progressPlayFinishColor;
}

//双击
- (void)doubleTapAction{
    [self playButtonAction:self.playButton];
}


#pragma mark - 按钮点击事件
//返回按钮
- (void)backButtonAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jj_playerMaskViewBackButtonAction:)]) {
        [self.delegate jj_playerMaskViewBackButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人-jj_playerMaskViewBackButtonAction");
    }
}
//播放按钮
- (void)playButtonAction:(UIButton *)button{
    button.selected = !button.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jj_playerMaskViewPlayButtonAction:)]) {
        [self.delegate jj_playerMaskViewPlayButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人-jj_playerMaskViewPlayButtonAction");
    }
}

//全屏按钮
- (void)fullButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jj_playerMaskViewFullButtonAction:)]) {
        [self.delegate jj_playerMaskViewFullButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人-jj_playerMaskViewFullButtonAction");
    }
}

// 加载失败按钮事件
- (void)failButtonAction:(UIButton *)button{
    self.failButton.hidden = YES;
    self.loadingView.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jj_playerMaskViewFailButtonAction:)]) {
        [self.delegate jj_playerMaskViewFailButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人-jj_playerMaskViewFailButtonAction");
    }
}

// 锁屏按钮
- (void)lockButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    
    if (button.selected) {  //lock
        [self updateLockButtonWith:YES];
    } else {  //unlock
        
    }
}

- (void)updateLockButtonWith:(BOOL)isShow{
    if (isShow) {  //
        [self.lockButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(kStatusBarHeight-20+44);
        }];
    } else {
        [self.lockButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(-44);
        }];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.lockButton.superview layoutIfNeeded];
    }];
}

// 滑动开始
- (void)progressSliderTouchBegan:(JJSlider *)slider{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jj_playerMaskViewProgressSliderTouchBegan:)]) {
        [self.delegate jj_playerMaskViewProgressSliderTouchBegan:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人-progressSliderTouchBegan");
    }
}
// 滑动中事件
- (void)progressSliderTouchChanged:(JJSlider *)slider{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jj_playerMaskViewProgressSliderTouchBegan:)]) {
        [self.delegate jj_playerMaskViewProgressSliderTouchBegan:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人-progressSliderTouchChanged");
    }
}
// 滑动结束事件
- (void)progressSliderTouchEnd:(JJSlider *)slider{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jj_playerMaskViewProgressSliderTouchEnd:)]) {
        [self.delegate jj_playerMaskViewProgressSliderTouchEnd:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人-progressSliderTouchEnd");
    }
}

#pragma mark - lazy
//顶部工具条
- (UIView *)topToolBar{
    if (_topToolBar == nil) {
        _topToolBar = [[UIView alloc] init];
        _topToolBar.userInteractionEnabled = YES;
    }
    return _topToolBar;
}
//标题
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

//底部工具条
- (UIView *)bottomToolBar{
    if (_bottomToolBar == nil) {
        _bottomToolBar = [[UIView alloc] init];
        _bottomToolBar.userInteractionEnabled = YES;
    }
    return _bottomToolBar;
}
//动画
- (JJAnimationView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [[JJAnimationView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_loadingView startAnimation];
    }
    return _loadingView;
}
//返回按钮
- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageWithName:@"JJBackButton"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageWithName:@"JJBackButton"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
// 播放按钮
- (UIButton *)playButton{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageWithName:@"JJPlayButton"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageWithName:@"JJPauseButton"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
// 全屏按钮
- (UIButton *)fullButton{
    if (_fullButton == nil) {
        _fullButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullButton setImage:[UIImage imageWithName:@"JJMaxButton"] forState:UIControlStateNormal];
        [_fullButton setImage:[UIImage imageWithName:@"JJMinButton"] forState:UIControlStateSelected];
        [_fullButton addTarget:self action:@selector(fullButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}
//当前播放时间
- (UILabel *)currentTimeLabel{
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.adjustsFontSizeToFitWidth = YES;
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}
//总时间
- (UILabel *)totalTimeLabel{
    if (_totalTimeLabel == nil){
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}
// 缓冲条
- (UIProgressView *)progressView{
    if (_progressView == nil){
        _progressView = [[UIProgressView alloc] init];
    }
    return _progressView;
}
// 滑动条
- (JJSlider *)slider{
    if (_slider == nil) {
        _slider = [[JJSlider alloc] init];
        //slider开始滑动
        [_slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        //slider滑动过程中
        [_slider addTarget:self action:@selector(progressSliderTouchChanged:) forControlEvents:UIControlEventValueChanged];
        //slider滑动结束
        [_slider addTarget:self action:@selector(progressSliderTouchEnd:) forControlEvents:UIControlEventTouchUpOutside];
        // 右边颜色
        _slider.maximumTrackTintColor = [UIColor clearColor];
    }
    return _slider;
}
// 加载失败按钮
- (UIButton *)failButton{
    if (_failButton == nil) {
        _failButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _failButton.hidden = YES;
        [_failButton setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failButton.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.50000f];
        [_failButton addTarget:self action:@selector(failButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failButton;
}

- (UIButton *)lockButton{
    if (_lockButton == nil) {
        _lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockButton setImage:[UIImage imageWithName:@"JJPlayer_unlock"] forState:UIControlStateNormal];
        [_lockButton setImage:[UIImage imageWithName:@"JJPlayer_lock"] forState:UIControlStateSelected];
        [_lockButton addTarget:self action:@selector(lockButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockButton;
}








@end
