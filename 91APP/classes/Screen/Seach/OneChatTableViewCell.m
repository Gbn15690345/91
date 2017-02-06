//
//  OneChatTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 17/1/5.
//  Copyright © 2017年 高炳楠. All rights reserved.
//

#import "OneChatTableViewCell.h"
@interface OneChatTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@end
@implementation OneChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(OneChatModel *)model{
    _model = model;
    [self.picture sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.nameLabel.text = model.name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
