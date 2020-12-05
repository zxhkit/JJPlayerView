//
//  JJPlayerMaskView.h
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/21.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJPlayer.h"
#import "JJAnimationView.h"

//@class JJPlayerMaskView;
//@class JJSlider;
@protocol JJPlayerMaskViewDelegate <NSObject>

/// 返回按钮点击事件代理
- (void)jj_playerMaskViewBackButtonAction:(UIButton *_Nonnull)button;
/// 播放按钮点击事件代理
- (void)jj_playerMaskViewPlayButtonAction:(UIButton *_Nonnull)button;
/// 全屏按钮点击事件代理
- (void)jj_playerMaskViewFullButtonAction:(UIButton *_Nonnull)button;
/// 开始滑动
- (void)jj_playerMaskViewProgressSliderTouchBegan:(JJSlider *_Nullable)slider;
/// 滑动中
- (void)jj_playerMaskViewProgressSliderTouchChanged:(JJSlider *_Nullable)slider;
/// 滑动结束
- (void)jj_playerMaskViewProgressSliderTouchEnd:(JJSlider *_Nullable)slider;
/// 播放失败按钮事件
- (void)jj_playerMaskViewFailButtonAction:(UIButton *_Nonnull)button;

NS_ASSUME_NONNULL_BEGIN


@end

//if ([self.delegate respondsToSelector:@selector(JJPlayerMaskView)]) {
//    [self.delegate JJPlayerMaskView];
//}

@interface JJPlayerMaskView : UIView

/// 代理事件
@property (nonatomic, weak)   id<JJPlayerMaskViewDelegate > delegate;
/// 顶部工具条
@property (nonatomic, strong) UIView              *topToolBar;
/// 标题
@property (nonatomic, strong) UILabel             *titleLabel;
/// 底部工具条
@property (nonatomic, strong) UIView              *bottomToolBar;
/// 加载动画
@property (nonatomic, strong, nullable) JJAnimationView     *loadingView;
/// 顶部工具条返回按钮(会和工具条一起消失显示)
@property (nonatomic, strong) UIButton            *backButton;
/// 顶部返回按钮,一直显示
@property (nonatomic, strong) UIButton            *backOnlyButton;


@property (nonatomic, strong) UIButton            *lockButton;

/// 底部工具条播放/暂停按钮
@property (nonatomic, strong) UIButton            *playButton;
/// 底部工具条全屏按钮
@property (nonatomic, strong) UIButton            *fullButton;
/// 底部工具条当前时间
@property (nonatomic, strong) UILabel             *currentTimeLabel;
/// 底部工具条总时间
@property (nonatomic, strong) UILabel             *totalTimeLabel;
/// 缓冲进度条
@property (nonatomic, strong) UIProgressView      *progressView;
/// 播放进度条
@property (nonatomic, strong) JJSlider            *slider;
/// 加载失败按钮
@property (nonatomic, strong) UIButton            *failButton;
/// 进度条背景颜色
@property (nonatomic, strong) UIColor *progressBackGroundColor;
/// 缓冲条缓冲进度颜色
@property (nonatomic, strong) UIColor *progressBufferColor;
/// 进度条播放完成颜色
@property (nonatomic, strong) UIColor *progressPlayFinishColor;

//双击
- (void)doubleTapAction;


@end

NS_ASSUME_NONNULL_END
