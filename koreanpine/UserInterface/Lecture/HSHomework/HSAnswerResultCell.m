//
//  HSAnswerResultCell.m
//  koreanpine
//
//  Created by Christ on 15/8/21.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSAnswerResultCell.h"

@implementation HSAnswerResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithQuestionItem:(HSQuestionModel *)questionModel
{
    BOOL isAnswerRight = [questionModel.answer isEqualToString:questionModel.userAnswer];
    NSString *answerJudge = isAnswerRight?@"回答正确":@"回答错误";
    [self.realAnswerLabel setText:[NSString stringWithFormat:@"答案解析：%@",questionModel.answer]];
    
    if(IsStrEmpty(questionModel.userAnswer)) {
        [self.mineAnswerLabel setTextColor:RGBCOLOR(255, 21, 0)];
        [self.mineAnswerLabel setText:@"您没有作答"];
    } else {
        [self.mineAnswerLabel setText:[NSString stringWithFormat:@"您的答案是：%@,%@",questionModel.userAnswer,answerJudge]];
        UIColor *textColor = isAnswerRight?kActionBtnNormalColor:RGBCOLOR(255, 21, 0);
        [self.mineAnswerLabel setTextColor:textColor];
    }

    [self.answerDetailLabel setText:[NSString stringWithFormat:@"试题解析：%@",questionModel.analysis]];
}

@end
