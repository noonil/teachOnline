//
//  HSDoHomeworkViewModel.h
//  koreanpine
//
//  Created by Christ on 15/8/19.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSQuestionModel.h"
#define kExerciseBtnDidTappedNotification @"kExerciseBtnDidTappedNotification"
typedef NS_ENUM(NSInteger, HSJudgeType) {
    HSJudgeTypeNone = 0,
    HSJudgeTypeRight,
    HSJudgeTypeWrong
};


@interface HSDoHomeworkViewModel : NSObject

- (instancetype)initWithQuestionModel:(HSQuestionModel *)questionModel;

@property (strong, nonatomic) HSQuestionModel *questionModel;

@property (strong, nonatomic) NSMutableArray *realAnswerIndexPaths;

@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;

@property (assign, nonatomic) HSJudgeType userJudgeType;

@property (assign, nonatomic) HSJudgeType answerJudgeType;

- (NSDictionary *)submitDict;

- (NSInteger)optCount;

- (NSString *)optValueAtIndex:(NSInteger)index;

@end
