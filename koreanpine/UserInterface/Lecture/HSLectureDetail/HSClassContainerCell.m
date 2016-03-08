//
//  HSLectureDetailContainerCell.m
//  koreanpine
//
//  Created by Christ on 15/8/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSClassContainerCell.h"
#import "HSLectureClassModel.h"
#import "HSLectureModel.h"
#import "HSClassVC.h"
@implementation HSClassContainerCell

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
    self.classContainerVC = [[HSClassVC alloc] initWithNibName:@"HSClassVC" bundle:nil];
    [self.classContainerVC.view setFrame:self.contentView.bounds];
    [self.classContainerVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:self.classContainerVC.view];
    
}

- (void)updateCellWithLecutreModel:(HSLectureModel *)lectureModel  classModel:(HSLectureClassModel *)lectureClassModel 
{
    [self.classContainerVC updateVCWithLecutreModel:lectureModel classModel:lectureClassModel];
    
}

- (void)willDisplayCell
{
    [self.classContainerVC willDisplayContainerView];
}

- (void)endDisplayCell
{
    [self.classContainerVC endDisplayContainerView];
}



@end
