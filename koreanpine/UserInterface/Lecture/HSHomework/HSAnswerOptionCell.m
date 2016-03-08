//
//  HSAnswerOptionCell.m
//  koreanpine
//
//  Created by Christ on 15/8/19.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSAnswerOptionCell.h"

@implementation HSAnswerOptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)prepareForReuse
{
    [self resetOption];
}

- (void)resetOption
{
    [self.optionBtn setSelected:NO];
    [self.optionBtn setBackgroundColor:kOptBtnNormalColor];
    DrawViewBorder(self.containerView, 0.5, kOptBtnNormalColor);
}

- (void)initView
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    [self.optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self resetOption];
}

- (void)setIsTesting:(BOOL)isTesting
{
    _isTesting = isTesting;
    [self updateCellView];
}

- (void)setOptionSelected:(BOOL)optionSelected
{
    _optionSelected = optionSelected;
    [self updateCellView];
}

- (void)setIsRightOption:(BOOL)isRightOption
{
    _isRightOption = isRightOption;
    [self updateCellView];
}

- (void)updateCellView
{
    if (self.isTesting) {
        if (self.optionSelected) {
            [self.optionBtn setSelected:YES];
            [self.optionBtn setBackgroundColor:kOptBtnSelectColor];
            DrawViewBorder(self.containerView, 0.5, kOptBtnSelectColor);
        } else {
            [self.optionBtn setSelected:NO];
            [self.optionBtn setBackgroundColor:kOptBtnNormalColor];
            DrawViewBorder(self.containerView, 0.5, kOptBtnNormalColor);
        }
    } else {
        if (_isRightOption&&_optionSelected) {
            //选中并且正确
            [self.optionBtn setSelected:YES];
            [self.optionBtn setBackgroundColor:kOptBtnRightColor];
            DrawViewBorder(self.containerView, 0.5, kOptBtnRightColor);
        } else if(_isRightOption&&!_optionSelected) {
            //正确未选中
            [self.optionBtn setSelected:YES];
            [self.optionBtn setBackgroundColor:kOptBtnRightColor];
            DrawViewBorder(self.containerView, 0.5, kOptBtnNormalColor);
            
        } else if(!_isRightOption&&_optionSelected) {
            [self.optionBtn setSelected:YES];
            [self.optionBtn setBackgroundColor:kOptBtnErrorColor];
            DrawViewBorder(self.containerView, 0.5, kOptBtnErrorColor);
        } else {
            [self resetOption];
        }
    }
}

@end

@implementation HSAnswerJudgeCell

- (void)awakeFromNib
{
    [self initCell];
}

- (void)prepareForReuse
{
    self.userJudgeType = HSJudgeTypeNone;
    [self.rightBtn setSelected:NO];
    [self.wrongBtn setSelected:NO];
    DrawViewBorder(self.rightBtn, 0.5, kOptBtnNormalColor);
    DrawViewBorder(self.wrongBtn, 0.5, kOptBtnNormalColor);
}

- (void)initCell
{
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.rightBtn setBackgroundColor:[UIColor whiteColor]];
    [self.wrongBtn setBackgroundColor:[UIColor whiteColor]];
    [self.rightBtn.layer setCornerRadius:3.0f];
    [self.wrongBtn.layer setCornerRadius:3.0f];
}


- (IBAction)rightBtnTapped:(UIButton *)sender {
    [self setUserJudgeType:HSJudgeTypeRight];
    if ([self.delegate respondsToSelector:@selector(userJudgeStateChangTo:)]) {
        [self.delegate userJudgeStateChangTo:HSJudgeTypeRight];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kExerciseBtnDidTappedNotification object:@1];

}

- (IBAction)wrongBtnTapped:(UIButton *)sender {
    [self setUserJudgeType:HSJudgeTypeWrong];
    if ([self.delegate respondsToSelector:@selector(userJudgeStateChangTo:)]) {
        [self.delegate userJudgeStateChangTo:HSJudgeTypeWrong];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kExerciseBtnDidTappedNotification object:@1];

}


- (void)setIsTesting:(BOOL)isTesting
{
    _isTesting = isTesting;
    [self setUserInteractionEnabled:_isTesting];
    
    if (_isTesting) {
        [self.rightBtn setTitleColor:kOptBtnSelectColor forState:UIControlStateSelected];
        [self.wrongBtn setTitleColor:kOptBtnSelectColor forState:UIControlStateSelected];
        [self updateCellView];
    } else {
        
    }
}

- (void)setUserJudgeType:(HSJudgeType)judgeType
{
    _userJudgeType = judgeType;
    [self updateCellView];
}

- (void)setAnswerJudgeType:(HSJudgeType)answerJudgeType
{
    _answerJudgeType = answerJudgeType;
    [self updateCellView];
}

- (void)updateCellView
{
    if (self.isTesting) {
        switch (self.userJudgeType) {
            case HSJudgeTypeNone:
                [self.rightBtn setSelected:NO];
                DrawViewBorder(self.rightBtn, 0.5, kOptBtnNormalColor);
                [self.wrongBtn setSelected:NO];
                DrawViewBorder(self.wrongBtn, 0.5, kOptBtnNormalColor);
                break;
            case HSJudgeTypeRight:{
                [self.rightBtn setSelected:YES];
                DrawViewBorder(self.rightBtn, 0.5, kOptBtnSelectColor);
                [self.wrongBtn setSelected:NO];
                DrawViewBorder(self.wrongBtn, 0.5, kOptBtnNormalColor);
                break;
            }
            case HSJudgeTypeWrong:{
                [self.rightBtn setSelected:NO];
                DrawViewBorder(self.rightBtn, 0.5, kOptBtnNormalColor);
                [self.wrongBtn setSelected:YES];
                DrawViewBorder(self.wrongBtn, 0.5, kOptBtnSelectColor);
            }
            default:
                break;
        }
    } else {
        //选中左边对的选项
        
        if (self.userJudgeType == HSJudgeTypeRight) {
            [self.rightBtn setSelected:YES];
            [self.wrongBtn setSelected:NO];
            DrawViewBorder(self.wrongBtn, 0.5, kOptBtnNormalColor);
            //答题正确
            if (self.userJudgeType == self.answerJudgeType) {
                [self.rightBtn setTitleColor:kOptBtnRightColor forState:UIControlStateSelected];
                DrawViewBorder(self.rightBtn, 0.5, kOptBtnRightColor);
            } else {
                [self.rightBtn setTitleColor:kOptBtnErrorColor forState:UIControlStateSelected];
                DrawViewBorder(self.rightBtn, 0.5, kOptBtnErrorColor);
            }
        }
        //选中右边错的选项
        else if (self.userJudgeType == HSJudgeTypeWrong) {
            [self.wrongBtn setSelected:YES];
            [self.rightBtn setSelected:NO];
            DrawViewBorder(self.rightBtn, 0.5, kOptBtnNormalColor);
            
            //答题正确
            if (self.userJudgeType == self.answerJudgeType) {
                [self.wrongBtn setTitleColor:kOptBtnRightColor forState:UIControlStateSelected];
                DrawViewBorder(self.wrongBtn, 0.5, kOptBtnRightColor);
            } else {
                [self.wrongBtn setTitleColor:kOptBtnErrorColor forState:UIControlStateSelected];
                DrawViewBorder(self.wrongBtn, 0.5, kOptBtnErrorColor);
            }
        }
    }
}

@end
