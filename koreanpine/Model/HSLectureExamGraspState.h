//
//  HSLectureExamGraspState.h
//  koreanpine
//
//  Created by Christ on 15/7/30.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "YH_Model.h"

@interface HSLectureExamGraspState : YH_Model

//课件掌握度
@property (assign, nonatomic) CGFloat lectureGraspRate;

//课件总数
@property (assign, nonatomic) NSUInteger lectureTotalCount;

//考试合格率
@property (assign, nonatomic) CGFloat examGraspRate;

//考试次数
@property (assign, nonatomic) NSUInteger examTotalCount;

@end
