//
//  HSHomeworkContainerCell.m
//  koreanpine
//
//  Created by Christ on 15/8/17.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSHomeworkContainerCell.h"

@implementation HSHomeworkContainerCell
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
    self.homeworkContainerVC = [[HSHomeworkVC alloc] initWithNibName:@"HSHomeworkVC" bundle:nil];
    [self.homeworkContainerVC.view setFrame:self.contentView.bounds];
    [self.homeworkContainerVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:self.homeworkContainerVC.view];
    
}

- (void)updateCellWithLecutreModel:(HSLectureModel *)lectureModel  homeworkModel:(HSLectureHomeworkModel *)homeworkModel
{
    [self.homeworkContainerVC updateVCWithLecutreModel:lectureModel homeworkModel:homeworkModel];
}

- (void)willDisplayCell
{
    [self.homeworkContainerVC willDisplayContainerView];
}

- (void)endDisplayCell
{
    [self.homeworkContainerVC endDisplayContainerView];
}


@end
