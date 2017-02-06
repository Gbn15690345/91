//
//  FenLeiTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 16/12/28.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "FenLeiTableViewCell.h"
@interface FenLeiTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;

@end
@implementation FenLeiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = 10;
    self.image.layer.masksToBounds = YES;
    // Initialization code
}
- (void)setModel:(FenLeiModel *)model{
    _model = model;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.label1.text = model.name;
    self.label2.text = model.summary;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
