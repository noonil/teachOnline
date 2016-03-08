//
//  YH_GuangLaudBtn.m
//  YH_Mall
//
//  Created by Christ on 15/4/1.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import "HSTabbarBtn.h"

@implementation HSTabbarBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.barImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
    [self.barImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    CGPoint imageCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self.barImage setCenter:imageCenter];
    [self addSubview:self.barImage];
    
    self.barTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds)/2+8, CGRectGetHeight(self.bounds))];
    [self.barTitleLabel setCenter:CGPointMake(CGRectGetWidth(self.bounds)*0.75+3, CGRectGetMidY(self.bounds)+2)];
    [self.barTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.barTitleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.barTitleLabel setAlpha:0.0f];
    [self.barTitleLabel setTextColor:RGBCOLOR(72, 102, 167)];
    [self.barTitleLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.barTitleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected];
    
    if (animated) {
        if (selected) {
            [self.barImage setHighlighted:selected];
            CGPoint imageCenter = CGPointMake(CGRectGetMidX(self.bounds)-15, CGRectGetMidY(self.bounds));
            [UIView animateWithDuration:0.25 animations:^{
                [self.barTitleLabel setAlpha:1.0f];
                [self.barImage setCenter:imageCenter];
                
            }];
        }
        else{
            [self.barImage setHighlighted:selected];
            CGPoint imageCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            [UIView animateWithDuration:0.25 animations:^{
                [self.barTitleLabel setAlpha:0.0f];
                [self.barImage setCenter:imageCenter];
            }];
        }
    }
    else{
        if (selected) {
            [self.barImage setHighlighted:selected];
            CGPoint imageCenter = CGPointMake(CGRectGetMidX(self.bounds)-15, CGRectGetMidY(self.bounds));
            [self.barTitleLabel setAlpha:1.0f];
            [self.barImage setCenter:imageCenter];
        }
        else{
            [self.barImage setHighlighted:selected];
            CGPoint imageCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            [self.barTitleLabel setAlpha:0.0f];
            [self.barImage setCenter:imageCenter];
        }
    }
}

@end
