//
//  HSHomeworkDetailVC.h
//  koreanpine
//
//  Created by Christ on 15/8/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
#import "HSLectureClassModel.h"

@interface HSHomeworkDetailVC : HSBaseVC

- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel;

@property (strong, nonatomic) HSLectureHomeworkModel *homeworkModel;

@end
