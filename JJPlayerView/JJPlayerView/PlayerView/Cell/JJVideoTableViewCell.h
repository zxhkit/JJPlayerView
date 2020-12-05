//
//  JJVideoTableViewCell.h
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/27.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJPlayer.h"
NS_ASSUME_NONNULL_BEGIN


@class JJVideoTableViewCell;
@protocol JJVideoTableViewCellDelegate <NSObject>

- (void)jj_videoTableViewCellDidPlayButtonInCell:(JJVideoTableViewCell *)cell;

@end

@interface JJVideoTableViewCell : UITableViewCell

@property(nonatomic,weak)  id<JJVideoTableViewCellDelegate > delegate;


@property (nonatomic, strong) JJVideoModel *model;


@end

NS_ASSUME_NONNULL_END
