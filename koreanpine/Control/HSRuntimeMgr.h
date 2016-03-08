//
//  HSRuntimeMgr.h
//  koreanpine
//
//  Created by Christ on 15/7/20.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSLectureExamGraspState.h"
#import "HSLectureClassModel.h"

#define kNotifiHomeInfoDidUpdate @"kNotifiHomeInfoDidUpdate"
#define kNotifiCompanysInfos @"kNotifiCompanysInfos"

@interface HSRuntimeMgr : NSObject

+ (instancetype)runtimeMgr;

@property (strong, nonatomic) NSArray *companyItems;

@property (strong, nonatomic) HSLectureExamGraspState *lectureExamGraspState;

@property (strong, nonatomic) NSArray *latestLectureArr;

@property (strong, nonatomic) NSMutableDictionary *imageSizeDict;

- (void)storeCompanyItems:(NSArray *)companyItems;

- (NSMutableArray *)loadCompanyItems;

- (void)getCompanyInfo;

- (void)getCourseAndExamGraspState;

- (void)getPublicLectureList;

@end
