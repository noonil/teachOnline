//
//  HSDoHomeworkContainerCell.m
//  koreanpine
//
//  Created by Christ on 15/8/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSDoHomeworkContainerCell.h"

@implementation HSDoHomeworkContainerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCell];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    self.doHomeWorkVC = [[HSDoHomeworkVC alloc] init];
    [self.doHomeWorkVC.view setFrame:self.contentView.bounds];
    [self.doHomeWorkVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:self.doHomeWorkVC.view];
    
}

@end
