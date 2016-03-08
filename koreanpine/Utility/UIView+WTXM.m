//
//  UIView+WTXM.m
//  WTXMMicroblog
//
//  Created by 王涛 on 15/1/1.
//  Copyright (c) 2015年 王涛. All rights reserved.
//

#import "UIView+WTXM.h"

@implementation UIView (WTXM)
-(void)setX:(CGFloat)x {
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}
- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y {
    CGRect frame=self.frame;
    frame.origin.y=y;
    self.frame=frame;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setWid:(CGFloat)wid {
    CGRect frame=self.frame;
    frame.size.width=wid;
    self.frame=frame;
}
- (CGFloat)wid {
    return self.frame.size.width;
}
- (void)setHei:(CGFloat)hei {
    CGRect frame=self.frame;
    frame.size.height=hei;
    self.frame=frame;
}
- (CGFloat)hei {
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size {
    CGRect frame=self.frame;
    frame.size=size;
    self.frame=frame;
}
- (CGSize)size {
    return self.frame.size;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}
- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}
- (CGFloat)centerY {
    return self.center.y;
}

@end
