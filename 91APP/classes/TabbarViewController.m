//
//  TabbarViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/20.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "TabbarViewController.h"
#import "ChatViewController.h"
#import "EvaluationViewController.h"
#import "HomeViewController.h"
#import "SeachViewController.h"
#import "MyNavViewController.h"
@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self child];
    // Do any additional setup after loading the view.
}
- (void)child{
    HomeViewController * home = [[HomeViewController alloc]init];
    [self addchildVC:home image:[UIImage imageNamed:@"homepage_home"] selectImage:[UIImage imageNamed:@"homepage_home_sel"] title:@"首页"];
    ChatViewController * chat = [[ChatViewController alloc]init];
    [self addchildVC:chat image:[UIImage imageNamed:@"homepage_talk"] selectImage:[UIImage imageNamed:@"homepage_talk_sel"] title:@"聊吧"];
    EvaluationViewController * evaluation = [[EvaluationViewController alloc]init];
    [self addchildVC:evaluation image:[UIImage imageNamed:@"homepage_cate"] selectImage:[UIImage imageNamed:@"homepage_cate_sel"] title:@"分类"];
    SeachViewController * search = [[SeachViewController alloc]init];
    [self addchildVC:search image:[UIImage imageNamed:@"homepage_seach"] selectImage:[UIImage imageNamed:@"homepage_seach_sel"] title:@"搜索"];
    self.tabBar.tintColor = [UIColor orangeColor];
    
}
- (void)addchildVC:(UIViewController *)childVC image:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barStyle = UIBarStyleBlackOpaque;
    MyNavViewController * nav = [[MyNavViewController alloc]initWithRootViewController:childVC];
    childVC.title = title;
    nav.tabBarItem.image = image;
    nav.tabBarItem.selectedImage = selectImage;
    nav.tabBarItem.title = title;
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    [self addChildViewController:nav];
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
