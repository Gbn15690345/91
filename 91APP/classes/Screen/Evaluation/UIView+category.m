//
//  UIView+category.m
//  百思不得姐
//
//  Created by  wyzc02 on 16/11/22.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "UIView+category.h"

@implementation UIView (category)
+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)setWYx:(CGFloat)WYx{
    CGRect frame = self.frame;
    frame.origin.x = WYx;
    self.frame = frame;
}
- (CGFloat)WYx{
    return self.frame.origin.x;
}
- (void)setWYy:(CGFloat)WYy{
    CGRect frame = self.frame;
    frame.origin.y = WYy;
    self.frame = frame;
}
- (CGFloat)WYy{
    return self.frame.origin.y;
}
- (void)setWYwidth:(CGFloat)WYwidth{
    CGRect frame = self.frame;
    frame.size.width = WYwidth;
    self.frame = frame;
}
- (CGFloat)WYwidth{
    return self.frame.size.width;
}
- (void)setWYheight:(CGFloat)WYheight{
    CGRect frame = self.frame;
    frame.size.height = WYheight;
    self.frame = frame;
}
- (CGFloat)WYheight{
    return self.frame.size.height;
}
- (void)setWYcenterX:(CGFloat)WYcenterX{
    CGPoint center = self.center;
    center.x = WYcenterX;
    self.center = center;
}
- (CGFloat)WYcenterX{
    return self.center.x;
}
- (void)setWYcenterY:(CGFloat)WYcenterY{
    CGPoint center = self.center;
    center.y = WYcenterY;
    self.center = center;
}
- (CGFloat)WYcenterY{
    return self.center.y;
}
@end
