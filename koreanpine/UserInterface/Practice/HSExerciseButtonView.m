//
//  HSExerciseButtonView.m
//  koreanpine
//
//  Created by Victor on 15/11/11.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSExerciseButtonView.h"
#import "UIView+WTXM.h"
@interface HSExerciseButtonView ()

@end
@implementation HSExerciseButtonView
- (void)awakeFromNib {
    self.moreExerciseBtnView = [UIView new];
    self.moreExerciseBtnView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    self.imageView = [[UIImageView alloc] init];
    [self.imageView sizeToFit];
    self.imageView.center = self.moreExerciseBtnView.center;
    [self.moreExerciseBtnView addSubview:self.imageView];
    [self addSubview:self.moreExerciseBtnView];
}
- (void)layoutSubviews {
    
    self.moreExerciseBtnView.frame = CGRectMake(0, self.hei-7, self.wid, 7);
    self.imageView.frame = CGRectMake(100, 0, 9, 7);
    self.imageView.centerX = self.centerX;
    self.imageView.image = [UIImage imageNamed:@"答题卡_down"];
    [self.moreExerciseBtnView addSubview:self.imageView];
    [super layoutSubviews];

}
- (void)setHei:(CGFloat)hei {
    [super setHei:hei];
    self.moreExerciseBtnView.frame = CGRectMake(0, self.hei-7, self.wid, 7);
    self.imageView.frame = CGRectMake(100, 0, 9, 7);
    self.imageView.centerX = self.centerX;
    self.imageView.image = [UIImage imageNamed:@"答题卡_down"];
    [self.moreExerciseBtnView addSubview:self.imageView];
}
@end
