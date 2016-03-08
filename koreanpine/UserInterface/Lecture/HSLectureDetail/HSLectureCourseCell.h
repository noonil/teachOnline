//
//  HSLectureCourseCell.h
//  koreanpine
//
//  Created by Christ on 15/8/4.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGraspProgress.h"
#import "HSLectureClassModel.h"

@interface HSLectureCourseCell : UITableViewCell

@property (strong, nonatomic) UIImageView *courseTypeFlag;

@property (strong, nonatomic) UIImageView *isNewFlag;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) HSGraspProgress *graspStateView;

@property (strong, nonatomic) HSLectureClassModel *lectureClassModel;

@property (assign, nonatomic) BOOL currentSelected;

- (void)updateCellWithLectureClass:(HSLectureClassModel *)lectureClassModel;

@end
