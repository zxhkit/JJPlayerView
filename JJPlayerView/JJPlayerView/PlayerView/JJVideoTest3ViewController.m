//
//  JJVideoTest3ViewController.m
//  iOS_Tools
//
//  Created by 播呗网络 on 2020/9/27.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJVideoTest3ViewController.h"
#import "JJVideoTableViewCell.h"
#import "JJPlayer.h"


@interface JJVideoTest3ViewController ()
<UITableViewDelegate,
UITableViewDataSource,
JJVideoTableViewCellDelegate
>

@property (nonatomic, strong) JJTableView *tableView;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) JJPlayerView *playerView;

@property (nonatomic, strong) JJVideoTableViewCell *lastCell;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation JJVideoTest3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationCustomView.hidden = NO;
    self.navigationCustomView.title = @"视频在cell上自动播放";
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
    
    //设置自动计算行号模式
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //设置预估行高
    self.tableView.estimatedRowHeight = 200;
    
}


#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JJVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JJVideoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (self.datas.count > indexPath.row) {
        JJVideoModel *model = self.datas[indexPath.row];
        cell.model = model;
    }
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    if (self.indexPath == indexPath) {
//        return;
//    }
//    self.indexPath = indexPath;
//    JJVideoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    if (self.datas.count > indexPath.row) {
//        [self.playerView destoryPlayer];
//        [self.playerView removeFromSuperview];
//        self.playerView = nil;
//
//        [cell addSubview:self.playerView];
//        JJVideoModel *model = self.datas[indexPath.row];
//        NSRange range = [model.videoName rangeOfString:@"."];
//        NSString *name = [model.videoName substringToIndex:range.location];
//        NSString *type = [model.videoName substringFromIndex:range.location+1];
//        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
//        _playerView.url = [NSURL fileURLWithPath:path];
//        _playerView.title = model.title;
//        [_playerView play];
//    }
//}

//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.indexPath == indexPath || self.lastCell == cell) {
        //因为复用，同一个cell可能会走多次
        [self.playerView destoryPlayer];
        [self.playerView removeFromSuperview];
        self.playerView = nil;
        self.indexPath = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll];
        }
    }
}
#pragma mark - scrollView 滚动停止
- (void)scrollViewDidEndScroll {
    NSLog(@"停止滚动了！！！");
    
    if (self.indexPath == nil) {
        
        CGFloat offSetY = self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame) / 2;
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, offSetY)];
        JJVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSLog(@"section: %ld - row: %ld - cellName = %@",indexPath.section, indexPath.row, cell.textLabel.text);
        
        [self jj_videoTableViewCellDidPlayButtonInCell:cell];
        
        
        
        //        NSArray * array = [self.tableView visibleCells];
        //        for (UITableViewCell * cell in array) {
        //            //获得中心线与cell相对于屏幕的Y坐标之差，若是在cell的高度之内，并大于0，那就是中心线上的cell，
        //            //若是想获得Cell的IndexPath，可以给cell加个NSIndexPath的属性，在返回cell的时候赋值给它
        //            CGPoint pInColl = [self.tableView convertPoint:cell.center toView:self.tableView];
        //            CGFloat cha = (kScreenHeight - kNavBarHeight - kBottomSafeHeight)/2 - (cell.frame.origin.y - self.tableView.contentOffset.y );
        //            if (cha > 0 && cha < 100) {
        //                cell.backgroundColor = [UIColor greenColor];
        //            }
        //        }
    }
}




#pragma mark - JJVideoTableViewCellDelegate

- (void)jj_videoTableViewCellDidPlayButtonInCell:(JJVideoTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (self.indexPath == indexPath) {
        return;
    }
    self.indexPath = indexPath;
    
    if (self.datas.count > indexPath.row) {
        [self.playerView destoryPlayer];
        [self.playerView removeFromSuperview];
        self.playerView = nil;
        
        [cell addSubview:self.playerView];
        JJVideoModel *model = self.datas[indexPath.row];
        NSRange range = [model.videoName rangeOfString:@"."];
        NSString *name = [model.videoName substringToIndex:range.location];
        NSString *type = [model.videoName substringFromIndex:range.location+1];
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
        _playerView.url = [NSURL fileURLWithPath:path];
        _playerView.title = model.title;
        [_playerView play];
    }
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
        //_tableView.showsVerticalScrollIndicator = NO;
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (JJPlayerView *)playerView{
    if (_playerView == nil) {
        _playerView = [[JJPlayerView alloc] initWithFrame:CGRectMake(0, 66, kScreenWidth, 300)];
        [_playerView updatePlayerModifyConfigure:^(JJPlayerConfigure * _Nonnull configure) {
            configure.strokeColor = [UIColor redColor];
            configure.topToolBarHiddenType = JJTopToolBarHiddenNever;
            configure.repeatPlay = YES;
        }];
    }
    return _playerView;
}


- (void)dealloc{
    NSLog(@"JJVideoTest3ViewController - 释放了");
}

@end
