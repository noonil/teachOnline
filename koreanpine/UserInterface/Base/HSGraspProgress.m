//
//  HSGraspProgress.m
//  koreanpine
//
//  Created by Christ on 15/7/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSGraspProgress.h"

@interface HSGraspProgress ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation HSGraspProgress

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self.imageView setHighlighted:selected];
}

- (void)initView
{
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self addSubview:self.imageView];
}

- (void)setGraspState:(HSGraspState)graspState
{
    
    _graspState = graspState;
    NSString *imageName = nil;
    NSString *highlightImageName = nil;
    switch (graspState) {
        case HSGraspStateNone: {
            imageName = @"未掌握_n";
            highlightImageName = @"未掌握_f";
            break;
        }
        case HSGraspStateOn: {
            imageName = @"掌握中_n";
            highlightImageName = @"掌握中_f";
            break;
        }
        case HSGraspStateFinish: {
            imageName = @"已掌握_n";
            highlightImageName = @"已掌握_f";
            break;
        }
            default:
            break;
    }
    [self.imageView setImage:[UIImage imageNamed:imageName]];
//    [self.imageView setHighlightedImage:[UIImage imageNamed:highlightImageName]];
}

@end
