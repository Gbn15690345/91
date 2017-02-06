//
//  TwoTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 16/12/24.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "TwoTableViewCell.h"
@interface TwoTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end
@implementation TwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(SelectedImageDetailModel *)model{
    _model = model;
    self.label.text = model.desc;
}
- (IBAction)toBig:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"become" object:nil];
    if (_model.cellHeight == 130) {
        [self.button setTitle:@"收缩" forState:UIControlStateNormal];
        CGFloat textW = SCREENWIDTH - 20;
        CGFloat textH = [_model.desc boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        _model.cellHeight = textH + 74;
    }else{
        [self.button setTitle:@"展开" forState:UIControlStateNormal];
        _model.cellHeight = 130;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
