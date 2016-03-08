//
//  HSQuestionHeaderView.m
//  koreanpine
//
//  Created by Christ on 15/8/19.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSQuestionHeaderView.h"

@implementation HSQuestionHeaderView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
//    [self.contentView setBackgroundColor:[UIColor clearColor]];
//    self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.contentView.bounds)-30.0f, CGRectGetHeight(self.contentView.bounds))];
//    [self.questionLabel setFont:[UIFont systemFontOfSize:17.0f]];
//    [self.questionLabel setNumberOfLines:0];
//    [self.questionLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [self.questionLabel setTextColor:[UIColor blackColor]];
//    [self.questionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    [self.contentView addSubview:self.questionLabel];
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    self.questionLabel.frame = CGRectMake(15, 0, CGRectGetWidth(self.contentView.bounds)-30.0f, CGRectGetHeight(self.contentView.bounds));
//}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.questionTypeLabel.hidden) {
        self.questionLabel.frame = CGRectMake(15, 0, CGRectGetWidth(self.contentView.bounds)-30.0f, CGRectGetHeight(self.contentView.bounds));
    }else {
        self.questionLabel.frame = CGRectMake(15, 0, CGRectGetWidth(self.contentView.bounds)-30.0f, CGRectGetHeight(self.contentView.bounds)-20);
        self.questionTypeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.questionLabel.frame), CGRectGetWidth(self.contentView.bounds)-30.0f, 20);
    }
    
}
- (UILabel *)questionLabel {
    if (!_questionLabel) {
        _questionLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.contentView.bounds)-30.0f, CGRectGetHeight(self.contentView.bounds)-20)];
        [_questionLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_questionLabel setNumberOfLines:0];
        [_questionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_questionLabel setTextColor:[UIColor blackColor]];
        [_questionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self addSubview:_questionLabel];
    }
    return _questionLabel;
}
- (UILabel *)questionTypeLabel {
    if (!_questionTypeLabel) {
        _questionTypeLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.questionLabel.frame), CGRectGetWidth(self.contentView.bounds)-30.0f, 20)];
        [_questionTypeLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_questionTypeLabel setNumberOfLines:0];
        [_questionTypeLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_questionTypeLabel setTextColor:[UIColor blueColor]];
        [_questionTypeLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [_questionTypeLabel setText:@"[此题为多选题]"];
        [self addSubview:_questionTypeLabel];
    }
    return _questionTypeLabel;
}
@end
