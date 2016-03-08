//
//  HSAnswerSectionHeader.m
//  koreanpine
//
//  Created by Christ on 15/8/21.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSAnswerSectionHeader.h"

@implementation HSAnswerSectionHeader

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
   
}
- (void)layoutSubviews {
    [super layoutSubviews];
     [self.contentView setBackgroundColor:[UIColor whiteColor]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.bounds)-0.5, CGRectGetWidth(self.contentView.bounds), 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [lineView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
    [self.contentView addSubview:lineView];
    self.imageView.frame = CGRectMake(0, 0, 12, CGRectGetHeight(self.contentView.bounds));
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, (CGRectGetHeight(self.contentView.bounds)-26)/2, 250, 26);
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, CGRectGetHeight(self.contentView.bounds))];
        [_imageView setCenter:CGPointMake(CGRectGetWidth(self.imageView.bounds)/2, CGRectGetMidY(self.contentView.bounds))];
        [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_imageView setImage:[UIImage imageNamed:@"start_blue"]];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, (CGRectGetHeight(self.contentView.bounds)-26)/2, 250, 26)];
        [_titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [_titleLabel setText:@"答案解析"];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end