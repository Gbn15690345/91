//
//  HeaderImageViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/21.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "HeaderImageViewController.h"
#import "SelectedImageModel.h"
#import "HeaderTableViewCell.h"
#import "HeaderImageDetailViewController.h"
@interface HeaderImageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation HeaderImageViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSArray array];
    self.navigationItem.title = self.name;
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
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
- (void)requestData{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"Result"][@"items"]) {
            SelectedImageModel * model = [[SelectedImageModel alloc]init];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    self.hidesBottomBarWhenPushed = NO;
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
