//
//  HSDoHomeworkViewModel.m
//  koreanpine
//
//  Created by Christ on 15/8/19.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSDoHomeworkViewModel.h"

@implementation HSDoHomeworkViewModel

@synthesize userJudgeType = _userJudgeType;

- (instancetype)initWithQuestionModel:(HSQuestionModel *)questionModel
{
    self = [super init];
    if (self) {
        self.questionModel = questionModel;
    }
    return self;
}

- (NSMutableArray *)realAnswerIndexPaths
{
    if (!_realAnswerIndexPaths) {
        _realAnswerIndexPaths = [NSMutableArray array];
        NSArray *answerOptions = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
        for (int row = 0; row < answerOptions.count; row++) {
            NSString *answerOption = answerOptions[row];
            
            NSRange range = [self.questionModel.answer rangeOfString:answerOption];
            if (range.location != NSNotFound) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                [_realAnswerIndexPaths addObject:indexPath];
            }
        }
    }
    return _realAnswerIndexPaths;
}

- (NSMutableArray *)selectedIndexPaths
{
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [NSMutableArray array];
            NSArray *answerOptions = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
        for (int row = 0; row < answerOptions.count; row++) {
            NSString *answerOption = answerOptions[row];
            NSRange range = [self.questionModel.userAnswer rangeOfString:answerOption];
            if (range.location != NSNotFound) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                [_selectedIndexPaths addObject:indexPath];
            }
        }
    }
    return _selectedIndexPaths;
}

- (HSJudgeType)userJudgeType
{

        if ([self.questionModel.userAnswer isEqualToString:@"对"]) {
            _userJudgeType = HSJudgeTypeRight;
        } else if ([self.questionModel.userAnswer isEqualToString:@"错"]){
            _userJudgeType = HSJudgeTypeWrong;
        } else {
            _userJudgeType = HSJudgeTypeNone;
        }
    return _userJudgeType;
}

- (void)setUserJudgeType:(HSJudgeType)userJudgeType
{
    _userJudgeType = userJudgeType;
    if (userJudgeType == HSJudgeTypeRight) {
        self.questionModel.userAnswer = @"对";
    } else if (userJudgeType == HSJudgeTypeWrong) {
        self.questionModel.userAnswer = @"错";
    }
}

- (HSJudgeType)answerJudgeType
{
    if ([self.questionModel.answer isEqualToString:@"对"]) {
        _answerJudgeType = HSJudgeTypeRight;
    } else if ([self.questionModel.userAnswer isEqualToString:@"错"]){
        _answerJudgeType = HSJudgeTypeWrong;
    }

    return _answerJudgeType;
}


- (NSInteger)optCount
{
    NSArray *optNameArr = @[@"optA",@"optB",@"optC",@"optD",@"optE",@"optF",@"optG",@"optH",@"optI",@"optJ"];
    NSInteger count = 0;
    for (; count < optNameArr.count; count ++) {
        NSString *value = [self.questionModel valueForKey:optNameArr[count]];
        if (value.length == 0) { break; }
    }
    return count;
}

- (NSString *)optValueAtIndex:(NSInteger)index
{
    NSArray *optNameArr = @[@"optA",@"optB",@"optC",@"optD",@"optE",@"optF",@"optG",@"optH",@"optI",@"optJ"];
    if (index >= optNameArr.count) {  return nil; }
    NSString *value = [self.questionModel valueForKey:optNameArr[index]];
    return value;
}

- (NSDictionary *)submitDict
{
    if (self.questionModel.quesType == HSQuesTypeJudge) {
        if (self.userJudgeType == HSJudgeTypeRight) {
            [self.questionModel setUserAnswer:@"对"];
        } else if (self.userJudgeType == HSJudgeTypeWrong) {
            [self.questionModel setUserAnswer:@"错"];
        }
    } else {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"row" ascending:YES];
        NSArray *indexPaths = [self.selectedIndexPaths sortedArrayUsingDescriptors:@[sortDescriptor]];
        NSArray *answerOptions = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
        NSString *userAnswers = @"";
        for(NSIndexPath *indexPath in indexPaths) {
            userAnswers = [userAnswers stringByAppendingFormat:@"%@",answerOptions[indexPath.row]];
        }
        [self.questionModel setUserAnswer:userAnswers];
    }
    
    return self.questionModel.dict;
}

@end
