//
//  HeaderImageDetailViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/22.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "HeaderImageDetailViewController.h"
#import "SelectedImageDetailModel.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
#import "OneTableViewCell.h"
#import "TwoTableViewCell.h"
#import "ThreeTableViewCell.h"
#import "FourTableViewCell.h"
#import "BaiDuTieBaViewController.h"
@interface HeaderImageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
//数据数组
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)UITableView * tableView;
//图片地址数组
@property (nonatomic,strong)NSArray * imageArray;
@property (nonatomic,strong)UIScrollView * imageScroll;
@property (nonatomic,strong)SelectedImageDetailModel * model;
@end

@implementation HeaderImageDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
    self.navigationController.navigationBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSArray array];
    _imageArray = [NSArray array];
    self.model = [[SelectedImageDetailModel alloc]init];
    self.model.cellHeight = 130;
    [self setscroll];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"OneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"ThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"FourTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    [self.view addSubview:_tableView];
    [self setButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeCellheight) name:@"become" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Url:) name:@"url" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baidu:) name:@"baidu" object:nil];
    [self requestData];
    UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightG)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    // Do any additional setup after loading the view.
}
- (void)rightG{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)baidu:(NSNotification *)sender{
    BaiDuTieBaViewController * baidu = [[BaiDuTieBaViewController alloc]init];
    baidu.name = sender.userInfo[@"name"];
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baidu animated:YES];
}
- (void)Url:(NSNotification *)sender{
    HeaderImageDetailViewController * header = [[HeaderImageDetailViewController alloc]init];
    header.url = sender.userInfo[@"url"];
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:header animated:YES];
}
- (void)becomeCellheight{
    [self.tableView reloadData];
}
- (void)setButton{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"detail_back_normal"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"detail_back_press"] forState:UIControlStateHighlighted];
    leftButton.frame = CGRectMake(10, 27, 40, 40);
    [leftButton addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"detail_share_normal"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"detail_share_press"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(SCREENWIDTH-50, 27, 40, 40);
    [self.view addSubview:rightButton];
}
- (void)left{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)right{
    //分享
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"亲,内容已复制到粘贴板,你可以随意分享到QQ,微信,微博...(打开对应的App输入框长按即可粘贴)" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        //复制
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"我在91助手上发现了一款软件[%@],感觉很不错,快下载一个试试吧.%@",_model.name,self.url];
    }];
}
- (void)bigImage{
    int i = _imageScroll.contentOffset.x/SCREENWIDTH;
    UIImageView * image = [[UIImageView alloc]init];
    [image sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]]];
    
    [SJAvatarBrowser showImage:image];
}
- (void)setscroll{
    _imageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 275)];
    _imageScroll.contentSize = CGSizeMake(SCREENWIDTH * _imageArray.count, 275);
    _imageScroll.bounces = NO;
    _imageScroll.showsHorizontalScrollIndicator = NO;
    _imageScroll.pagingEnabled = YES;
    for (int i = 0; i < _imageArray.count; i ++) {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, 275)];
        [image sd_setImageWithURL:_imageArray[i]];
        image.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImage)];
        [image addGestureRecognizer:singleTap];
        [_imageScroll addSubview:image];
        UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH * i, 225, SCREENWIDTH, 50)];
        image1.backgroundColor = [UIColor colorWithRed:41/255.0 green:36/255.0 blue:33/255.0 alpha:0.5];
        [_imageScroll addSubview:image1];
    }
    self.tableView.tableHeaderView = _imageScroll;
    [self.tableView insertSubview:_imageScroll atIndex:0];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }else if (indexPath.row == 1){
        return self.model.cellHeight;
    }else if (indexPath.row == 2){
        return 120;
    }else if (indexPath.row == 3){
        return 200;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    OneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.model = _model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        TwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model;
        return cell;
    }else if (indexPath.row == 2){
        ThreeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model;
        return cell;
    }else if (indexPath.row == 3){
        FourTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model;
        return cell;
    }
    return 0;
}
- (void)requestData{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray * arr = [NSMutableArray array];
        [_model setValuesForKeysWithDictionary:responseObject[@"Result"]];
        [arr addObject:_model];
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageArray = responseObject[@"Result"][@"snapshots"];
            _dataArray = [arr mutableCopy];
            [_imageScroll removeFromSuperview];
            [self setscroll];
            [self.tableView reloadData];
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
