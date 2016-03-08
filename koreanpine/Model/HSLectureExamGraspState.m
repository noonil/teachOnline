//
//  HSLectureExamGraspState.m
//  koreanpine
//
//  Created by Christ on 15/7/30.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureExamGraspState.h"

@implementation HSLectureExamGraspState

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.lectureGraspRate = [dict floatForPath:@"cm"];
        self.lectureTotalCount = [dict integerForPath:@"cTotal"];
        self.examGraspRate = [dict floatForPath:@"eqr"];
        self.examTotalCount = [dict integerForPath:@"eTotal"];
    }
    return self;
}

@end
