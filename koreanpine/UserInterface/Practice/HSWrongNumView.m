//
//  HSWrongNumView.m
//  koreanpine
//
//  Created by 陶山强 on 15/11/9.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSWrongNumView.h"

@implementation HSWrongNumView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef contextLast = UIGraphicsGetCurrentContext();
    [RGBACOLOR(85, 125, 201, 1) setStroke];
    CGContextAddArc(contextLast, CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5-0.5, 0, 2 * M_PI, 0);
    CGContextStrokePath(contextLast);
    
    
    
}

@end
