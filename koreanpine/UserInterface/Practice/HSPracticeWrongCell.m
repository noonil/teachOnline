//
//  HSPracticeWrongCell.m
//  koreanpine
//
//  Created by 陶山强 on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPracticeWrongCell.h"
#define screenRect [[UIScreen mainScreen]bounds]
@implementation HSPracticeWrongCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
}

-(void)initView{
    
}
- (void)updateCellWith:(HSPracticeWrongModel *)practiceWrongModel wrongNum:(NSString *)wrongNum
{
    self.practiceWrongModel = practiceWrongModel;
    self.wrongText.text = self.practiceWrongModel.questionModel.content;
    self.WrongNum.text = wrongNum;
    if (CGRectGetWidth(screenRect)>320) {
        self.wrongText.font = [UIFont systemFontOfSize:16.0f];
        self.WrongNum.font = [UIFont systemFontOfSize:16.0f];
        if ([wrongNum intValue] >=100) {
            self.WrongNum.font = [UIFont systemFontOfSize:12.0f];
        }
    }
    if ([wrongNum intValue] >=100) {
        self.WrongNum.font = [UIFont systemFontOfSize:10.0f];
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
