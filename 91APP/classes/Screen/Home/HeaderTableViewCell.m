//
//  HeaderTableViewCell.m
//  91APP
//
//  Created by  wyzc02 on 16/12/21.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "HeaderTableViewCell.h"
@interface HeaderTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *bigImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *downLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;
@property (strong, nonatomic) IBOutlet UIImageView *image5;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UIView *lineView;
//app下载地址
@property (nonatomic,strong)NSString * url;
@end
@implementation HeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(SelectedImageModel *)model{
    _model = model;
    self.bigImage.layer.cornerRadius = 10;
    self.bigImage.layer.masksToBounds = YES;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.nameLabel.text = model.name;
    self.downLabel.text = [NSString stringWithFormat:@"%@次下载",model.downTimes];
    self.sizeLabel.text = [NSString stringWithFormat:@"%.2fMB",(float)model.size/1024/1024];
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
    if ([model.price isEqualToString:@"0.00"] && [model.originalPrice isEqualToString:@"0.00"]) {
        self.rightView.hidden = YES;
    }else if ([model.originalPrice isEqualToString:@"0.00"] && ![model.price isEqualToString:@"0.00"]){
        self.button.hidden = YES;
        self.originalPriceLabel.hidden = YES;
        self.lineView.hidden = YES;
        self.priceLabel.text = model.price;
    }else if ([model.price isEqualToString:@"0.00"] && ![model.originalPrice isEqualToString:@"0.00"]){
        self.priceLabel.hidden = YES;
        self.originalPriceLabel.text = model.originalPrice;
    }else{
        self.button.hidden = YES;
        self.originalPriceLabel.text = model.originalPrice;
        self.priceLabel.text = model.price;
    }
    
}
- (IBAction)down:(id)sender {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
