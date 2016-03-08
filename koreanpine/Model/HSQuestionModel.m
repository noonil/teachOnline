//
//  HSQuestionModel.m
//  koreanpine
//
//  Created by Christ on 15/8/19.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSQuestionModel.h"

@implementation HSQuestionModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self.dict addEntriesFromDictionary:dict];
        
        self.analysis = [dict stringForKey:@"analysis"];
        
        self.answer = [dict stringForKey:@"answer"];
        
        self.batch = [dict stringForKey:@"batch"];
        
        self.blankAnswer1 = [dict stringForKey:@"blankAnswer1"];
        
        self.blankAnswer2 = [dict stringForKey:@"blankAnswer2"];
        
        self.blankAnswer3 = [dict stringForKey:@"blankAnswer3"];
        
        self.blankAnswer4 = [dict stringForKey:@"blankAnswer4"];
        
        self.blankAnswer5 = [dict stringForKey:@"blankAnswer5"];
        
        self.blankAnswer6 = [dict stringForKey:@"blankAnswer6"];
        
        self.blankAnswer7 = [dict stringForKey:@"blankAnswer7"];
        
        self.blankAnswer8 = [dict stringForKey:@"blankAnswer8"];
        
        self.blankAnswer9 = [dict stringForKey:@"blankAnswer9"];
        
        self.blankAnswer10 = [dict stringForKey:@"blankAnswer10"];
        
        self.classify = [dict stringForKey:@"classify"];
        
        self.classify2 = [dict stringForKey:@"classify2"];
        
        self.content = [dict stringForKey:@"content"];
        
        self.correctPercent = [dict stringForKey:@"correctPercent"];
        
        self.creater = [dict stringForKey:@"creater"];
        
        self.itemDescription = [dict stringForKey:@"itemDescription"];
        
        self.difficulty = [dict stringForKey:@"difficulty"];
        
        self.examExamineeDetail = [dict stringForKey:@"examExamineeDetail"];
        
        self.examExamineeId = [dict stringForKey:@"examExamineeId"];
        
        self.favoriteId = [dict stringForKey:@"favoriteId"];
        
        self.homeWorkId = [dict stringForKey:@"homeWorkId"];
        
        self.itemId = [dict stringForKey:@"id"];
        
        self.imgSrc = [dict stringForKey:@"imgSrc"];
        
        self.initial = [dict stringForKey:@"initial"];
        
        self.isFavorites = [dict stringForKey:@"isFavorites"];
        
        self.isOrginal = [dict stringForKey:@"isOrginal"];
        
        self.isShow = [dict stringForKey:@"isShow"];
        
        self.isUse = [dict stringForKey:@"isUse"];
        
        self.manufacturers = [dict stringForKey:@"manufacturers"];
        
        self.md5 = [dict stringForKey:@"md5"];
        
        self.optA = [dict stringForKey:@"optA"];
        
        self.optB = [dict stringForKey:@"optB"];
        
        self.optC = [dict stringForKey:@"optC"];
        
        self.optD = [dict stringForKey:@"optD"];
        
        self.optE = [dict stringForKey:@"optE"];
        
        self.optF = [dict stringForKey:@"optF"];
        
        self.optG = [dict stringForKey:@"optG"];
        
        self.optH = [dict stringForKey:@"optH"];
        
        self.optI = [dict stringForKey:@"optI"];
        
        self.optJ = [dict stringForKey:@"optJ"];
        
        self.orginalId = [dict stringForKey:@"orginalId"];
        
        self.paperTablename = [dict stringForKey:@"paperTablename"];
        
        self.pk = [dict stringForKey:@"pk"];
        
        self.qId = [dict stringForKey:@"qId"];
        
        self.quesNotes = [dict stringForKey:@"quesNotes"];
        
        self.quesTablename = [dict stringForKey:@"quesTablename"];
        
        NSString *quesTypeValue = [dict stringForKey:@"quesType"];
        if ([quesTypeValue isEqualToString:@"multiple"]) {
             self.quesType = HSQuesTypeMuiltSelect;
        } else if ([quesTypeValue isEqualToString:@"judge"]) {
            self.quesType = HSQuesTypeJudge;
        } else {
            self.quesType = HSQuesTypeSingleSelect;
        }
        
        self.questionLength = [dict stringForKey:@"questionLength"];
        
        self.quuid = [dict stringForKey:@"quuid"];
        
        self.remark = [dict stringForKey:@"remark"];
        
        self.result = [dict stringForKey:@"result"];
        
        self.status = [dict stringForKey:@"status"];
        
        self.totalAnsNum = [dict stringForKey:@"totalAnsNum"];
        
        self.userAnswer = [dict stringForKey:@"userAnswer"];
        
        self.uuid = [dict stringForKey:@"uuid"];
        
        self.practiceWrongIdStr = [dict stringForKey:@"pwId"];
    }
    return self;
}

- (NSMutableDictionary *)dict
{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (void)setUserAnswer:(NSString *)userAnswer
{
    _userAnswer = userAnswer;
    if (userAnswer) {
        [self.dict setObject:userAnswer forKey:@"userAnswer"];
    }
}

@end
