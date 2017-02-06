//
//  YingYongViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/28.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "YingYongViewController.h"
#import "YingYongModel.h"
#import "YingYongTableViewCell.h"
#import "HeaderImageViewController.h"
@interface YingYongViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation YingYongViewController

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

    // Do any additional setup after loading the view.
}
- (void)requestData{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"Result"]) {
            YingYongModel * model = [[YingYongModel alloc]init];
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
    return 220;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YingYongTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YingYongTableViewCell class]) owner:self options:nil] firstObject];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HeaderImageViewController * header = [[HeaderImageViewController alloc]init];
    YingYongModel * model = _dataArray[indexPath.row];
    header.name = model.name;
    header.url = model.url;
    [self.navigationController pushViewController:header animated:YES];
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
