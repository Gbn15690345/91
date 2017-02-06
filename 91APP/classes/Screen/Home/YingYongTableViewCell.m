//
//  YingYongTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 16/12/28.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "YingYongTableViewCell.h"
@interface YingYongTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *bigLabel;
@property (strong, nonatomic) IBOutlet UILabel *smallLabel;

@end
@implementation YingYongTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(YingYongModel *)model{
    _model = model;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.bigLabel.text = model.name;
    self.smallLabel.text = model.summary;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
