//
//  HSLectureModel.m
//  koreanpine
//
//  Created by Christ on 15/7/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureModel.h"
#import "NetworkCenter.h"
@implementation HSLectureModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
//        [self setValuesForKeysWithDictionary:dict];
        self.lectureID = [dict stringForKey:@"id"];
         self.collectID = [dict stringForKey:@"collectId"];
        self.collectInfoID = [dict stringForKey:@"collectInfoID"];
        self.lectureName = [dict stringForKey:@"courseName"];
        self.lectureDetail = [dict stringForKey:@"courseDetail"];
        self.lectureImageUrl = [dict stringForKey:@"courseImg"];
        self.lectureImageUrl = [HSImgBaseURL stringByAppendingPathComponent:self.lectureImageUrl];
        self.isCollect = [dict boolForKey:@"isCollect"];
        
        self.collectSource = [dict stringForKey:@"collectSource"];
        
        self.hsCourseFlag = [dict stringForKey:@"hsCourseFlag"];
        
        self.collectCount = [dict stringForKey:@"collectCount"];
        self.viewed = [dict stringForKey:@"viewed"];
        
        self.updateTime = [dict stringForKey:@"updateTime"];

        
//        self.graspState = HSGraspStateNone;
        self.isNew = [dict boolForKey:@"isNew"];
        self.isHot = [dict boolForKey:@"isHot"];
    }
    return self;
}

@end
