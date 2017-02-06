//
//  BaiDuTieBaViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/25.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "BaiDuTieBaViewController.h"

@interface BaiDuTieBaViewController ()
@property (nonatomic,strong)UIWebView * webView;
@end

@implementation BaiDuTieBaViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * str = [self.name  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * url = [NSString stringWithFormat:@"https://tieba.baidu.com/f?kw=%@",str];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [self.view addSubview:_webView];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"web_refresh_nor"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"web_refresh_pre"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(SCREENWIDTH-50, SCREENHEIGHT-100, 40, 40);
    [self.view addSubview:button];
    UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightG)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    
    // Do any additional setup after loading the view.
}
- (void)rightG{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refresh{
    [self.webView reload];
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
