//
//  EvaluationDetailViewController.m
//  91APP
//
//  Created by  wyzc02 on 16/12/28.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "EvaluationDetailViewController.h"
#import "UIView+category.h"
#import "MianFeiViewController.h"
#import "XianShiViewController.h"
#import "JiangJiaViewController.h"
#import "ShouFeiViewController.h"
@interface EvaluationDetailViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
//上面所有按钮的父视图
@property (nonatomic, strong) UIView *titlesView;

/** 标题栏底部的指示器 */ //小红条
@property (nonatomic, strong) UIView *titleBottomView;

/** 存放所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;

/** 当前被选中的按钮 */
@property (nonatomic, strong) UIButton *selectedTitleButton;
@property (nonatomic,strong)UIScrollView * scrollView;

@end

@implementation EvaluationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleButtons = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(right)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    right.delegate =self;
    [self.view addGestureRecognizer:right];
    self.title = self.name;
    [self setupChildVcs];
    [self setupTitleView];
    [self setScroll];
    
    // Do any additional setup after loading the view.
}
- (void)right{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (_scrollView.contentOffset.x == 0) {
        return YES;
    }
    return NO;
}

- (void)setupTitleView{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 35)];
    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    // 标签栏内部的标签按钮
    NSUInteger count = self.dataArray.count;
    CGFloat titleButtonH = titlesView.WYheight;
    CGFloat titleButtonW = titlesView.WYwidth / count;
    for (int i = 0; i < count; i++) {
        // 创建
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:17];
        
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titlesView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        
        // 文字
        NSString *title = self.dataArray[i][@"tagName"];
        [titleButton setTitle:title forState:UIControlStateNormal];
        
        // frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
    }
    
    // 标签栏底部的指示器控件
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [UIColor orangeColor];
    titleBottomView.WYheight = 2;
    titleBottomView.WYy = titlesView.WYheight - titleBottomView.WYheight;
    [titlesView addSubview:titleBottomView];
    self.titleBottomView = titleBottomView;
    
    // 默认点击最前面的按钮
    UIButton *firstTitleButton = self.titleButtons.firstObject;
    [firstTitleButton.titleLabel sizeToFit];
    titleBottomView.WYwidth = firstTitleButton.titleLabel.WYwidth;
    titleBottomView.WYcenterX = firstTitleButton.WYcenterX;
    [self titleClick:firstTitleButton];
}
#pragma mark - 监听
- (void)titleClick:(UIButton *)titleButton
{
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    // 底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.WYwidth = titleButton.titleLabel.WYwidth;
        self.titleBottomView.WYcenterX = titleButton.WYcenterX;
    }];
    
    // 让scrollView滚动到对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = SCREENWIDTH * [self.titleButtons indexOfObject:titleButton];
    [self.scrollView setContentOffset:offset animated:YES];
}
- (void)setScroll{
    
    // 不要自动调整scrollView的contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 99, SCREENWIDTH, SCREENHEIGHT-99-49);
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    _scrollView.contentSize = CGSizeMake(self.dataArray.count*self.view.WYwidth, 0);
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    // 默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:_scrollView];
}
- (void)setupChildVcs
{
    MianFeiViewController *mianfei = [[MianFeiViewController alloc] init];
    mianfei.title = @"免费应用";
    mianfei.url = _dataArray[0][@"url"];
    [self addChildViewController:mianfei];
    
    XianShiViewController *xianshi = [[XianShiViewController alloc] init];
    xianshi.title = @"限时免费";
    xianshi.url1 = _dataArray[1][@"url"];
    [self addChildViewController:xianshi];
    
    JiangJiaViewController *jiangjia = [[JiangJiaViewController alloc] init];
    jiangjia.title = @"降价应用";
    jiangjia.url2 = _dataArray[2][@"url"];
    [self addChildViewController:jiangjia];
    
    ShouFeiViewController *shoufei = [[ShouFeiViewController alloc] init];
    shoufei.title = @"收费应用";
    shoufei.url3 = _dataArray[3][@"url"];
    [self addChildViewController:shoufei];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 取出对应的子控制器
    int index = scrollView.contentOffset.x / scrollView.WYwidth;//width是写了一个view 的类目 与 masonry 冲突  可以把自己写的类目的属性名 与 masonry 命名区分开
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    // 如果控制器的view已经被创建过，就直接返回
    if (willShowChildVc.isViewLoaded) return;
    
    // 添加子控制器的view到scrollView身上
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}

/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    int index = scrollView.contentOffset.x / scrollView.WYwidth;
    [self titleClick:self.titleButtons[index]];
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
