//
//  YH_PageControl.m
//  YH_Mall
//
//  Created by 葛祥通 on 14-9-25.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import "HSPageControl.h"
#define viewHeight  6

@implementation HSPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if ([self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)] && [self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
            [self setCurrentPageIndicatorTintColor:[UIColor clearColor]];
            [self setPageIndicatorTintColor:[UIColor clearColor]];
        }
        
        self.backgroundColor = [UIColor clearColor];
        if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0){
            for (UIView *su in self.subviews){
                [su removeFromSuperview];
            }
        }
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
    [self setNeedsDisplay];
}

-(void)setCurrentPage:(NSInteger)currentPage{
    
    [super setCurrentPage:currentPage];
    [self setNeedsDisplay];
}

//原来UIPagecontrol的subviews是UIImageview ios7 改为了UIView， 只需重画
-(void)drawRect:(CGRect)iRect
{
    CGFloat _kSpacing = 2.0;
    NSInteger i;
    CGRect rect;
    
    UIImage *image;
    iRect = self.bounds;
    
    if ( self.opaque ) {
        [self.backgroundColor set];
        UIRectFill( iRect );
    }
    if ( self.hidesForSinglePage && self.numberOfPages == 1 ) return;
    
    rect.size.height = viewHeight;
    rect.size.width = self.numberOfPages * viewHeight + ( self.numberOfPages - 1 ) * _kSpacing;
    rect.origin.x = floorf( ( iRect.size.width - rect.size.width ) / 2.0 );
    rect.origin.y = floorf( ( iRect.size.height - rect.size.height ) / 2.0 );
    rect.size.width = viewHeight;
    
    for ( i = 0; i < self.numberOfPages; ++i ){
        image = i == self.currentPage ? self.imageNormal : self.imageSelected;
        [image drawInRect: rect];
        rect.origin.x += viewHeight + _kSpacing;
    }
}

@end
