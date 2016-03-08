//
//  HSHomeSectionHeader.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSHomeSectionHeader.h"

@interface HSHomeSectionHeader ()

@property (strong ,nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation HSHomeSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
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
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, CGRectGetHeight(self.contentView.bounds))];
    [self.imageView setCenter:CGPointMake(CGRectGetWidth(self.imageView.bounds)/2, CGRectGetMidY(self.contentView.bounds))];
    [self.imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, (CGRectGetHeight(self.contentView.bounds)-26)/2, 250, 26)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.contentView addSubview:self.titleLabel];
}

- (void)updateSectionHeaderWith:(HSHomeSectionTitle *)homeSectionTitle
{
    [self.imageView setImage:[UIImage imageNamed:homeSectionTitle.imageName]];
    [self.titleLabel setText:homeSectionTitle.title];
}

@end
