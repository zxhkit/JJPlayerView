//
//  JJVideoTableHeaderView.h
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/28.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JJVideoTableHeaderView;
@protocol JJVideoTableHeaderViewDelegate <NSObject>

- (void)jj_videoTableHeaderViewDidPlayButtonInView:(JJVideoTableHeaderView *)headerView;

@end

@interface JJVideoTableHeaderView : UIView

@property (nonatomic, weak)  id<JJVideoTableHeaderViewDelegate > delegate;

@property (nonatomic, strong) JJVideoModel *model;

@end

NS_ASSUME_NONNULL_END
