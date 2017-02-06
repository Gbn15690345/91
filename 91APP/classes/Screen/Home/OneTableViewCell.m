//
//  OneTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 16/12/22.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "OneTableViewCell.h"
@interface OneTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *bigImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;
@property (strong, nonatomic) IBOutlet UIImageView *image5;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UIButton *bigButton;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (nonatomic,strong)NSString * url;
@end
@implementation OneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bigButton.layer.borderWidth = 0.5;
    self.bigButton.layer.cornerRadius = 3;
    self.bigButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.bigImage.layer.cornerRadius = 10;
    self.bigImage.layer.masksToBounds = YES;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.nameLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(30.0)];
    // Initialization code
}
- (void)setModel:(SelectedImageDetailModel *)model{
    _model = model;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    _nameLabel.text = model.name;
    if (model.star == 5) {
        self.image1.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image2.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image3.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image4.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image5.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
    }else if (model.star == 4){
        self.image1.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image2.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image3.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image4.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image5.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
    }else if (model.star == 3){
        self.image1.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image2.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image3.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image4.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image5.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
    }else if (model.star == 2){
        self.image1.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image2.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image3.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image4.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image5.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
    }else if (model.star == 1){
        self.image1.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_s"];
        self.image2.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image3.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image4.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image5.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
    }else if (model.star == 0){
        self.image1.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image2.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image3.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image4.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
        self.image5.image = [UIImage imageNamed:@"btn_star_collect_pb_floor_n"];
    }
    self.sizeLabel.text = [NSString stringWithFormat:@"大小:%.2fMB",(float)model.size/1024/1024];
    self.versionLabel.text = [NSString stringWithFormat:@"版本:%@",model.versionCode];
    [self.bigButton setTitle:[NSString stringWithFormat:@"打开%@吧",model.name] forState:UIControlStateNormal];
    if ([model.price isEqualToString:@"0.00"]) {
        [self.button setTitle:@"免费" forState:UIControlStateNormal];
    }else{
        [self.button setTitle:model.price forState:UIControlStateNormal];
    }
}
- (IBAction)downapp:(id)sender {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:self.model.downAct parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.url = responseObject[@"Result"][@"appleDetailUrl"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
- (IBAction)baidu:(id)sender {
    NSDictionary * dic = @{@"name":self.nameLabel.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"baidu" object:nil userInfo:dic];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
