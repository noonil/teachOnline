//
//  HSLectureItemCell.m
//  koreanpine
//
//  Created by Christ on 15/7/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureItemCell.h"
#import "UIImageView+WebCache.h"
#import "HSRuntimeMgr.h"
#import "Common.h"
#define itemCellScale 145/155

@implementation HSLectureItemCell

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

- (void)prepareForReuse
{
    [self.lectureNewFlag setHidden:YES];
}

- (void)initView
{
    
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    self.lectureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), 86*itemCellScale*kScreenPointScale)];
    [self.lectureImageView setClipsToBounds:YES];
    [self.lectureImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.lectureImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.contentView addSubview:self.lectureImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 86.0f*itemCellScale*kScreenPointScale, CGRectGetWidth(self.contentView.bounds)-10, 40.0f*itemCellScale)];
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    if (kScreenPointScale == 1) {
         [self.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    }else if(kScreenPointScale == 414/320){
        [self.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    }
 
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.contentView addSubview:self.titleLabel];

    self.bearImage = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"bear"]];
    [self.bearImage setFrame:CGRectMake(10, 10, 17*itemCellScale, 19*itemCellScale)];
    self.bearImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.bearImage];
    
    self.graspView = [[HSGraspProgress alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(self.contentView.bounds)-20.0f*itemCellScale, 20.0f*itemCellScale, 20.0f*itemCellScale)];
    [self.graspView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];

   
    
    self.graspStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.graspView.frame), 0, 80*itemCellScale, 15*itemCellScale)];
    [self.graspStateLabel setCenter:CGPointMake(CGRectGetMidX(self.graspStateLabel.frame), CGRectGetMidY(self.graspView.frame))];
    [self.graspStateLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    [self.graspStateLabel setFont:[UIFont systemFontOfSize:11.0f]];
    if (kScreenPointScale == 1) {
        [self.graspStateLabel setFont:[UIFont systemFontOfSize:8.0f]];
    }
    
    [self.graspStateLabel setTextColor:[UIColor lightGrayColor]];
    
    
 
    
//    self.lectureNewFlag = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds)-30.0f, 0, 20*itemCellScale, 22*itemCellScale)];
//    [self.lectureNewFlag setImage:[UIImage imageNamed:@"u97"]];
//    [self.lectureNewFlag setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
//    [self.contentView addSubview:self.lectureNewFlag];

    float i = 30.0f*itemCellScale;
    float j = 30.0f*itemCellScale;
    
    self.isHotImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds)-i, 0, i, i)];
    [self.isHotImage setImage:[UIImage imageNamed:@"hot"]];
    [self.isHotImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    self.isHotImage.hidden = YES;
    [self.contentView addSubview:self.isHotImage];
    
    self.isNewImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds)-i-j, 0,j, j)];
    [self.isNewImage setImage:[UIImage imageNamed:@"new1"]];
    [self.isNewImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    self.isNewImage.hidden = YES;
    [self.contentView addSubview:self.isNewImage];
    
//    self.isNewImage_2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds)-i, 0,j, j)];
//    [self.isNewImage_2 setImage:[UIImage imageNamed:@"new1"]];
//    [self.isNewImage_2 setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
//    self.isNewImage_2.hidden = YES;
//    [self.contentView addSubview:self.isNewImage_2];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];

//    NSLog(@"%d,%d",self.isNew,self.isHot);
    if (!self.isHide) {
        [self.contentView addSubview:self.graspView];
        [self.contentView addSubview:self.graspStateLabel];
        [self.bearImage removeFromSuperview];
    }
    
    
}
- (void)updateCellWith:(HSLectureModel *)lectureModel
{
    self.lectureModel = lectureModel;
//    [self.lectureNewFlag setHidden:!self.lectureModel.isNew];
    if (lectureModel == nil) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.lectureImageView sd_setImageWithURL:[NSURL URLWithString:self.lectureModel.lectureImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSString *imageSizeKey = [Common MD5FromString:imageURL.absoluteString];
        NSValue *imageSizeValue = [HSRuntimeMgr runtimeMgr].imageSizeDict[imageSizeKey];
        if (imageSizeValue) { return; }
        
        imageSizeValue = [NSValue valueWithCGSize:image.size];
        if (imageSizeValue&&imageSizeKey) {
            [[HSRuntimeMgr runtimeMgr].imageSizeDict setObject:imageSizeValue forKey:imageSizeKey];
            if ([weakSelf.delegate respondsToSelector:@selector(lectureItemCellDidFinishLoadImage:)]) {
                [weakSelf.delegate lectureItemCellDidFinishLoadImage:weakSelf];
            }
        }
    }];
    
    [self.titleLabel setText:lectureModel.lectureName];
    [self.graspView setGraspState:self.lectureModel.graspState];
    self.isNew = lectureModel.isNew;
    self.isHot = lectureModel.isHot;
//    if (self.isNew && !self.isHot) {
//      self.isNewImage_2.hidden = NO;
//    }else{
        [self setImageViewIsNew:self.isNew isHot:self.isHot];
//    }
    
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
        self.isNewImage.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds)-i-j, 0,j, j);
    }
//    if (isNew && (!isHot)) {
//        self.isNewImage.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds)-30.0f*itemCellScale, 0,30.0f*itemCellScale, 30.0f*itemCellScale);
//    }
   
    
}
-(void)setImageViewIsNew{
    
}
+ (CGSize)cellSizeWith:(HSLectureModel *)lectureModel
{
    CGFloat cellHeight = 45.5f+85.5*kScreenPointScale;
    CGFloat cellWidth = 152.0f*kScreenPointScale;
    
//    NSString *imageSizeKey = [Common MD5FromString:lectureModel.lectureImageUrl];
//    NSValue *imageSizeValue = [HSRuntimeMgr runtimeMgr].imageSizeDict[imageSizeKey];
//    if (imageSizeValue) {
//        CGSize imageSize = [imageSizeValue CGSizeValue];
//        CGFloat imageHeight = imageSize.height*cellWidth/imageSize.height;
//        cellHeight += imageHeight;
//    } else {
//        cellHeight += cellWidth*9/16;
//    }
    return CGSizeMake(cellWidth, cellHeight);
}

@end
