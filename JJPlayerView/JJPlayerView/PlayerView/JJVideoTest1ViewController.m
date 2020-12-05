//
//  JJVideoTest1ViewController.m
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/21.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJVideoTest1ViewController.h"
#import "JJPlayer.h"


@interface JJVideoTest1ViewController ()

@property (nonatomic, strong) JJPlayerView *playerView;
@end

@implementation JJVideoTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationCustomView.hidden = NO;
    self.navigationCustomView.title = @"视频在UIView上播放";
    
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
        configure.isLandscape = YES;
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

- (void)dealloc{
    NSLog(@"JJVideoTest1ViewController - 释放了");
}

@end
