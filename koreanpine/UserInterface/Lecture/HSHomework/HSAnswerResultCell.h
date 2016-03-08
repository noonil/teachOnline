//
//  HSAnswerResultCell.h
//  koreanpine
//
//  Created by Christ on 15/8/21.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSQuestionModel.h"

@interface HSAnswerResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *realAnswerLabel;

@property (weak, nonatomic) IBOutlet UILabel *mineAnswerLabel;

@property (weak, nonatomic) IBOutlet UILabel *answerDetailLabel;

- (void)updateCellWithQuestionItem:(HSQuestionModel *)questionModel;


@end
