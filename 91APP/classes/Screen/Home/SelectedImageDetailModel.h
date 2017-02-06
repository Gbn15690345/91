//
//  SelectedImageDetailModel.h
//  91APP
//
//  Created by  wyzc02 on 16/12/22.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedImageDetailModel : NSObject
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * icon;
@property (nonatomic,copy)NSString * versionCode;
@property (nonatomic,copy)NSString * author;
@property (nonatomic,copy)NSString * price;
@property (nonatomic,assign)NSUInteger star;
@property (nonatomic,copy)NSString * requirement;
@property (nonatomic,copy)NSString * lan;
@property (nonatomic,copy)NSString * desc;
@property (nonatomic,assign)NSUInteger size;
@property (nonatomic,copy)NSString * downAct;
@property (nonatomic,copy)NSString * downTimes;
@property (nonatomic,copy)NSString * updateTime;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,copy)NSArray * recommendSofts;
@property (nonatomic,copy)NSString * cateName;
@end
