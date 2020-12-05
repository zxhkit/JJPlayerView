//
//  JJVideoTest5ViewController.m
//  iOS_Tools
//
//  Created by 播呗网络 on 2020/9/29.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJVideoTest5ViewController.h"
#import "JJPlayer.h"


@interface JJVideoTest5ViewController ()

@property (nonatomic, strong) JJPlayerView *playerView;


@end

@implementation JJVideoTest5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationCustomView.hidden = NO;
    self.navigationCustomView.title = @"push支持多方向";
    
    @weakify(self);
    self.navigationCustomView.backBtnActionCallBack = ^{
        @strongify(self);
        [self.playerView destoryPlayer];
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    JJPlayerView *playerView = [[JJPlayerView alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, 300)];
    _playerView = playerView;
//    _playerView.title = @"自古英雄多红颜";
    _playerView.title = @"哎哟哎,搞笑节奏走起来!!!!";
    [self.view addSubview:_playerView];
    
    [_playerView updatePlayerModifyConfigure:^(JJPlayerConfigure * _Nonnull configure) {
        configure.strokeColor = [UIColor redColor];
        configure.topToolBarHiddenType = JJTopToolBarHiddenNever;
    }];
    
    //视频地址
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video1" ofType:@"mp4"];
//    NSString *urlString = @"https://dh2.v.netease.com/2017/cg/fxtpty.mp4";
    
//    NSString *urlString = @"http://120.24.184.1/cdm/media/k2/videos/1.mp4";
//    _playerView.url = [NSURL URLWithString:urlString];
    _playerView.url = [NSURL fileURLWithPath:path];

    [_playerView play];
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    NSLog(@"video-%@",parent);
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"video-%@",parent);
    if(!parent){
        NSLog(@"页面pop成功了");
        [self.playerView destoryPlayer];
        [self.playerView removeFromSuperview];
        self.playerView = nil;
        
    }
}

#pragma mark -- 需要设置全局支持旋转方向，然后重写下面三个方法可以让当前页面支持多个方向
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return YES;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}



- (void)dealloc{
    NSLog(@"JJVideoTest1ViewController - 释放了");
}








@end
