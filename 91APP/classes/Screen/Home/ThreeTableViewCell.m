//
//  ThreeTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 16/12/24.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "ThreeTableViewCell.h"
@interface ThreeTableViewCell ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
@implementation ThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //NSLog(@"%lu",(unsigned long)_model.recommendSofts.count);
        // Initialization code
}
- (void)setModel:(SelectedImageDetailModel *)model{
    _model = model;
    self.scrollView.contentSize = CGSizeMake(90*_model.recommendSofts.count - 10, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < _model.recommendSofts.count; i ++) {
        CGFloat buttonW = 60;
        CGFloat buttonH = 60;
        CGFloat buttonX = 10+(30 + buttonW) * i;
        UIImageView * image = [[UIImageView alloc]init];
        image.userInteractionEnabled = YES;
        image.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
        [image sd_setImageWithURL:_model.recommendSofts[i][@"icon"]];
        image.layer.cornerRadius = 10;
        image.layer.masksToBounds = YES;
        [self.scrollView addSubview:image];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
        [button addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
}
- (void)dianji:(UIButton *)button{
    int i = (button.frame.origin.x - 10)/90;
    NSDictionary * dic = @{@"url":_model.recommendSofts[i][@"detailUrl"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"url" object:nil userInfo:dic];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
