//
//  HSAnswerOptionCell.h
//  koreanpine
//
//  Created by Christ on 15/8/19.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDoHomeworkViewModel.h"

#define kOptBtnNormalColor RGBCOLOR(220, 220, 220)
#define kOptBtnSelectColor RGBCOLOR(87,125,202)
#define kOptBtnRightColor RGBCOLOR(136,201,149)
#define kOptBtnErrorColor RGBCOLOR(227,123,53)

@interface HSAnswerOptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *optionBtn;

@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

/**
 *  指示是否在测试界面
 */
@property (assign, nonatomic) BOOL isTesting;

/**
 *  有没有被选中的选项，被选中且正确时的边框为绿色，否则为红色
 */
@property (assign, nonatomic) BOOL optionSelected;

/**
 *  是不是正确的选项,正确的选项按钮为绿色
 */
@property (assign, nonatomic) BOOL isRightOption;

@end

@protocol HSAnswerJudgeCellDelegate <NSObject>

- (void)userJudgeStateChangTo:(HSJudgeType)userJudgeType;

@end

@interface HSAnswerJudgeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIButton *wrongBtn;

/**
 *  指示是否在测试界面
 */
@property (assign, nonatomic) BOOL isTesting;

/**
 *  有没有被选中的选项，被选中且正确时的边框为绿色，否则为红色
 */
@property (assign, nonatomic) HSJudgeType userJudgeType;

/**
 *  是不是正确的选项,正确的选项按钮为绿色
 */
@property (assign, nonatomic) HSJudgeType answerJudgeType;

@property (weak, nonatomic) id<HSAnswerJudgeCellDelegate> delegate;


@end
