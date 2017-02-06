//
//  EvaluationViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/20.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "EvaluationViewController.h"
#import "FenLeiModel.h"
#import "FenLeiTableViewCell.h"
#import "EvaluationDetailViewController.h"
@interface EvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong)UISegmentedControl * control;
@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _url = @"http://applebbx.sj.91.com/soft/phone/cat.aspx?act=213&cuid=c0b61e0665fecc566f773be70751bdfbbcdab926&pi=1&spid=2&imei=1DB79479-028B-4538-A915-9BA4B2ADD673&osv=10.1.1&dm=iPhone8,4&sv=3.1.3&nt=10&mt=1&pid=2";
    self.view.backgroundColor =[UIColor whiteColor];
    NSArray * array = @[@"应用",@"游戏"];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:array];
    
    self.navigationItem.titleView = segmentControl;
    
    segmentControl.selectedSegmentIndex = 0;
    
    segmentControl.frame = CGRectMake(0, 0, 300, 30);
    
    [segmentControl addTarget:self action:@selector(chagnePage:) forControlEvents:UIControlEventValueChanged];
    
    segmentControl.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationItem.titleView = segmentControl;
    self.control = segmentControl;
    
    _dataArray = [NSArray array];
    UITableView * tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
- (void)chagnePage:(UISegmentedControl *)control{
    
    if (control.selectedSegmentIndex == 0) {
        self.url = @"http://applebbx.sj.91.com/soft/phone/cat.aspx?act=213&cuid=c0b61e0665fecc566f773be70751bdfbbcdab926&pi=1&spid=2&imei=1DB79479-028B-4538-A915-9BA4B2ADD673&osv=10.1.1&dm=iPhone8,4&sv=3.1.3&nt=10&mt=1&pid=2";
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestData];
        }];
        [self.tableView.mj_header beginRefreshing];
        [self.tableView reloadData];
    }else if (control.selectedSegmentIndex == 1){
        self.url = @"http://applebbx.sj.91.com/soft/phone/cat.aspx?act=218&cuid=c0b61e0665fecc566f773be70751bdfbbcdab926&pi=1&spid=2&imei=1DB79479-028B-4538-A915-9BA4B2ADD673&osv=10.1.1&dm=iPhone8,4&sv=3.1.3&nt=10&mt=1&pid=2";
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestData];
        }];
        [self.tableView.mj_header beginRefreshing];
        [self.tableView reloadData];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FenLeiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FenLeiTableViewCell class]) owner:self options:nil] firstObject];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EvaluationDetailViewController * detail = [[EvaluationDetailViewController alloc]init];
    FenLeiModel * model = _dataArray[indexPath.row];
    detail.dataArray = model.listTags;
    detail.name = model.name;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)requestData{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"Result"]) {
            FenLeiModel * model = [[FenLeiModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [arr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataArray = [arr mutableCopy];
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
