//
//  TopTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 16/12/25.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "TopTableViewCell.h"
@interface TopTableViewCell()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
@implementation TopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(OneModel *)model{
    _model = model;
    self.scrollView.contentSize = CGSizeMake(110*_model.items.count - 10, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < _model.items.count; i ++) {
        CGFloat buttonW = 80;
        CGFloat buttonH = 80;
        CGFloat buttonX = 10+(30 + buttonW) * i;
        UIImageView * image = [[UIImageView alloc]init];
        image.userInteractionEnabled = YES;
        image.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
        [image sd_setImageWithURL:[NSURL URLWithString:_model.items[i][@"icon"]]];
        image.layer.cornerRadius = 10;
        image.layer.masksToBounds = YES;
        [self.scrollView addSubview:image];
        UILabel * label = [[UILabel alloc]init];
        label.text = _model.items[i][@"name"];
        label.frame = CGRectMake(buttonX, 85, buttonW, 20);
        label.font = [UIFont systemFontOfSize:15];
        [self.scrollView addSubview:label];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
        [button addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
}
- (void)dianji:(UIButton *)button{
    int i = (button.frame.origin.x - 10)/110;
    NSDictionary * dic = @{@"url":_model.items[i][@"detailUrl"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"url" object:nil userInfo:dic];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
