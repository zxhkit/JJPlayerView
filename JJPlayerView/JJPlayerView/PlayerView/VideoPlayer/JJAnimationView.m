//
//  JJAnimationView.m
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/26.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJAnimationView.h"

@implementation JJAnimationConfigure

+ (instancetype)defaultConfigure {

    JJAnimationConfigure *configure = [[JJAnimationConfigure alloc] init];
    configure.startAngle = - M_PI_2;
    configure.endAngle = M_PI + M_PI_2;
    configure.number = 5;
    configure.intervalDuration = 0.12;
    configure.duration = 2;
    configure.diameter = 8;
    configure.backgroundColor = [UIColor redColor];
    return configure;
}

@end


@interface JJAnimationView ()

///默认配置
@property (nonatomic, strong) JJAnimationConfigure *defaultConfigure;
///是否开始动画
@property (nonatomic, assign) BOOL isStart;
///是否暂停
@property (nonatomic, assign) BOOL isPause;
///layer数组
@property (nonatomic, strong) NSMutableArray<CALayer *> *layerArray;

@end
@implementation JJAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layerArray = [NSMutableArray array];
    }
    return self;
}

- (void)animation {
    CGFloat origin_x = self.frame.size.width * 0.5;
    CGFloat origin_y = self.frame.size.height * 0.5;
    for (NSInteger i = 0; i < self.defaultConfigure.number; i++) {
        CGFloat scale = (CGFloat)(self.defaultConfigure.number + 1 - i) / (CGFloat)(self.defaultConfigure.number + 1);
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.defaultConfigure.backgroundColor.CGColor;
        layer.frame = CGRectMake(-500, -500, scale * self.defaultConfigure.diameter, scale * self.defaultConfigure.diameter);
        layer.cornerRadius = scale * self.defaultConfigure.diameter * 0.5;
        //创建运动的轨迹动画
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.duration = self.defaultConfigure.duration - self.defaultConfigure.intervalDuration * self.defaultConfigure.number;
        pathAnimation.beginTime = i * self.defaultConfigure.intervalDuration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(origin_x, origin_y) radius:(self.frame.size.width - self.defaultConfigure.diameter) * 0.5 startAngle:self.defaultConfigure.startAngle endAngle:self.defaultConfigure.endAngle  clockwise:YES].CGPath;
        //组动画
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[pathAnimation];
        group.duration = self.defaultConfigure.duration;
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeForwards;
        group.repeatCount = INTMAX_MAX;
        //设置运转的动画
        [layer addAnimation:group forKey:@"moveTheCircleOne"];
        [self.layerArray addObject:layer];
    }
}
#pragma mark - 更新配置
- (void)updateWithConfigure:(void(^)(JJAnimationConfigure *configure))configBlock {
    if (configBlock) {
        configBlock(self.defaultConfigure);
    }
    CGFloat intervalDuration = (CGFloat)(self.defaultConfigure.duration / 2.0 / (CGFloat)self.defaultConfigure.number);
    self.defaultConfigure.intervalDuration = MIN(self.defaultConfigure.intervalDuration, intervalDuration);
    if (self.isStart) {
        [self stopAnimation];
        [self startAnimation];
    }
}
#pragma mark - 开始动画
- (void)startAnimation {
    [self animation];
    for (CALayer *layer in self.layerArray) {
        [self.layer addSublayer:layer];
    }
    self.isStart = YES;
}
#pragma mark - 结束动画
- (void)stopAnimation {
    for (CALayer *layer in self.layerArray) {
        [layer removeFromSuperlayer];
    }
    [self.layerArray removeAllObjects];
    self.isStart = NO;
}
#pragma mark - 暂停动画
- (void)pauseAnimation {
    if (self.isPause) {
        return;
    }
    self.isPause = YES;
    CFTimeInterval time = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0;
    self.layer.timeOffset = time;
}
#pragma mark - 恢复动画
- (void)resumeAnimation {
    if (!self.isPause) {
        return;
    }
    self.isPause = NO;
    CFTimeInterval pausedTime = self.layer.timeOffset;
    self.layer.speed = 1;
    self.layer.timeOffset = 0;
    self.layer.beginTime = 0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

#pragma mark - 默认配置
- (JJAnimationConfigure *) defaultConfigure {
    if (_defaultConfigure == nil) {
        _defaultConfigure = [JJAnimationConfigure defaultConfigure];
    }
    return _defaultConfigure;
}





@end
