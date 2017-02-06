//
//  HomeViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/20.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "ScrollImageModel.h"
#import "HeaderImageViewController.h"
#import "HeaderWebViewController.h"
#import "SectionModel.h"
#import "OneModel.h"
#import "SelectedImageModel.h"
#import "TopTableViewCell.h"
#import "HeaderTableViewCell.h"
#import "HeaderImageDetailViewController.h"
#import "YingYongViewController.h"
@interface HomeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)SDCycleScrollView * sdcycle;
@property (nonatomic,strong)UITableView * tableView;
//轮播图数据数组
@property (nonatomic,strong)NSArray * imageArray;
//区头数据
@property (nonatomic,strong)NSArray * secionArray;
//一区
@property (nonatomic,strong)NSArray * oneArray;
//二区
@property (nonatomic,strong)NSArray * twoArray;
//三区
@property (nonatomic,strong)NSArray * threeArray;
//四区
@property (nonatomic,strong)NSArray * fourArray;
//五区
@property (nonatomic,strong)NSArray * fiveArray;
//六区
@property (nonatomic,strong)NSArray * sexArray;
//七区
@property (nonatomic,strong)NSArray * sevenArray;
@end
@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArray = [NSArray array];
    _secionArray = [NSArray array];
    _oneArray = [NSArray array];
    _twoArray = [NSArray array];
    _threeArray = [NSArray array];
    _fourArray = [NSArray array];
    _fiveArray = [NSArray array];
    _sexArray = [NSArray array];
    _sevenArray = [NSArray array];
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.title = @"91助手";
    
    _sdcycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 57, SCREENWIDTH, 150) imageURLStringsGroup:nil];
    
    _sdcycle.pageDotColor = [UIColor orangeColor];
    _sdcycle.delegate = self;
    

    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 40;
    _tableView.tableHeaderView = _sdcycle;
    [self.view addSubview:_tableView];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestScrollImage];
        [self requestSection];
        [self requestRow];
    }];
    [_tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(first:) name:@"url" object:nil];
    // Do any additional setup after loading the view.
}
- (void)first:(NSNotification *)sender{
    HeaderImageDetailViewController * header = [[HeaderImageDetailViewController alloc]init];
    header.url = sender.userInfo[@"url"];
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:header animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _secionArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionModel * model = _secionArray[section];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
    label.text = model.name;
    [view addSubview:label];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"更多>" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(SCREENWIDTH-60, 15, 50, 20);
    [button addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 600 + section;
    [view addSubview:button];
    return view;
}
- (void)more:(UIButton *)sender{
    HeaderImageViewController * header = [[HeaderImageViewController alloc]init];
    YingYongViewController * yingyong = [[YingYongViewController alloc]init];
    SectionModel * model = _secionArray[sender.tag-600];
    if (sender.tag == 604) {
        yingyong.name = model.name;
        yingyong.url = @"http://applebbx.sj.91.com/soft/phone/tag.aspx?cuid=1a820c0140c54e360821b62bfa489aced1443d5a&act=212&imei=3B789F3A-937B-458E-947A-6C276B18A396&spid=2&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&nt=10&mt=1&pid=2";
        [self.navigationController pushViewController:yingyong animated:YES];
    }else{
        header.name = model.name;
        if (sender.tag == 600) {
            header.url = @"http://applebbx.sj.91.com/api/?act=708&pi=1&cuid=1a820c0140c54e360821b62bfa489aced1443d5a&spid=2&imei=3B789F3A-937B-458E-947A-6C276B18A396&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&nt=10&mt=1&pid=2";
        }else if (sender.tag == 601){
            header.url = @"http://applebbx.sj.91.com/soft/phone/list.aspx?cuid=1a820c0140c54e360821b62bfa489aced1443d5a&act=244&imei=3B789F3A-937B-458E-947A-6C276B18A396&spid=2&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&top=20&mt=1&nt=10&pid=2";
        }else if (sender.tag == 602){
            header.url = @"http://applebbx.sj.91.com/api/?act=246&pi=1&cuid=1a820c0140c54e360821b62bfa489aced1443d5a&spid=2&imei=3B789F3A-937B-458E-947A-6C276B18A396&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&nt=10&mt=1&pid=2";
        }else if (sender.tag == 603){
            header.url = @"http://applebbx.sj.91.com/api/?act=236&pi=1&cuid=1a820c0140c54e360821b62bfa489aced1443d5a&spid=2&imei=3B789F3A-937B-458E-947A-6C276B18A396&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&nt=10&mt=1&pid=2";
        }else if (sender.tag == 605){
            header.url = @"http://applebbx.sj.91.com/soft/phone/list.aspx?cuid=1a820c0140c54e360821b62bfa489aced1443d5a&act=245&pi=1&imei=3B789F3A-937B-458E-947A-6C276B18A396&spid=2&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&nt=10&mt=1&pid=2";
        }else if (sender.tag == 606){
            header.url = @"http://applebbx.sj.91.com/soft/phone/list.aspx?skip=10&pi=1&osv=10.0.1&spid=2&cuid=1a820c0140c54e360821b62bfa489aced1443d5a&imei=3B789F3A-937B-458E-947A-6C276B18A396&dm=iPhone8,1&sv=3.1.3&act=244&nt=10&pid=2&mt=1";
        }
        [self.navigationController pushViewController:header animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2 || section == 3) {
        return 1;
    }else if (section == 1){
        return _twoArray.count;
    }else if (section == 5){
        return _sexArray.count;
    }else if (section == 6){
        return _sevenArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 3) {
        return 120;
    }else if (indexPath.section == 1 || indexPath.section == 5 || indexPath.section == 6){
        return 80;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 3) {
        TopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TopTableViewCell class]) owner:self options:nil] firstObject];
        }else{
            while ([cell.contentView.subviews lastObject]!=nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        if (indexPath.section == 0) {
            OneModel * model = [_oneArray lastObject];
            cell.model = model;
        }else if (indexPath.section == 2){
            OneModel * model = [_threeArray lastObject];
            cell.model = model;
        }else if (indexPath.section == 3){
            OneModel * model = [_fourArray lastObject];
            cell.model = model;
        }
    return cell;
    }else if (indexPath.section == 1 || indexPath.section == 5 || indexPath.section == 6){
        HeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HeaderTableViewCell class]) owner:self options:nil] firstObject];
        }else{
            while ([cell.contentView.subviews lastObject]!=nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        if (indexPath.section == 1) {
            SelectedImageModel * model = _twoArray[indexPath.row];
            cell.model = model;
        }else if (indexPath.section == 5){
            SelectedImageModel * model = _sexArray[indexPath.row];
            cell.model = model;
        }else if (indexPath.section == 6){
            SelectedImageModel * model = _sevenArray[indexPath.row];
            cell.model = model;
        }
        return cell;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HeaderImageDetailViewController * header = [[HeaderImageDetailViewController alloc]init];
    if (indexPath.section == 1) {
        SelectedImageModel * model = _twoArray[indexPath.row];
        header.url = model.detailUrl;
    }else if (indexPath.section == 5){
        SelectedImageModel * model = _sexArray[indexPath.row];
        header.url = model.detailUrl;
    }else if (indexPath.section == 6){
        SelectedImageModel * model = _sevenArray[indexPath.row];
        header.url = model.detailUrl;
    }
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:header animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//点击图片调用
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
        HeaderImageViewController * header = [[HeaderImageViewController alloc]init];
        ScrollImageModel * model = _imageArray[index];
        header.url = model.TargetUrl;
        header.name = model.Desc;
        [self.navigationController pushViewController:header animated:YES];
}
- (void)requestScrollImage{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://applebbx.sj.91.com/softs.ashx?spid=2&osv=10.0.1&cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&adlt=1&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&dm=iPhone8,1&sv=3.1.3&act=222&places=1&nt=10&pid=2&mt=1" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        NSMutableArray * url = [NSMutableArray array];
        
        for (NSDictionary * dic in responseObject[@"Result"][0][@"Value"]) {
            ScrollImageModel * model = [[ScrollImageModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [muarr addObject:model];
            [url addObject:dic[@"LogoUrl"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _sdcycle.imageURLStringsGroup = [url mutableCopy];
            _imageArray = [muarr mutableCopy];
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (void)requestSection{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://applebbx.sj.91.com/api/?cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&act=1&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&spid=2&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&nt=10&mt=1&pid=2" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in [responseObject[@"Result"] firstObject][@"parts"]) {
            SectionModel * model = [[SectionModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [muarr addObject:model];
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            _secionArray = [muarr mutableCopy];
            //[self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    }
- (void)requestRow{
    //热门
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://applebbx.sj.91.com/api/?cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&act=708&spid=2&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&nt=10&mt=1&pid=2" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        OneModel * model = [[OneModel alloc]init];
        NSDictionary * dic = responseObject[@"Result"];
        [model setValuesForKeysWithDictionary:dic];
        [muarr addObject:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            _oneArray = [muarr mutableCopy];
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //精品
    [manager GET:@"http://applebbx.sj.91.com/soft/phone/list.aspx?cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&act=244&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&spid=2&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&top=20&mt=1&nt=10&pid=2" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"Result"][@"items"]) {
            SelectedImageModel * model = [[SelectedImageModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [muarr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _twoArray = [muarr mutableCopy];
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //限时免费
    [manager GET:@"http://applebbx.sj.91.com/api/?act=246&cuid=1a820c0140c54e360821b62bfa489aced1443d5a&spid=2&imei=3B789F3A-937B-458E-947A-6C276B18A396&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&top=15&mt=1&nt=10&pid=2" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        OneModel * model = [[OneModel alloc]init];
        NSDictionary * dic = responseObject[@"Result"];
        [model setValuesForKeysWithDictionary:dic];
        [muarr addObject:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            _threeArray = [muarr mutableCopy];
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    //装机必备
    [manager GET:@"http://applebbx.sj.91.com/api/?act=236&cuid=1a820c0140c54e360821b62bfa489aced1443d5a&spid=2&imei=3B789F3A-937B-458E-947A-6C276B18A396&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&top=15&mt=1&nt=10&pid=2" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        OneModel * model = [[OneModel alloc]init];
        NSDictionary * dic = responseObject[@"Result"];
        [model setValuesForKeysWithDictionary:dic];
        [muarr addObject:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            _fourArray = [muarr mutableCopy];
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //黑马
    [manager GET:@"http://applebbx.sj.91.com/soft/phone/list.aspx?cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&act=245&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&spid=2&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&top=10&mt=1&nt=10&pid=2" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"Result"][@"items"]) {
            SelectedImageModel * model = [[SelectedImageModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [muarr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _sexArray = [muarr mutableCopy];
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //编辑
    [manager GET:@"http://applebbx.sj.91.com/soft/phone/list.aspx?skip=10&mt=1&spid=2&osv=10.0.1&cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&dm=iPhone8,1&sv=3.1.3&act=244&nt=10&pid=2&top=10" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"Result"][@"items"]) {
            SelectedImageModel * model = [[SelectedImageModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [muarr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _sevenArray = [muarr mutableCopy];
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
