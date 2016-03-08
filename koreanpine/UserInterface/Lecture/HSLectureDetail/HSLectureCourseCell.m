//
//  HSLectureCourseCell.m
//  koreanpine
//
//  Created by Christ on 15/8/4.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureCourseCell.h"

@implementation HSLectureCourseCell

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
}

- (void)prepareForReuse
{
    [self.isNewFlag setHidden:YES];
    [self.graspStateView setHidden:YES];
}

- (void)setCurrentSelected:(BOOL)currentSelected
{
    _currentSelected = currentSelected;
    UIColor *bgColor = currentSelected?[UIColor colorWithRed:130.0f/255.0f green:188.0f/255.0f blue:255.0f/255.0f alpha:1.0]:[UIColor clearColor];
    [self.contentView setBackgroundColor:bgColor];
    [self.graspStateView setSelected:currentSelected animated:NO];
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.courseTypeFlag = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 21, 21)];
    [self.courseTypeFlag setCenter:CGPointMake(CGRectGetMidX(self.courseTypeFlag.frame), CGRectGetMidY(self.contentView.bounds))];
    [self.courseTypeFlag setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.contentView addSubview:self.courseTypeFlag];
    
    self.isNewFlag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    [self.isNewFlag setContentMode:UIViewContentModeScaleAspectFit];
    [self.isNewFlag setImage:[UIImage imageNamed:@"new"]];
    [self.isNewFlag setHidden:YES];
    [self.contentView addSubview:self.isNewFlag];
    
    CGFloat leftX = CGRectGetMaxX(self.courseTypeFlag.frame)+5;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftX, 0, CGRectGetWidth(self.contentView.frame)-(leftX+5), 40.0f)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.contentView addSubview:self.titleLabel];
    
    self.graspStateView = [[HSGraspProgress alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds)-40.0f, 0, 30.0f, 30.0f)];
    [self.graspStateView setCenter:CGPointMake(CGRectGetMidX(self.graspStateView.frame), CGRectGetMidY(self.contentView.bounds))];
    [self.graspStateView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.graspStateView setHidden:YES];
    [self.contentView addSubview:self.graspStateView];
    
}

- (void)updateCellWithLectureClass:(HSLectureClassModel *)lectureClassModel
{
    self.lectureClassModel = lectureClassModel;
    
    NSString *courseTypeFlagName = (self.lectureClassModel.lectureClassType == HSLectureClassTypeClass)?@"播放":@"课程";
    [self.courseTypeFlag setImage:[UIImage imageNamed:courseTypeFlagName]];
    [self.titleLabel setText:lectureClassModel.name];
    

    CGRect textRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(150.0f*kScreenPointScale, 25.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:NULL];
    [self.titleLabel setFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame),ceilf(textRect.size.width), CGRectGetHeight(self.titleLabel.frame))];

    if (lectureClassModel.lectureClassType == HSLectureClassTypeClass) {
        if (lectureClassModel.isNew) {
            [self.isNewFlag setHidden:NO];
            [self.isNewFlag setCenter:CGPointMake(CGRectGetMaxX(self.titleLabel.frame)+CGRectGetMidX(self.isNewFlag.bounds), 18-CGRectGetMidY(self.isNewFlag.bounds))];
        }
    }
    
    if (lectureClassModel.lectureClassType == HSLectureClassTypePractice) {
        [self.graspStateView setHidden:NO];
        HSLectureHomeworkModel *homeworkVM = (HSLectureHomeworkModel *)lectureClassModel;
        [self.graspStateView setGraspState:homeworkVM.graspState];
    }
    
}

@end
