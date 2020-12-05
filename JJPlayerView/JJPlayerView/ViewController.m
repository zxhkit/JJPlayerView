//
//  ViewController.m
//  JJPlayerView
//
//  Created by zhouxuanhe on 2020/12/5.
//

#import "ViewController.h"
#import "JJVideoTest1ViewController.h"
#import "JJVideoTest2ViewController.h"
#import "JJVideoTest3ViewController.h"
#import "JJVideoTest4ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) JJBaseNavigationView *navigationCustomView;

@property (nonatomic, strong) JJTableView *tableView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navigationCustomView];
    [self.navigationCustomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kNavBarHeight);
    }];
    self.navigationCustomView.title = @"视频播放";
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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

- (JJBaseNavigationView *)navigationCustomView{
    if (_navigationCustomView == nil) {
        _navigationCustomView = [[JJBaseNavigationView alloc] init];
        _navigationCustomView.title = @"首页";
        _navigationCustomView.backBtn.hidden = YES;
        @weakify(self);
        _navigationCustomView.backBtnActionCallBack = ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navigationCustomView;
}

@end
