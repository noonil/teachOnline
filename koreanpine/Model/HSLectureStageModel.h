//
//  HSLectureStageModel.h
//  koreanpine
//
//  Created by Christ on 15/7/28.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "YH_Model.h"

@interface HSLectureStageModel : YH_Model

@property (assign, nonatomic) BOOL hasExpand;

@property (copy, nonatomic) NSString *stageId;

@property (copy, nonatomic) NSString *stageName;

@property(nonatomic,strong)NSString *classhourCount;

@property(nonatomic,strong)NSString *homeworkCount;

@property (assign, nonatomic) BOOL isNew;

@property (strong, nonatomic) NSArray *lectureClassArr;

- (void)changeExpandState;

@end
