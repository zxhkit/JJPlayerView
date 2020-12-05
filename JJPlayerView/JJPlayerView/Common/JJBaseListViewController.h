//
//  JJBaseListViewController.h
//  iOS_Tools
//
//  Created by 播呗网络 on 2020/10/27.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJTableView.h"



NS_ASSUME_NONNULL_BEGIN

@interface JJBaseListViewController : JJBaseViewController

@property (nonatomic, strong) JJTableView *tableView;


@property (nonatomic, strong) NSArray *data;



@end

NS_ASSUME_NONNULL_END
