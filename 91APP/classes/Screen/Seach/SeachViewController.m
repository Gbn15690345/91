//
//  SeachViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/20.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "SeachViewController.h"
#import "SearchCollectionViewCell.h"
#import "SegmentViewController.h"
@interface SeachViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UISearchController * searchController;
@property (nonatomic,strong)NSArray * biaoQianArr;
@property (nonatomic,strong)UICollectionView * collection;
@property (nonatomic, strong) NSMutableArray * dataArray; // 数据
@property (nonatomic, strong) NSMutableArray *searchResults; // 搜索的结果
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSString * text;
@property (nonatomic,strong)NSArray * requestArray;
@end

@implementation SeachViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _searchController.active = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _biaoQianArr = [NSArray array];
    _dataArray = [NSMutableArray array];
    _searchResults = [NSMutableArray array];
    _requestArray = [NSArray array];
    self.view.backgroundColor =[UIColor whiteColor];
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchBar.frame = CGRectMake(0, 0, 0, 40);
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    self.navigationItem.titleView = _searchController.searchBar;
    [self setupCollection];
        [self requestData];
    // Do any additional setup after loading the view.
}
- (void)setupCollection{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    UICollectionView * collection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    collection.delegate = self;
    collection.dataSource = self;
    [collection registerNib:[UINib nibWithNibName:@"SearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell8"];
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    collection.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    [self.view addSubview:collection];
    self.collection = collection;

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    SegmentViewController * segment = [[SegmentViewController alloc]init];
    segment.name = self.searchController.searchBar.text;
    [self.navigationController pushViewController:segment animated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (![self.searchController.searchBar.text isEqualToString:@""]) {

        [_collection removeFromSuperview];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"table"];
        [self.view addSubview:_tableView];
    self.text = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self searchRequset];
    }
    if (_searchController.searchBar.text.length == 0) {
        _searchController.active = NO;
    }
}
- (void)searchRequset{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://suggestion.sj.91.com/service.ashx?keyword=%@&spid=2&osv=10.0.1&size=30&cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&sv=3.1.3&dm=iPhone8,1&act=303&nt=10&pid=2&mt=1",self.text] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       dispatch_async(dispatch_get_main_queue(), ^{
           _requestArray = responseObject[@"words"];
           [self.tableView reloadData];
       });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.tableView removeFromSuperview];
    [self setupCollection];
    self.collection.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _requestArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"table" forIndexPath:indexPath];
    cell.textLabel.text = _requestArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SegmentViewController * segment = [[SegmentViewController alloc]init];
    segment.name = _requestArray[indexPath.row];
    [self.navigationController pushViewController:segment animated:YES];
}
//设置头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //根据kind类型 来区分header 和 footer
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel * label = [[UILabel alloc] init];
        label.text = @"热门搜索";
        label.frame = CGRectMake(10, 0, SCREENWIDTH, 50);
        [header addSubview:label];
        //header.backgroundColor = [UIColor greenColor];
        return header;
    }
    return 0;
}
//设置头尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(50, 50);
}
//设置cell尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 30);
}
//cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _biaoQianArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell8" forIndexPath:indexPath];
    cell.label.text = _biaoQianArr[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:240/255.0 alpha:1];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SegmentViewController * segment = [[SegmentViewController alloc]init];
    segment.name = _biaoQianArr[indexPath.row];
    [self.navigationController pushViewController:segment animated:YES];
}
- (void)requestData{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://applebbx.sj.91.com/softs.ashx?cuid=3cee9598ed1f2aa532ab993eabdb76282688ad4f&act=104&imei=BE15D665-6EAB-4E8E-BE16-3D8D79FBA0FB&spid=2&osv=10.0.1&dm=iPhone8,1&sv=3.1.3&nt=10&mt=1&pid=2" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _biaoQianArr = [responseObject[@"Result"] mutableCopy];
            [self.collection reloadData];
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
