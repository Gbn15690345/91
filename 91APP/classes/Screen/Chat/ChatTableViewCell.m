//
//  ChatTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 16/12/26.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "ChatTableViewCell.h"
@interface ChatTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ChatModel *)model{
    _model = model;
    [_image sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    _label.text = model.name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
