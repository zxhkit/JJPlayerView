//
//  JJBaseNavigationView.h
//  iOS_Tools
//
//  Created by 播呗网络 on 2020/8/23.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJBaseNavigationView : UIView

///标题
@property (nonatomic, strong) UILabel         *titleLabel;
///背景图片
@property (nonatomic, strong) UIImageView     *backgroundImgV;
///返回按钮
@property (nonatomic, strong) UIButton        *backBtn;

@property (nonatomic, copy)   void(^backBtnActionCallBack)(void);

@property (nonatomic, copy)     NSString *title;



@end

NS_ASSUME_NONNULL_END
