//
//  HSPracticeButton.m
//  koreanpine
//
//  Created by Victor on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPracticeButton.h"

@implementation HSPracticeButton

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGRect frame = self.frame;
    CGContextRef contextLast = UIGraphicsGetCurrentContext();
    [RGBACOLOR(195, 211, 238, 1) setStroke];
    CGContextAddArc(contextLast, CGRectGetHeight(frame)*0.5, CGRectGetHeight(frame)*0.5, CGRectGetHeight(self.frame)*0.5 - 0.5, M_PI_2, 3 * M_PI_2, 0);
    
    CGContextStrokePath(contextLast);
     [RGBACOLOR(127, 163, 222, 1) setFill];
    CGContextAddArc(contextLast, CGRectGetHeight(frame)*0.5, CGRectGetHeight(frame)*0.5, CGRectGetHeight(self.frame)*0.5 - 1, M_PI_2, 3 * M_PI_2, 0);
    
    CGContextFillPath(contextLast);

    CGContextRef context = UIGraphicsGetCurrentContext();
   
    //指定直线样式
    
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,2);
    //设置颜色
    CGContextSetRGBStrokeColor(context,0.762, 0.824, 0.929, 1.0);
    
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,CGRectGetHeight(frame)*0.5, 0);
    //下一点
    CGContextAddLineToPoint(context,CGRectGetWidth(frame), 0);
    //下一点
    CGContextAddLineToPoint(context,CGRectGetWidth(frame), CGRectGetHeight(frame));
    //下一点
    CGContextAddLineToPoint(context,CGRectGetHeight(frame)*0.5, CGRectGetHeight(frame));

        CGContextStrokePath(context);
    
    
     CGContextBeginPath(context);
    [RGBACOLOR(127, 163, 222, 1) setFill];
    CGContextBeginPath(context);
       //绘制完成
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,CGRectGetHeight(frame)*0.5, 1);
    //下一点
    CGContextAddLineToPoint(context,CGRectGetWidth(frame)-1, 1);
    //下一点
    CGContextAddLineToPoint(context,CGRectGetWidth(frame)-1, CGRectGetHeight(frame)-1);
    //下一点
    CGContextAddLineToPoint(context,CGRectGetHeight(frame)*0.5, CGRectGetHeight(frame)-1);

    CGContextFillPath(context);



}


@end
