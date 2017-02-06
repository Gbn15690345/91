//
//  ChatViewDetailViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/26.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "ChatViewDetailViewController.h"
#import "ChatModel.h"
#import "ChatTableViewCell.h"
#import "BaiDuTieBaViewController.h"
@interface ChatViewDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * dataArray;
@end

@implementation ChatViewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSArray array];
    self.title = self.name;
    self.view.backgroundColor =[UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);
    [self.view addSubview:_tableView];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requsetdata];
    }];
    [_tableView.mj_header beginRefreshing];
    UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(right)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    // Do any additional setup after loading the view.
}
- (void)right{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ChatTableViewCell class]) owner:self options:nil] firstObject];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.model = _dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:0.1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel * model = _dataArray[indexPath.row];
    if (model.act == nil) {
        BaiDuTieBaViewController * baidu = [[BaiDuTieBaViewController alloc]init];
        baidu.name = model.name;
        self.tabBarController.tabBar.hidden = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baidu animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        ChatViewDetailViewController * chart = [[ChatViewDetailViewController alloc]init];
        chart.url = model.act;
        chart.name = model.name;
        [self.navigationController pushViewController:chart animated:YES];
    }
}
- (void)requsetdata{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"Result"]) {
            ChatModel * model = [[ChatModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [muarr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataArray = [muarr mutableCopy];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
