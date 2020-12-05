//
//  JJVideoViewController.m
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/21.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJVideoViewController.h"
#import "JJVideoTest1ViewController.h"
#import "JJVideoTest2ViewController.h"
#import "JJVideoTest3ViewController.h"
#import "JJVideoTest4ViewController.h"



@interface JJVideoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JJTableView *tableView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation JJVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationCustomView.hidden = NO;
    self.navigationCustomView.title = @"视频播放";
    
    
    [self setupUI];
}


#pragma mark -
#pragma mark - 初始化界面
- (void)setupUI
{
    self.data = @[@"在view上展示",@"在cell上展示",@"在cell自动播放",@"在tableView的headerView上播放"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(kNavBarHeight);
    }];
   
    /**
     @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4",
     @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
     @"https://media.w3.org/2010/05/sintel/trailer.mp4",
     @"http://mvvideo2.meitudata.com/576bc2fc91ef22121.mp4",
     @"http://mvvideo10.meitudata.com/5a92ee2fa975d9739_H264_3.mp4",
     @"http://mvvideo11.meitudata.com/5a44d13c362a23002_H264_11_5.mp4",
     @"http://mvvideo10.meitudata.com/572ff691113842657.mp4",
     
     
     */
    
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        JJVideoTest1ViewController *vc = [[JJVideoTest1ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        JJVideoTest2ViewController *vc = [[JJVideoTest2ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        JJVideoTest3ViewController *vc = [[JJVideoTest3ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        JJVideoTest4ViewController *vc = [[JJVideoTest4ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        //_tableView.showsVerticalScrollIndicator = NO;
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
