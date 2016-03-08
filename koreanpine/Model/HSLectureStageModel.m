//
//  HSLectureStageModel.m
//  koreanpine
//
//  Created by Christ on 15/7/28.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureStageModel.h"
#import "HSLectureClassModel.h"

@implementation HSLectureStageModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.stageId = [dict stringForKey:@"stageId"];
        self.stageName = [dict stringForKey:@"stageName"];
        self.isNew = [dict boolForKey:@"isNew"];
        self.classhourCount = [dict stringForKey:@"classhourCount"];
        
        self.homeworkCount = [dict stringForKey:@"homeworkCount"];
        
        
        NSArray *lectureClassInfos = dict[@"resList"];
        if (IsArrayClass(lectureClassInfos)) {
            NSMutableArray *lectureClassItems = [NSMutableArray array];
            for (NSDictionary *lectureClassDict in lectureClassInfos) {
                
                NSInteger resType = [lectureClassDict[@"resType"] integerValue];
                if (resType == 0) {
                    HSLectureClassModel *lectureClassItem = [[HSLectureClassModel alloc] initWithDict:lectureClassDict];
                    [lectureClassItems addObject:lectureClassItem];
                } else if(resType == 1) {
                    HSLectureHomeworkModel *homeworkItem = [[HSLectureHomeworkModel alloc] initWithDict:lectureClassDict];
                    [lectureClassItems addObject:homeworkItem];
                }else {
                    HSLecturePDFModel *pdfItem = [[HSLecturePDFModel alloc] initWithDict:lectureClassDict];
                    [lectureClassItems addObject:pdfItem];
                }
            }
            self.lectureClassArr = lectureClassItems;
            self.hasExpand = YES;
        }
    }
    return self;
}

- (void)changeExpandState
{
    self.hasExpand = !self.hasExpand;
}

@end
