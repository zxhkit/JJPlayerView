//
//  JJBaseViewController.h
//  Douyin_oc
//
//  Created by 播呗网络 on 2020/7/18.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JJBaseNavigationView;
@interface JJBaseViewController : UIViewController

@property (nonatomic, strong) JJBaseNavigationView *navigationCustomView;

- (void)setupNavigationViewTitle:(NSString *)title;

- (void)backButtonAction;

@end

NS_ASSUME_NONNULL_END
