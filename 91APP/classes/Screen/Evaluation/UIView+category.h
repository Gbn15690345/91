//
//  UIView+category.h
//  百思不得姐
//
//  Created by  wyzc02 on 16/11/22.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (category)
@property (nonatomic, assign) CGFloat WYx;
@property (nonatomic, assign) CGFloat WYy;
@property (nonatomic, assign) CGFloat WYwidth;
@property (nonatomic, assign) CGFloat WYheight;
@property (nonatomic, assign) CGFloat WYcenterX;
@property (nonatomic, assign) CGFloat WYcenterY;

/** 从xib中创建一个控件 */
+ (instancetype)viewFromXib;
@end
