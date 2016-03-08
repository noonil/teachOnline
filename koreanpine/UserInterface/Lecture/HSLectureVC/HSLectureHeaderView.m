//
//  HSLectureHeaderView.m
//  koreanpine
//
//  Created by Christ on 15/7/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureHeaderView.h"
#define itemCellScale 145/155
@implementation HSLectureHeaderView

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

- (void)initView
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.bubbleView = [[HSBubbleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 160.0f*kScreenPointScale)];
    [self.bubbleView setClipsToBounds:YES];
    [self.bubbleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:self.bubbleView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.bounds)-30, CGRectGetWidth(self.bounds)-80.0f, 30.0f)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self addSubview:self.titleLabel];
    
    
    self.bearImage = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"bear"]];
    [self.bearImage setFrame:CGRectMake(10, 10, 17, 19)];
    self.bearImage.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bearImage];
    
    self.graspView = [[HSGraspProgress alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-70.0f, CGRectGetHeight(self.bounds)-30.0f, 30.0f, 30.0f)];
    [self.graspView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    
    self.graspStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bounds)-40.0f, 0, 35, 15)];
    [self.graspStateLabel setCenter:CGPointMake(CGRectGetMidX(self.graspStateLabel.frame), CGRectGetMidY(self.graspView.frame))];
    [self.graspStateLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.graspStateLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [self.graspStateLabel setTextColor:[UIColor lightGrayColor]];
   
    
    self.lectureNewFlag = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-30.0f, 0, 30, 30.0f)];
    [self.lectureNewFlag setImage:[UIImage imageNamed:@"u97"]];
    [self.lectureNewFlag setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self addSubview:self.lectureNewFlag];
    
    
    float i = 30.0f*itemCellScale;
    float j = 30.0f*itemCellScale;
    
    self.isHotImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-i, 0, i, i)];
    [self.isHotImage setImage:[UIImage imageNamed:@"hot"]];
    [self.isHotImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self addSubview:self.isHotImage];
    
    self.isNewImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-i-j, 0,j, j)];
    [self.isNewImage setImage:[UIImage imageNamed:@"new1"]];
    [self.isNewImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self addSubview:self.isNewImage];
    
    self.singleTap = [[UITapGestureRecognizer alloc] init];
    [self.singleTap setNumberOfTapsRequired:1];
    [self.singleTap setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:self.singleTap];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (!self.isHide) {
        [self addSubview:self.graspView];
        [self addSubview:self.graspStateLabel];
        [self.bearImage removeFromSuperview];
    }
    
}

- (void)updateCellWith:(HSLectureModel *)lectureModel
{
    self.lectureModel = lectureModel;
    

//    [self setImageViewIsNew:lectureModel.isNew isHot:lectureModel.isHot];
    
    [self.lectureNewFlag setHidden:!self.lectureModel.isNew];
    [self.bubbleView updateImageWithUrl:self.lectureModel.lectureImageUrl];
    
    [self.titleLabel setText:lectureModel.lectureName];
    [self.graspView setGraspState:self.lectureModel.graspState];
    
    self.isNew = lectureModel.isNew;
    self.isHot = lectureModel.isHot;
    [self setImageViewIsNew:self.isNew isHot:self.isHot];
    
    NSArray *graspStateTitles = @[@"未掌握",@"掌握中",@"已掌握"];
    [self.graspStateLabel setText:graspStateTitles[self.lectureModel.graspState]];
}


-(void)setImageViewIsNew:(BOOL)isNew isHot:(BOOL)isHot{
    float i = 30.0f*itemCellScale;
    float j = 30.0f*itemCellScale;
    self.isNewImage.hidden = YES;
    self.isHotImage.hidden = YES;
    self.isNewImage.hidden = !isNew;
    self.isHotImage.hidden = !isHot;
    if (!isHot && isNew) {
        self.isNewImage.frame = self.isHotImage.frame;
    }else {
        self.isNewImage.frame = CGRectMake(CGRectGetWidth(self.bounds)-i-j, 0,j, j);
    }
}

@end
