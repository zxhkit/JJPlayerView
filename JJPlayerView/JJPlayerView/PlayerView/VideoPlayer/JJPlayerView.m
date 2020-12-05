//
//  JJPlayerView.m
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/21.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JJPlayer.h"


///播放器的播放状态
typedef NS_ENUM(NSUInteger,JJPlayerState){
    JJPlayerStateUnknown = 0, // 未知
    JJPlayerStatePause,       //暂停播放
    JJPlayerStatePlaying,     //播放中
    JJPlayerStateBuffering,   //缓冲中
    JJPlayerStateFailed,      //暂停失败
};

typedef NS_ENUM(NSUInteger, JJPanDirection) {
    JJPanDirectionHorizontalMoved,  /// 横向移动
    JJPanDirectionVerticalMoved,    /// 纵向移动
};

@implementation JJPlayerConfigure

+ (instancetype)defaultConfigure{
    JJPlayerConfigure *configure = [[JJPlayerConfigure alloc] init];
    
    configure.repeatPlay      = NO;
    configure.isLandscape     = NO;
    configure.autoRotate      = YES;
    configure.isMute          = NO;
    configure.smallGestureControl  = NO;
    configure.fullGestureControl   = YES;
    configure.toolBarDisappearTime = 8;
    configure.videoFillMode        = JJVideoFillModeResize;
    configure.topToolBarHiddenType = JJTopToolBarHiddenNever;
    configure.fullGestureControl   = YES;

    configure.progressBackgroundColor = [UIColor colorWithRed:0.54118 green:0.51373 blue:0.50980 alpha:1.00000];
    configure.progressPlayFinishColor = [UIColor greenColor];
    configure.progressBufferColor     = [UIColor colorWithRed:0.84118 green:0.81373 blue:0.80980 alpha:1.00000];
    configure.strokeColor             = [UIColor whiteColor];
    
    return configure;
}

static id _instance;
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [JJPlayerConfigure defaultConfigure];
    });
    return _instance;
}



@end


@interface JJPlayerView ()<JJPlayerMaskViewDelegate,UIGestureRecognizerDelegate>
{
   id _itemEndObserver;
}

/// 播放器
@property (nonatomic, strong)   AVPlayer         *player;
/// 播放器item
@property (nonatomic, strong)   AVPlayerItem     *playerItem;
/// 播放器layer
@property (nonatomic, strong)   AVPlayerLayer    *playerLayer;
/// 控件的原始frame
@property (nonatomic, assign)   CGRect           customFrame;
/// 父类控件
@property (nonatomic, strong)   UIView           *fatherView;
/// 视图拉伸模式
@property (nonatomic, copy)     NSString         *fillMode;
/// 是否处于全屏状态
@property (nonatomic, assign)   BOOL             isFullScreen;
/// 工具条是否隐藏
@property (nonatomic, assign)   BOOL             isDisappear;
/// 用户播放标记
@property (nonatomic, assign)   BOOL             isUserPlay;
/// 点击最大化标记
@property (nonatomic, assign)   BOOL             isUserTapMaxButton;
/// 是否播放完毕
@property (nonatomic, assign)   BOOL             isFinish;
/// 是否在调节音量:YES为音量,NO为屏幕亮度
@property (nonatomic, assign)   BOOL isVolume;
/// 是否在拖拽
@property (nonatomic, assign)   BOOL isDragged;
/// 缓冲
@property (nonatomic, assign)   BOOL isBuffering;
/// 用来保存快进的总时长
@property (nonatomic, assign)   CGFloat sumTime;
/// 播放器配置信息
@property (nonatomic, strong) JJPlayerConfigure *playerConfigure;
/// 视频播放控制面板(遮罩)
@property (nonatomic, strong) JJPlayerMaskView  *playerMaskView;
/// 滑动方向
@property (nonatomic, assign) JJPanDirection     panDirection;
/// 音量滑杆
@property (nonatomic, strong) UISlider *volumeViewSlider;
/// 点击屏幕定时器
@property (nonatomic, strong) NSTimer *tapTimer;
/// 播放器的播放状态
@property (nonatomic, assign) JJPlayerState playerState;


/// 记录点击屏幕定时器的时间
@property (nonatomic, assign)   NSInteger tapTimeCount;


/// 是否已经移除了KVO
@property (nonatomic, assign)   BOOL isRemoveObserver;



/// 返回按钮回调
@property (nonatomic, copy) void(^BackBlock) (UIButton *backButton);
/// 播放完成回调
@property (nonatomic, copy) void(^EndBlock)(void);

@end

@implementation JJPlayerView

- (instancetype)initWithFrame:(CGRect)frame configuration:(JJPlayerConfigure *)configure{
    self = [super initWithFrame:frame];
    if (self) {
        self.playerConfigure = configure;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerMaskView.frame = self.bounds;
    self.playerLayer.frame = self.bounds;
}

#pragma mark -
#pragma mark - 初始化界面
- (void)setupUI
{
    //默认初始值
    _isFullScreen = NO;
    _isDisappear = NO;
    _isUserTapMaxButton = NO;
    _isFinish = NO;
    _isUserPlay = YES;
    self.tapTimeCount = 0;
    
    //开启
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    /// 监听横竖屏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    /// 进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    /// 进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 添加打断播放的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruptionComing:) name:AVAudioSessionInterruptionNotification object:nil];
    // 添加插拔耳机的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
    // 添加观察者监控进度
//    __weak typeof(self) weakSelf = self;
    
   
    // 创建播放器
    self.backgroundColor = [UIColor blackColor];
    // 获取系统音量
    [self configureVolume];
    // 遮罩
    [self addSubview:self.playerMaskView];
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
}

- (void)addPeriodicTimeObserver{
    @weakify(self);
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        [self sliderTimerAction];
    }];
    
}

- (void)sliderTimerAction{
    if (self.playerItem.duration.timescale != 0) {
        self.playerMaskView.slider.maximumValue = 1;
        CGFloat total = _playerItem.duration.value / _playerItem.duration.timescale;
        self.playerMaskView.slider.value = CMTimeGetSeconds(self.playerItem.currentTime) / total;
        //判断是否正在播放
        if (self.playerItem.isPlaybackLikelyToKeepUp && self.playerMaskView.slider.value > 0) {
            self.playerState = JJPlayerStatePlaying;
        }
        
        //当前时长
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前分钟
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前秒
        self.playerMaskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)proMin, (long)proSec];
        //总时长
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总分钟
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总秒
        self.playerMaskView.totalTimeLabel.text   = [NSString stringWithFormat:@"%02ld:%02ld", (long)durMin, (long)durSec];
    }
}


#pragma mark - 获取系统音量
- (void)configureVolume{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
}

#pragma mark - public

- (void)updatePlayerAllConfigure:(JJPlayerConfigure *)configure{
    self.playerConfigure = configure;
    [self updateConfigure];
}

#pragma mark - 更新配置
- (void)updatePlayerModifyConfigure:(void (^)(JJPlayerConfigure * _Nonnull))playerConfigureBlock{
    if (playerConfigureBlock) {
        playerConfigureBlock(self.playerConfigure);
    }
    
    if (self.playerConfigure.toolBarDisappearTime < 1) {
        self.playerConfigure.toolBarDisappearTime = 1;
    }
    [self updateConfigure];
}

- (void)updateConfigure{
    switch (self.playerConfigure.videoFillMode) {
        case JJVideoFillModeResize:
            //拉伸视频内容达到边框占满,不按原来比例展示
            _fillMode = AVLayerVideoGravityResize;
            break;
        case JJVideoFillModeResizeAspect:
            //按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑
            _fillMode = AVLayerVideoGravityResizeAspect;
            break;
        case JJVideoFillModeResizeAspectFill:
            //按原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分会被剪切
            _fillMode = AVLayerVideoGravityResizeAspectFill;
            break;
    }
    
    self.playerMaskView.progressBackGroundColor = self.playerConfigure.progressBackgroundColor;
    self.playerMaskView.progressBufferColor = self.playerConfigure.progressBufferColor;
    self.playerMaskView.progressPlayFinishColor = self.playerConfigure.progressPlayFinishColor;
    self.player.muted = self.playerConfigure.isMute;
    @weakify(self);
    [self.playerMaskView.loadingView updateWithConfigure:^(JJAnimationConfigure * _Nonnull configure) {
        @strongify(self);
        configure.backgroundColor = self.playerConfigure.strokeColor;
    }];
}

#pragma mark - 重置工具条时间
- (void)resetTooBarDisappearTimer{
    [self destoryToolBarTimer];
    self.tapTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(tapTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.tapTimer forMode:NSRunLoopCommonModes];
}
//    __weak __typeof(self) weakSelf = self;
//    __typeof(&*weakSelf) strongSelf = weakSelf;

- (void)tapTimerAction{
    
    if (self.tapTimeCount > self.playerConfigure.toolBarDisappearTime) {
        [self destoryToolBarTimer];
        self.tapTimeCount = 0;
        self.isDisappear = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.playerMaskView.topToolBar.alpha = 0;
            self.playerMaskView.bottomToolBar.alpha = 0;
        }];
        return;
    }
    self.tapTimeCount ++;
    
}

// 销毁定时器
- (void)destoryToolBarTimer{
    [self.tapTimer invalidate];
    self.tapTimer = nil;
}

//单次点击事件
- (void)singleTapGestureAction:(UIGestureRecognizer *)tapGesture{
    if (self.isDisappear) { //已经隐藏,现在要显示出来
        [self resetTooBarDisappearTimer];
        [UIView animateWithDuration:0.5 animations:^{
            self.playerMaskView.topToolBar.alpha = 1.0;
            self.playerMaskView.bottomToolBar.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (!finished) {
                self.playerMaskView.topToolBar.alpha = 1.0;
                self.playerMaskView.bottomToolBar.alpha = 1.0;
            }
        }];
    } else { //已经显示,需要隐藏
        //取消定时器消失
        [self destoryToolBarTimer];
        [UIView animateWithDuration:0.5 animations:^{
            self.playerMaskView.topToolBar.alpha = 0;
            self.playerMaskView.bottomToolBar.alpha = 0;
        } completion:^(BOOL finished) {
            if (!finished) {
                self.playerMaskView.topToolBar.alpha = 0;
                self.playerMaskView.bottomToolBar.alpha = 0;
            }
        }];
    }
    _isDisappear = !_isDisappear;
}
// 双击
- (void)doubleTapGestureAction:(UIGestureRecognizer *)tapGesture{
    [self.playerMaskView doubleTapAction];
}


#pragma mark - 重置工具条隐藏方法
- (void)resetTopBarHiddenType{
    switch (self.playerConfigure.topToolBarHiddenType) {
        case JJTopToolBarHiddenNever:
            //不隐藏
            self.playerMaskView.topToolBar.hidden = NO;
            break;
        case JJTopToolBarHiddenAlways:
            //小屏和全屏都隐藏
            self.playerMaskView.topToolBar.hidden = YES;
            break;
        case JJTopToolBarHiddenSmall:
            //小屏隐藏，全屏不隐藏
            self.playerMaskView.topToolBar.hidden = !self.isFullScreen;
            break;
    }
}

#pragma mark - 装态
- (void)setPlayerState:(JJPlayerState)playerState{
    if (_playerState == playerState) {
        return;
    }
    _playerState = playerState;
    if (_playerState == JJPlayerStateBuffering) {
        [self.playerMaskView.loadingView startAnimation];
    } else if (_playerState == JJPlayerStateFailed) {
        [self.playerMaskView.loadingView stopAnimation];
        self.playerMaskView.failButton.hidden = NO;
        self.playerMaskView.playButton.selected = NO;
        NSLog(@"video-加载失败");
    }else if (_playerState == JJPlayerStatePause){
        [self.playerMaskView.loadingView stopAnimation];
        if (_isUserPlay) {
            [self pause];
        }
    }else{
        [self.playerMaskView.loadingView stopAnimation];
    }
    
}
#pragma mark - 标签
- (void)setTitle:(NSString *)title{
    _title = title;
    self.playerMaskView.titleLabel.text = _title;
}

#pragma mark - 播放地址
- (void)setUrl:(NSURL *)url{
    if (_url == url) {
        return;
    }
    [self resetPlayer];
    //设置静音模式
    AVAudioSession *seesion = [AVAudioSession sharedInstance];
    [seesion setCategory:AVAudioSessionCategoryPlayback error:nil];
    [seesion setActive:YES error:nil];
    _url = url;
    
    self.playerItem = [AVPlayerItem playerItemWithURL:_url];
    //创建播放器
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = _fillMode;
    [self.layer insertSublayer:_playerLayer atIndex:0];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    if (_playerItem == playerItem) {
        return;
    }
    
    if (_playerItem) {
        
        if (!self.isRemoveObserver) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
            [_playerItem removeObserver:self forKeyPath:@"status"];
            [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        }
        self.isRemoveObserver = YES;
        //重置播放器
        [self resetPlayer];
    }
    _playerItem = playerItem;
    if (playerItem) {
        self.isRemoveObserver = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - kvo监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {//加载完成,可以播放
            //加载完成后,再添加平移手势
            //添加平移手势,用来控制音量/亮度/快进快退
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDirection:)];
            pan.delegate = self;
            pan.maximumNumberOfTouches = 1;  //一根手指
            pan.delaysTouchesBegan = YES;
            pan.delaysTouchesEnded = YES;
            pan.cancelsTouchesInView = YES;
            [self.playerMaskView addGestureRecognizer:pan];
            self.player.muted = self.playerConfigure.isMute;
            [self addPeriodicTimeObserver];
        }else if (self.player.currentItem.status == AVPlayerItemStatusFailed){
            // 解析失败(播放失败)
            self.playerState = JJPlayerStateFailed;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        //计算缓冲进度
        NSTimeInterval timeInterval = [self calculateBufferProgress];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuratuon = CMTimeGetSeconds(duration);
        [self.playerMaskView.progressView setProgress:(timeInterval / totalDuratuon) animated:NO];
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        //当前缓冲时空的时候
        if (self.playerItem.isPlaybackBufferEmpty) {
            [self bufferingSomeSecond];//卡顿一会,缓冲几秒
        }
    }
    
}
#pragma mark - 滑动手势方法
- (void)panGestureDirection:(UIPanGestureRecognizer *)panGesture{
    //根据在view上pan的位置,确定是调节音量还是调节亮度
    CGPoint locationPoint = [panGesture locationInView:self];
    //我们要确定,响应水平移动和垂直移动
    //根据上次和本次移动的位置,算出一个速率的point
    CGPoint thePoint = [panGesture velocityInView:self];
    //判断是垂直移动还是水平移动
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{  //开始移动
            //使用绝对值来判断方向
            CGFloat x = fabs(thePoint.x);
            CGFloat y = fabs(thePoint.y);
            if (x > y) { //水平移动
                [self jj_playerMaskViewProgressSliderTouchBegan:nil];
                //显示遮罩
                [UIView animateWithDuration:0.5 animations:^{
                    self.playerMaskView.topToolBar.alpha = 1;
                    self.playerMaskView.bottomToolBar.alpha = 1;
                }];
                //取消隐藏
                self.panDirection = JJPanDirectionHorizontalMoved;
                //给sumtime赋初值
                CMTime time = self.player.currentTime;
                self.sumTime = time.value/time.timescale;
            }else if (x < y){ //垂直移动
                self.panDirection = JJPanDirectionVerticalMoved;
                //开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > CGRectGetWidth(self.frame)/2) {
                    self.isVolume = YES;
                }else{ //装态改为亮度调节
                    self.isVolume = NO;
                }
            }else{
                //不处理该情况
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:{  //正在移动
            if (self.panDirection == JJPanDirectionHorizontalMoved) {
                [self panHorizontalMoved:thePoint.x];
            }else if (self.panDirection == JJPanDirectionVerticalMoved){
                [self panVerticalMoved:thePoint.y];
            }else{
                NSLog(@"移动方向判断有误");
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //移动结束也需要判断垂直和平移
            if (self.panDirection == JJPanDirectionHorizontalMoved) {
                self.sumTime = 0;
                [self jj_playerMaskViewProgressSliderTouchEnd:nil];
            }else if (self.panDirection == JJPanDirectionVerticalMoved){
                self.isVolume = NO;
            }
        }
        default:
            break;
    }
}

#pragma mark - 垂直滑动,调节音量和亮度
- (void)panVerticalMoved:(CGFloat)value{
    if (self.isVolume) { //音量
        self.volumeViewSlider.value -= value/10000.0;
    }else{ //亮度
        [UIScreen mainScreen].brightness -= value/10000.0;
    }
}
#pragma mark - 水平滑动,调节进度
- (void)panHorizontalMoved:(CGFloat)value{
    //水平滑动进度,逻辑多,多做一些判断
    if (value == 0) {
        return;
    }
    //每次滑动时间需要叠加.
    self.sumTime += value/200.0;
    //需要给sumTime限制范围
    CMTime totalTime = self.playerItem.duration;
    CGFloat totalMovieDuration = (CGFloat)(totalTime.value/totalTime.timescale);
    if (self.sumTime > totalMovieDuration) {
        self.sumTime = totalMovieDuration;
    }
    if (self.sumTime < 0) {
        self.sumTime = 0;
    }
    self.isDragged = YES;
    //计算出拖动的当前秒数
    CGFloat dragedSeconds = self.sumTime;
    //滑杆进度
    CGFloat sliderValue = dragedSeconds/totalMovieDuration;
    //设置滑杆
    self.playerMaskView.slider.value = sliderValue;
    
    //转换成CMTime才能player来控制进度
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    NSInteger proMin = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60;//当前秒
    NSInteger proSec = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60;//当前分钟
    self.playerMaskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",proSec,proMin];
    
}



// 计算缓冲进度
- (NSTimeInterval)calculateBufferProgress{
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}


#pragma mark - 重置播放器
- (void)resetPlayer{
    //重置状态
    self.playerState = JJPlayerStatePause;
    _isUserPlay = YES;//用户点击标志
    _isDisappear = NO;//工具条隐藏标记
    //移除之前的
    [self pause];//先暂停
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player = nil;
    //还原进度条和缓冲条
    self.playerMaskView.slider.value = 0;
    self.playerMaskView.progressView.progress = 0;
    //重置时间
    self.playerMaskView.currentTimeLabel.text = @"00:00";
    self.playerMaskView.totalTimeLabel.text = @"00:00";

    [self destoryToolBarTimer];
    //重置Toolbar
    [UIView animateWithDuration:0.25 animations:^{
        self.playerMaskView.topToolBar.alpha = 1.0;
        self.playerMaskView.bottomToolBar.alpha = 1.0;
    }];
    //重新添加工具条消失定时器
    [self resetTooBarDisappearTimer];
    self.playerMaskView.failButton.hidden = YES;
    //开始转子动化
    [self.playerMaskView.loadingView startAnimation];
}

//暂停,缓冲几秒
- (void)bufferingSomeSecond{
    self.playerState = JJPlayerStateBuffering;
    _isBuffering = YES;
    
    //需要暂停一会
    [self pause];
    //延迟执行,
    [self performSelector:@selector(bufferingSomeSecondEnd) withObject:@"Buffering" afterDelay:5];

}

//缓冲几秒结束后操作
- (void)bufferingSomeSecondEnd{
    [self play];
    //如果执行了play还是没有播放,则说明缓存不够,再次缓存
    _isBuffering = NO;
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];//继续缓冲几秒
    }
}

#pragma mark - 拖动进度条 delgate
//开始
- (void)jj_playerMaskViewProgressSliderTouchBegan:(JJSlider *)slider{
    //暂停
    [self pause];
    //销毁定时器
    [self destoryToolBarTimer];
}
//结束
- (void)jj_playerMaskViewProgressSliderTouchEnd:(JJSlider *)slider{
    if (slider.value != 1) {
        _isFinish = NO;
    }
    [self.playerItem cancelPendingSeeks];

    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];
    }else{
        [self play];
    }
    //重新添加定时器
    [self resetTooBarDisappearTimer];
}
//拖拽过程中
- (void)jj_playerMaskViewProgressSliderTouchChanged:(JJSlider *)slider{
    //计算出拖动的当前秒数
    
    CMTime totalCMTime = self.playerItem.duration;
    CGFloat total = (CGFloat)(totalCMTime.value/totalCMTime.timescale);
    //计算出拖动的当前秒数
    CGFloat dragedSeconds = total * slider.value;
    //转换成CMTime才能player来控制进度
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    NSInteger proMin = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60;//当前秒
    NSInteger proSec = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60;//当前分钟
    self.playerMaskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",proSec,proMin];
}

//播放按钮点击事件代理
- (void)jj_playerMaskViewPlayButtonAction:(UIButton *)button{
    if (!button.isSelected) {
        _isUserPlay = NO;
        [self pause];
    }else{
        _isUserPlay = YES;
        if (self.isFinish) {
            _isFinish = NO;
            [_player seekToTime:CMTimeMake(0, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        }
        [self play];
    }
    //点击播放/暂停之后,需要重新计时
    [self resetTooBarDisappearTimer];
}
//全屏按钮点击事件代理
- (void)jj_playerMaskViewFullButtonAction:(UIButton *)button{
    if (!_isFullScreen) {
        _isUserTapMaxButton = YES;
        [self fullScreenWithDirection:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self originalScreen];
    }
}

//返回按钮
- (void)jj_playerMaskViewBackButtonAction:(UIButton *)button{
    if (self.isFullScreen) {
        [self originalScreen];
    }else{
        if (self.BackBlock) {
            self.BackBlock(button);
        }
    }
}
#pragma mark - 屏幕翻转就会调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

     
}

#pragma mark - 全屏
- (void)fullScreenWithDirection:(UIInterfaceOrientation)direction{
    //记录播放器父类
    _fatherView = self.superview;
    //记录原始大小
    _customFrame = self.frame;
    _isFullScreen = YES;
    [self resetTopBarHiddenType];
    //添加到keyWindow上
    UIWindow *keyWindow = [self getKeyWindow];
    [keyWindow addSubview:self];
    
    
    if (self.playerConfigure.isLandscape) {// isLandscape :当前页面是否支持全屏,默认NO
        //手动点击需要旋转方向
        if (_isUserTapMaxButton) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        }
        self.frame = CGRectMake(0, 0, MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
    } else {
        //播放器所在控制器不支持旋转，采用旋转view的方式实现
        CGFloat duration = 0.3;
         
        // CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        
        if (direction == UIInterfaceOrientationLandscapeLeft) {
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI / 2);
            }];
        } else {
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeRotation(- M_PI / 2);
            }];
        }
        self.frame = CGRectMake(0, 0, MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
    }
    self.playerMaskView.fullButton.selected = YES;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIWindow *)getKeyWindow{
    if (@available(iOS 13.0, *)){
        return [UIApplication sharedApplication].windows.lastObject;
    }else{
        return [UIApplication sharedApplication].keyWindow;
    }
}
#pragma mark - 还原原始大小
- (void)originalScreen{
    self.isFullScreen = NO;
    self.isUserTapMaxButton = NO;
    [self resetTopBarHiddenType];
    if (self.playerConfigure.isLandscape) {
        //还原为竖屏
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    } else {
        //还原
//        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        CGFloat duration = 0.3;
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    self.frame = _customFrame;
    //还原到原有父类上
    [_fatherView addSubview:self];
    self.playerMaskView.fullButton.selected = NO;
}

//播放失败按钮事件
- (void)jj_playerMaskViewFailButtonAction:(UIButton *)button{
    [self setUrl:_url];
    [self play];
}

///播放完成
- (void)moviePlayDidEnd:(NSNotification *)nofication{
    _isFinish = YES;
    if (self.playerConfigure.repeatPlay) {
        _isFinish = NO;
        [_player seekToTime:CMTimeMake(0, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self play];
    } else {
        [self pause];
    }
    if (self.EndBlock){
        self.EndBlock();
    }
}

/// 播放
- (void)play{
    self.playerMaskView.playButton.selected = YES;
//    [self.layer insertSublayer:self.playerLayer atIndex:0];
    if (self.isFinish && self.playerMaskView.slider.value == 1) {
        _isFinish = NO;
        [_player seekToTime:CMTimeMake(0, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    } else {
        [self.player play];
    }
}

/// 暂停
- (void)pause{
    [self.playerItem cancelPendingSeeks];
    self.playerMaskView.playButton.selected = NO;
    [self.player pause];
}

- (void)endPlay:(EndBolck)end{
    self.EndBlock = end;
}

- (void)backButtonAction:(BackButtonBlock)backBlock{
    self.BackBlock = backBlock;
}

/// 销毁播放器
- (void)destoryPlayer{
    [self pause];
    //销毁定时器
    [self destoryToolBarTimer];
    // 取消延迟执行的方法(就是卡顿缓冲的代码)
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(bufferingSomeSecondEnd) object:@"Buffering"];
    //移除相关UI
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.playerMaskView.loadingView = nil;
    self.player = nil;
    self.playerMaskView = nil;
}
#pragma mark - 通知

// 播放完成通知
- (void)playbackFinished:(NSNotification *)notification
{
//    AVPlayerItem *playerItem = (AVPlayerItem *)notification.object;
    
}

// 插拔耳机通知
- (void)routeChanged:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    int changeReason = [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    // 旧输出不可用
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = [routeDescription.outputs firstObject];
        // 原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause];
        }
    }
}

// 来电、闹铃打断播放通知
- (void)interruptionComing:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    AVAudioSessionInterruptionType type = [userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self pause];
    }
}

/** 屏幕翻转监听事件 */
- (void)orientationChanged:(NSNotification *)notification {
    
    if (self.playerConfigure.autoRotate) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeLeft){
            if (!_isFullScreen){
                if (self.playerConfigure.isLandscape) {
                    //播放器所在控制器页面支持旋转情况下，和正常情况是相反的
                    [self fullScreenWithDirection:UIInterfaceOrientationLandscapeRight];
                }else{
                    [self fullScreenWithDirection:UIInterfaceOrientationLandscapeLeft];
                }
            }
        } else if (orientation == UIDeviceOrientationLandscapeRight){
            if (!_isFullScreen){
                if (self.playerConfigure.isLandscape) {
                    [self fullScreenWithDirection:UIInterfaceOrientationLandscapeLeft];
                }else{
                    [self fullScreenWithDirection:UIInterfaceOrientationLandscapeRight];
                }
            }
        } else {
            if (_isFullScreen){
                [self originalScreen];
            }
        }
    }
}

/** 应用进入后台 */
- (void)appDidEnterBackground:(NSNotification *)notify {
    [self pause];
}

/** 应用进入前台 */
- (void)appDidEnterPlayground:(NSNotification *)notify {
    if (self.isUserPlay) {
        [self play];
    }
}


#pragma mark - lazy
- (JJPlayerMaskView *)playerMaskView{
    if (_playerMaskView == nil) {
        _playerMaskView = [[JJPlayerMaskView alloc] init];
        _playerMaskView.progressBackGroundColor = self.playerConfigure.progressBackgroundColor;
        _playerMaskView.progressBufferColor = self.playerConfigure.progressBufferColor;
        _playerMaskView.progressPlayFinishColor = self.playerConfigure.progressPlayFinishColor;
        _playerMaskView.delegate = self;
        //创建点击事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureAction:)];
        [_playerMaskView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureAction:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [_playerMaskView addGestureRecognizer:doubleTap];
        //只有当doubleTapGesture识别失败的时候(即识别出这不是双击操作)，singleTapGesture才能开始识别
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return _playerMaskView;
}

- (JJPlayerConfigure *)playerConfigure{
    if (_playerConfigure == nil) {
        _playerConfigure = [JJPlayerConfigure defaultConfigure];
    }
    return _playerConfigure;
}








- (void)dealloc{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    //回到竖屏
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//#ifdef DEBUG
    NSLog(@"JJPlayerView播放器被销毁了");
//#endif
    
}


@end
