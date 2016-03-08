//
//  HSHomeworkVC.h
//  koreanpine
//
//  Created by Christ on 15/8/17.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
#import "HSLectureDetailVC.h"
#import "HSLectureModel.h"
#import "HSLectureClassModel.h"
#import "HSClassVC.h"

@interface HSHomeworkVC : HSBaseVC
<HSContainerVCInterface>

@property (weak ,nonatomic) HSLectureDetailVC *mainVC;

- (void)updateVCWithLecutreModel:(HSLectureModel *)lectureModel  homeworkModel:(HSLectureHomeworkModel *)homeworkModel;

@end
