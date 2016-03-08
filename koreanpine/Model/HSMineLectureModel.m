//
//  HSMineLectureModel.m
//  koreanpine
//
//  Created by Christ on 15/7/26.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSMineLectureModel.h"
#import "NetworkCenter.h"

@implementation HSMineLectureModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.lectureID = [dict stringForKey:@"id"];
        self.lectureName = [dict stringForKey:@"courseName"];
        self.lectureDetail = [dict stringForKey:@"courseDetail"];
        self.lectureImageUrl = [dict stringForKey:@"courseImg"];
        self.lectureImageUrl = [HSImgBaseURL stringByAppendingPathComponent:self.lectureImageUrl];
        self.lectureCount = [dict integerForPath:@"classcount"];
        self.lectureModifyTime = [dict stringForKey:@"modifyTime"];
        self.lectureLinkUrl = [dict stringForKey:@"linkUrl"];
        NSUInteger graspPercent = [dict integerForPath:@"percent"];
        if (graspPercent == 0) {
            self.graspState = HSGraspStateNone;
        } else if (graspPercent == 100) {
            self.graspState = HSGraspStateFinish;
        } else {
            self.graspState = HSGraspStateOn;
        }
    }
    return self;
}

@end
