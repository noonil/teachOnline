//
//  HSHomeworkContainerCell.h
//  koreanpine
//
//  Created by Christ on 15/8/17.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSLectureModel.h"
#import "HSLectureClassModel.h"
#import "HSHomeworkVC.h"

@interface HSHomeworkContainerCell : UICollectionViewCell

@property (strong, nonatomic) HSHomeworkVC *homeworkContainerVC;

- (void)updateCellWithLecutreModel:(HSLectureModel *)lectureModel  homeworkModel:(HSLectureHomeworkModel *)homeworkModel;

- (void)willDisplayCell;

- (void)endDisplayCell;

@end
