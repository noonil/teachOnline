//
//  HSMyCollectionCell.m
//  koreanpine
//
//  Created by 陶山强 on 15/10/28.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSMyCollectionCell.h"

#import "UIImageView+WebCache.h"

@implementation HSMyCollectionCell

- (void)awakeFromNib {
    [self initView];
}

- (void)initView
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setIndentationWidth:15];
    
    UIView *editAccessorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 22)];
    
    self.checkmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 22, 22)];
    [self.checkmarkBtn setBackgroundImage:[UIImage imageNamed:@"box02_n"] forState:UIControlStateNormal];
    [self.checkmarkBtn setBackgroundImage:[UIImage imageNamed:@"box02_f"] forState:UIControlStateSelected];
    [self.checkmarkBtn addTarget:self action:@selector(checkBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [editAccessorView addSubview:self.checkmarkBtn];
    [self setEditingAccessoryView:editAccessorView];
    self.bearImage = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"bear"]];
    [self.bearImage setFrame:CGRectMake(5, 5, 17, 19)];
    self.bearImage.backgroundColor = [UIColor clearColor];
    [self.lectureImageView addSubview:self.bearImage];
    
    self.isHotImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.lectureImageView.bounds)-15, 0, 15, 15)];
    [self.isHotImage setImage:[UIImage imageNamed:@"hot"]];
    [self.isHotImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    self.isHotImage.hidden = YES;
    [self.lectureImageView addSubview:self.isHotImage];
    
    self.isNewImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.lectureImageView.bounds)-15-15, 0,15, 15)];
    [self.isNewImage setImage:[UIImage imageNamed:@"new1"]];
    [self.isNewImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    self.isNewImage.hidden = YES;
    [self.lectureImageView addSubview:self.isNewImage];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
   
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerActive:)];
    [self addGestureRecognizer:longPress];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteOrNot:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:tapGesture];
}

- (void)updateCellWith:(HSMyCollectionModel *)lectureModel
{
    self.lectureModel = lectureModel;
    
    [self.lectureImageView sd_setImageWithURL:[NSURL URLWithString:self.lectureModel.lectureImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    if ([(self.lectureModel.collectSource)intValue] == 1) {
        self.bearImage.hidden = YES;
    }else{
        self.bearImage.hidden = NO;
    }
    self.isNewImage.hidden = YES;
    self.isHotImage.hidden = YES;
    self.isNewImage.hidden = !lectureModel.isNew;
    self.isHotImage.hidden = !lectureModel.isHot;
    if (!lectureModel.isHot && lectureModel.isNew) {
        self.isNewImage.frame = self.isHotImage.frame;
    }else {
        self.isNewImage.frame = CGRectMake(CGRectGetWidth(self.lectureImageView.bounds)-15-15, 0,15, 15);
    }
    [self.titleLabel setText:lectureModel.lectureName];
    [self.detailLabel setText:lectureModel.lectureDetail];
//    if (!lectureModel.isHs) {
//        [self.graspView setGraspState:self.lectureModel.graspState];
//        NSArray *graspStateTitles = @[@"未掌握",@"掌握中",@"已掌握"];
//        [self.graspStateLabel setText:graspStateTitles[self.lectureModel.graspState]];
//    }else {
//        self.graspStateLabel.text = @"";
//    }

}
- (void)checkBtnTapped:(UIButton *)checkBtn
{
    [self.checkmarkBtn setSelected:!self.checkmarkBtn.selected];
    if ([self.delegate respondsToSelector:@selector(checkmarkBtnTapped:)]) {
        [self.delegate checkmarkBtnTapped:self];
    }

}
- (void) longPressGestureRecognizerActive:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(longPressGestureRecognizerActive:)]) {
        [self.delegate longPressGestureRecognizerActive:self];
    }
}
- (void) deleteOrNot:(UITapGestureRecognizer *)tapGesture {
    UIColor *color = self.backgroundColor;
    WS(weakSelf);
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.backgroundColor = [UIColor lightGrayColor];
    }completion:^(BOOL finished) {
        if (finished) {
         weakSelf.backgroundColor = color;
        }
    }];
    if (self.editing) {
        [self.checkmarkBtn setSelected:!self.checkmarkBtn.selected];
        if ([self.delegate respondsToSelector:@selector(checkmarkBtnTapped:)]) {
            [self.delegate checkmarkBtnTapped:self];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(jumpToLectureView:)]) {
            [self.delegate jumpToLectureView:self];
        }
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.isNewImage.hidden = YES;
    self.isHotImage.hidden = YES;
    self.isNewImage.hidden = !self.lectureModel.isNew;
    self.isHotImage.hidden = !self.lectureModel.isHot;
    if (!self.lectureModel.isHot && self.lectureModel.isNew) {
        self.isNewImage.frame = self.isHotImage.frame;
    }else {
        self.isNewImage.frame = CGRectMake(CGRectGetWidth(self.lectureImageView.bounds)-15-15, 0,15, 15);
    }
}

@end
