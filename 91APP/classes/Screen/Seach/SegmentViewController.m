//
//  SegmentViewController.m
//  91APP
//
//  Created by  wyzc02 on 17/1/4.
//  Copyright © 2017年 高炳楠. All rights reserved.
//

#import "SegmentViewController.h"
#import "SelectedImageModel.h"
#import "HeaderTableViewCell.h"
#import "HeaderImageDetailViewController.h"
#import "BaiDuTieBaViewController.h"
#import "OneChatTableViewCell.h"
#import "OneChatModel.h"
@interface SegmentViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UISegmentedControl * segmentControll;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * oneArray;
@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong)NSString * str;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)UISearchController * searchController;
@end

@implementation SegmentViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchBar.frame = CGRectMake(0, 0, 0, 40);
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    _searchController.active = YES;
    _searchController.searchBar.text = self.name;
    self.navigationItem.titleView = _searchController.searchBar;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (_searchController.searchBar.text.length == 0) {
        _searchController.active = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _oneArray = [NSMutableArray array];
    _page = 1;
    _str = [self.name  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _url = [NSString stringWithFormat:@"http://applebbx.sj.91.com/api/?keyword=%@&pi=%d&spid=2&osv=10.0.1&cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&dm=iPhone8,1&sv=3.1.3&act=203&nt=10&pid=2&mt=1",_str,_page];
    NSArray * array = @[@"聊吧",@"应用"];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:array];
    segmentControl.selectedSegmentIndex = 1;
    
    segmentControl.frame = CGRectMake(0, 64, 300, 30);
    
    [segmentControl addTarget:self action:@selector(chagnePage:) forControlEvents:UIControlEventValueChanged];
    
    segmentControl.tintColor = [UIColor orangeColor];
    [self.view addSubview:segmentControl];
    self.segmentControll = segmentControl;
    [segmentControl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.height.equalTo(30);
        make.top.equalTo(74);
        make.width.equalTo(250);
    }];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 124, SCREENWIDTH, SCREENHEIGHT- 124 - 49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentControll.selectedSegmentIndex == 0) {
        OneChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OneChatTableViewCell class]) owner:self options:nil] firstObject];
        }else{
            while ([cell.contentView.subviews lastObject]!=nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        cell.model = _oneArray[indexPath.row];
        return cell;
    }else if (self.segmentControll.selectedSegmentIndex == 1){

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
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentControll.selectedSegmentIndex == 0) {
        BaiDuTieBaViewController * baidu = [[BaiDuTieBaViewController alloc]init];
        OneChatModel * model = _oneArray[indexPath.row];
        baidu.name = model.name;
        self.tabBarController.tabBar.hidden = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baidu animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (self.segmentControll.selectedSegmentIndex == 1){
    HeaderImageDetailViewController * detail = [[HeaderImageDetailViewController alloc]init];
    SelectedImageModel * model = _dataArray[indexPath.row];
    detail.url = model.detailUrl;
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)chagnePage:(UISegmentedControl *)control{
    if (control.selectedSegmentIndex == 0) {
        [self.tableView reloadData];
    }else if (control.selectedSegmentIndex == 1){
        [self.tableView reloadData];
    }
}
- (void)requestData{
    [_dataArray removeAllObjects];
    [_oneArray removeAllObjects];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [manager GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        NSMutableArray * arr1 = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"Result"][@"items"]) {
            SelectedImageModel * model = [[SelectedImageModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            OneChatModel * chat = [[OneChatModel alloc]init];
            [chat setValuesForKeysWithDictionary:dic];
            [arr1 addObject:chat];
            [arr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataArray = [arr mutableCopy];
            _oneArray = [arr1 mutableCopy];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)loadMore{
    _page ++;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [manager GET:[NSString stringWithFormat:@"http://applebbx.sj.91.com/api/?keyword=%@&pi=%d&spid=2&osv=10.0.1&cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&dm=iPhone8,1&sv=3.1.3&act=203&nt=10&pid=2&mt=1",_str,_page] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        NSMutableArray * arr1 = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"Result"][@"items"]) {
            SelectedImageModel * model = [[SelectedImageModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            OneChatModel * chat = [[OneChatModel alloc]init];
            [chat setValuesForKeysWithDictionary:dic];
            [arr1 addObject:chat];
            [arr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_dataArray addObjectsFromArray:arr];
            [_oneArray addObjectsFromArray:arr1];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
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
