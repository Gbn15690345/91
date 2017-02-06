//
//  MianFeiViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/30.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "MianFeiViewController.h"
#import "SelectedImageModel.h"
#import "HeaderTableViewCell.h"
#import "HeaderImageDetailViewController.h"
@interface MianFeiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)NSUInteger pi;
@end

@implementation MianFeiViewController
- (NSString *)dataUrl{
    return self.url;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //更改自带tableView的位置
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 99+49, 0);
    
    //同时更改右侧指示条的位置
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.view addSubview:_tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    // Do any additional setup after loading the view.
}
- (void)right{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestData{
    [_dataArray removeAllObjects];
     _pi = 1;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@&pi=%ld",self.dataUrl,self.pi] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary * dic in responseObject[@"Result"][@"items"]) {
            SelectedImageModel * model = [[SelectedImageModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)loadMore{
    _pi ++;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@&pi=%ld",self.dataUrl,self.pi] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary * dic in responseObject[@"Result"][@"items"]) {
            SelectedImageModel * model = [[SelectedImageModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HeaderTableViewCell class]) owner:self options:nil] firstObject];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HeaderImageDetailViewController * detail = [[HeaderImageDetailViewController alloc]init];
    SelectedImageModel * model = _dataArray[indexPath.row];
    detail.url = model.detailUrl;
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
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
