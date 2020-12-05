//
//  JJVideoTest4ViewController.m
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/28.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJVideoTest4ViewController.h"
#import "JJVideoTableViewCell.h"
#import "JJPlayer.h"
#import "JJVideoTableHeaderView.h"

@interface JJVideoTest4ViewController ()
<UITableViewDelegate,
UITableViewDataSource,
JJVideoTableHeaderViewDelegate
>

@property (nonatomic, strong) JJTableView *tableView;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) JJPlayerView *playerView;

@property (nonatomic, strong) JJVideoTableViewCell *lastCell;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) JJVideoTableHeaderView *headerView;;

@end

@implementation JJVideoTest4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationCustomView.hidden = NO;
    self.navigationCustomView.title = @"在tableView的headerView上播放";
    @weakify(self);
    self.navigationCustomView.backBtnActionCallBack = ^{
        @strongify(self);
        [self.playerView destoryPlayer];
        [self.playerView removeFromSuperview];
        self.playerView = nil;
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self setupUI];

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


#pragma mark - 初始化界面
- (void)setupUI
{
    
    // 1. 获取plist文件的地址
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JJVideoData" ofType:@"plist"];
    //  2. 加载Plist字典集合
    NSArray *arrPlist = [NSArray arrayWithContentsOfFile:filePath];
    //  3. 遍历字典集合，创建模型对象，添加到一个可变数组中
    NSArray *userArray = [JJVideoModel mj_objectArrayWithKeyValuesArray:arrPlist];
    self.datas = [NSArray arrayWithArray:userArray];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(kNavBarHeight);
        make.bottom.equalTo(self.view).mas_offset(-kBottomSafeHeight);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.model = self.datas.lastObject;
    self.headerView.delegate = self;
    //设置自动计算行号模式
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //设置预估行高
    self.tableView.estimatedRowHeight = 200;
    
}


#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JJVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JJVideoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.datas.count > indexPath.row) {
        JJVideoModel *model = self.datas[indexPath.row];
        cell.model = model;
    }
    return cell;
}

#pragma mark - JJVideoTableViewCellDelegate

- (void)jj_videoTableHeaderViewDidPlayButtonInView:(JJVideoTableHeaderView *)headerView{
    [self.playerView destoryPlayer];
    [self.playerView removeFromSuperview];
    self.playerView = nil;
    
    [headerView addSubview:self.playerView];
    JJVideoModel *model = self.datas.lastObject;
    NSRange range = [model.videoName rangeOfString:@"."];
    NSString *name = [model.videoName substringToIndex:range.location];
    NSString *type = [model.videoName substringFromIndex:range.location+1];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    _playerView.url = [NSURL fileURLWithPath:path];
    _playerView.title = model.title;
    [_playerView play];
}

#pragma mark - getter and setter

- (JJTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[JJTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[JJVideoTableViewCell class] forCellReuseIdentifier:@"JJVideoTableViewCell"];
    }
    return _tableView;
}

- (JJPlayerView *)playerView{
    if (_playerView == nil) {
        _playerView = [[JJPlayerView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 300)];
        [_playerView updatePlayerModifyConfigure:^(JJPlayerConfigure * _Nonnull configure) {
            configure.strokeColor = [UIColor redColor];
            configure.topToolBarHiddenType = JJTopToolBarHiddenNever;
            configure.repeatPlay = YES;
        }];
    }
    return _playerView;
}

- (JJVideoTableHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[JJVideoTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 345)];
    }
    return _headerView;
}


- (void)dealloc{
    NSLog(@"JJVideoTest4ViewController - 释放了");
}


@end
