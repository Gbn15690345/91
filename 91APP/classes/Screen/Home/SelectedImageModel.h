//
//  SelectedImageModel.h
//  91APP
//
//  Created by  wyzc02 on 16/12/21.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedImageModel : NSObject
@property (nonatomic,assign)NSUInteger star;
@property (nonatomic,copy)NSString * resId;
@property (nonatomic,copy)NSString * detailUrl;
@property (nonatomic,copy)NSString * downAct;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * downTimes;
@property (nonatomic,copy)NSString * icon;
@property (nonatomic,assign)NSUInteger size;
@property (nonatomic,copy)NSString * originalPrice;
@property (nonatomic,copy)NSString * price;
@end
