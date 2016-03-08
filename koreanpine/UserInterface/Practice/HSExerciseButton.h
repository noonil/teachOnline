//
//  HSExerciseButton.h
//  koreanpine
//
//  Created by Victor on 15/10/21.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ExerciseAnswerType) {
    ExerciseAnswerTypeNUll,
    ExerciseAnswerTypeRight,
    ExerciseAnswerTypeWrong,
};
@interface HSExerciseButton : UIButton
@property (nonatomic,assign) ExerciseAnswerType answerType;
@property (nonatomic,assign) BOOL chooseAnswer;
@property (nonatomic,assign) NSInteger chooseCount;
@end
