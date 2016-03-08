//
//  HSExerciseDetailVC.h
//  koreanpine
//
//  Created by Victor on 15/10/19.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
@class HSLectureHomeworkModel;
@interface HSExerciseDetailVC : HSBaseVC
- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel;

@property (strong, nonatomic) HSLectureHomeworkModel *homeworkModel;
@end
