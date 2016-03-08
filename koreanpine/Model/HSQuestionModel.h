//
//  HSQuestionModel.h
//  koreanpine
//
//  Created by Christ on 15/8/19.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "YH_Model.h"

typedef NS_ENUM(NSUInteger, HSQuesType) {
    HSQuesTypeSingleSelect = 0,
    HSQuesTypeMuiltSelect,
    HSQuesTypeJudge
};

@interface HSQuestionModel : YH_Model

@property (strong, nonatomic) NSMutableDictionary *dict;

@property (copy, nonatomic) NSString *analysis;

@property (copy, nonatomic) NSString *answer;

@property (copy, nonatomic) NSString *batch;

@property (copy, nonatomic) NSString *blankAnswer1;

@property (copy, nonatomic) NSString *blankAnswer2;

@property (copy, nonatomic) NSString *blankAnswer3;

@property (copy, nonatomic) NSString *blankAnswer4;

@property (copy, nonatomic) NSString *blankAnswer5;

@property (copy, nonatomic) NSString *blankAnswer6;

@property (copy, nonatomic) NSString *blankAnswer7;

@property (copy, nonatomic) NSString *blankAnswer8;

@property (copy, nonatomic) NSString *blankAnswer9;

@property (copy, nonatomic) NSString *blankAnswer10;

@property (copy, nonatomic) NSString *classify;

@property (copy, nonatomic) NSString *classify2;
/**
 *  问题的内容
 */
@property (copy, nonatomic) NSString *content;

@property (copy, nonatomic) NSString *correctPercent;

@property (copy, nonatomic) NSString *creater;

@property (copy, nonatomic) NSString *itemDescription;

@property (copy, nonatomic) NSString *difficulty;

@property (copy, nonatomic) NSString *examExamineeDetail;

@property (copy, nonatomic) NSString *examExamineeId;

@property (copy, nonatomic) NSString *favoriteId;

@property (copy, nonatomic) NSString *homeWorkId;

@property (copy, nonatomic) NSString *itemId;

@property (copy, nonatomic) NSString *imgSrc;

@property (copy, nonatomic) NSString *initial;

@property (copy, nonatomic) NSString *isFavorites;

@property (copy, nonatomic) NSString *isOrginal;

@property (copy, nonatomic) NSString *isShow;

@property (copy, nonatomic) NSString *isUse;

@property (copy, nonatomic) NSString *manufacturers;

@property (copy, nonatomic) NSString *md5;

@property (copy, nonatomic) NSString *optA;

@property (copy, nonatomic) NSString *optB;

@property (copy, nonatomic) NSString *optC;

@property (copy, nonatomic) NSString *optD;

@property (copy, nonatomic) NSString *optE;

@property (copy, nonatomic) NSString *optF;

@property (copy, nonatomic) NSString *optG;

@property (copy, nonatomic) NSString *optH;

@property (copy, nonatomic) NSString *optI;

@property (copy, nonatomic) NSString *optJ;

@property (copy, nonatomic) NSString *orginalId;

@property (copy, nonatomic) NSString *paperTablename;

@property (copy, nonatomic) NSString *pk;

@property (copy, nonatomic) NSString *qId;

@property (copy, nonatomic) NSString *quesNotes;

@property (copy, nonatomic) NSString *quesTablename;

/*
 *  选择题类型，单选或者多选
 */
@property (assign, nonatomic) HSQuesType quesType;

@property (copy, nonatomic) NSString *questionLength;

@property (copy, nonatomic) NSString *quuid;

@property (copy, nonatomic) NSString *remark;

@property (copy, nonatomic) NSString *result;

@property (copy, nonatomic) NSString *status;

@property (copy, nonatomic) NSString *totalAnsNum;

@property (copy, nonatomic) NSString *userAnswer;

@property (copy, nonatomic) NSString *uuid;

@property(copy,nonatomic)NSString *practiceWrongIdStr;
@end
