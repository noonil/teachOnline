//
//  HSHomeInfoCell.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSHomeInfoCell.h"

@interface HSHomeInfoCell ()

@property (strong ,nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation HSHomeInfoCell

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
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initView
{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.iconImageView setCenter:CGPointMake(15+CGRectGetWidth(self.iconImageView.bounds)/2, CGRectGetMidY(self.contentView.bounds))];
    [self.iconImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, (CGRectGetHeight(self.contentView.bounds)-26)/2, 250, 26)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.contentView addSubview:self.titleLabel];
}

- (void)updateCellWith:(HSHomeCellInfo *)homeCellInfo
{
    [self.iconImageView setImage:[UIImage imageNamed:homeCellInfo.imageName]];
    [self.iconImageView setHighlightedImage:[UIImage imageNamed:homeCellInfo.highlightImageName]];
    [self.iconImageView setHighlighted:homeCellInfo.shouldHighlight];
    [self.titleLabel setText:homeCellInfo.title];
}

@end
