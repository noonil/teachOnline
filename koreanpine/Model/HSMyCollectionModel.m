//
//  HSMyCollectionModel.m
//  koreanpine
//
//  Created by 陶山强 on 15/10/28.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSMyCollectionModel.h"

@implementation HSMyCollectionModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //        [self setValuesForKeysWithDictionary:dict];
        self.lectureID = [dict stringForKey:@"id"];
        self.lectureName = [dict stringForKey:@"coursename"];
        self.lectureDetail = [dict stringForKey:@"coursedetail"];
        self.lectureImageUrl = [dict stringForKey:@"courseimg"];
        self.lectureImageUrl = [HSImgBaseURL stringByAppendingPathComponent:self.lectureImageUrl];
        self.isCollect = [dict boolForKey:@"isCollect"];
        //        self.graspState = HSGraspStateNone;
        self.isNew = [dict boolForKey:@"isNew"];
        self.isHot = [dict boolForKey:@"isHot"];
        self.modifyTime = [dict stringForKey:@"modifyTime"];
        self.viewed = [dict stringForKey:@"viewed"];
        self.collectCount = [dict stringForKey:@"collectCount"];
    }
    return self;
}
@end
