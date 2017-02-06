//
//  FourTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 16/12/24.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "FourTableViewCell.h"
@interface FourTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *label5;
@property (strong, nonatomic) IBOutlet UILabel *label6;

@end
@implementation FourTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(SelectedImageDetailModel *)model{
    _model = model;
    self.label1.text = [NSString stringWithFormat:@"下载:%@次下载",model.downTimes];
    self.label2.text = [NSString stringWithFormat:@"分类:%@",model.cateName];
    self.label3.text = [NSString stringWithFormat:@"时间:%@",model.updateTime];
    self.label4.text = [NSString stringWithFormat:@"语言:%@",model.lan];
    self.label5.text = [NSString stringWithFormat:@"作者:%@",model.author];
    self.label6.text = [NSString stringWithFormat:@"兼容性:%@",model.requirement];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
