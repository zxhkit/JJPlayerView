//
//  JJBaseViewController.m
//  Douyin_oc
//
//  Created by 播呗网络 on 2020/7/18.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJBaseViewController.h"

@interface JJBaseViewController ()


@end

@implementation JJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationCustomView];
    
    [self.navigationCustomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kNavBarHeight);
    }];
    
    _navigationCustomView.hidden = YES;

}

- (void)setupNavigationViewTitle:(NSString *)title{
    self.navigationCustomView.title = title;
}


- (void)backButtonAction{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (JJBaseNavigationView *)navigationCustomView{
    if (_navigationCustomView == nil) {
        _navigationCustomView = [[JJBaseNavigationView alloc] init];
        _navigationCustomView.title = @"首页";
        @weakify(self);
        _navigationCustomView.backBtnActionCallBack = ^{
            @strongify(self);
            [self backButtonAction];
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navigationCustomView;
}

@end
