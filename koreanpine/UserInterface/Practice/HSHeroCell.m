//
//  HSHeroCell.m
//  koreanpine
//
//  Created by Victor on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSHeroCell.h"
#import "HSHeroModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+WTXM.h"
@interface HSHeroCell ()
//排名图片
@property (nonatomic,strong) UIImageView *placeView;
@property (nonatomic,strong) UILabel *placeLabel;
//头像
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,copy) NSString *iconUrl;
//名字
@property (nonatomic,strong) UILabel *nameLabel;
//主题
@property (nonatomic,strong) UILabel *bigLabel;
//副标题
@property (nonatomic,strong) UILabel *smallLabel;

@end
@implementation HSHeroCell

#pragma mark -共有方法
- (void)setHeroModel:(HSHeroModel *)heroModel {
    _heroModel = heroModel;
    self.placeView.image = nil;
    switch (self.placeNum) {
        case 0:
            self.placeView.hidden = NO;
            self.placeView.image = [UIImage imageNamed:@"top1"];
            break;
        case 1:
            self.placeView.hidden = NO;
            self.placeView.image = [UIImage imageNamed:@"top2"];
            break;
        case 2:
            self.placeView.hidden = NO;
            self.placeView.image = [UIImage imageNamed:@"top3"];
            break;
        default:
            self.placeView.image = nil;
            break;
    }
    self.placeLabel.text = [NSString stringWithFormat:@"%d",self.placeNum+1];
    
    self.iconUrl = [HSImgBaseURL stringByAppendingPathComponent:heroModel.picPath];
     [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.iconUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nameLabel.text = heroModel.userName;
    CGFloat rightNum = [heroModel.rightNum floatValue];
    CGFloat totalNum = [heroModel.totalNum floatValue];
    CGFloat ratio = rightNum/totalNum;
    if ([self.sortType isEqualToString:@"totalNum"]) {
        NSString * totalNum = nil;
        NSRange range;
        if ([heroModel.totalNum integerValue]/10000 > 0) {
            totalNum = [NSString stringWithFormat:@"%.1f万题",(CGFloat)[heroModel.totalNum integerValue]/10000.0];
            range = [totalNum rangeOfString:@"万题"];
        } else {
           totalNum = [NSString stringWithFormat:@"%@题",heroModel.totalNum];
            range = [totalNum rangeOfString:@"题"];
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:totalNum];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
        self.bigLabel.attributedText = attrStr;
        self.smallLabel.text = [NSString stringWithFormat:@"%d%%",(int)(ratio*100)];

    }else if ([self.sortType isEqualToString:@"rightRate"]) {
        self.bigLabel.text = [NSString stringWithFormat:@"%d%%",(int)(ratio*100)];
        NSString * totalNum = nil;
        if ([heroModel.totalNum integerValue]/10000 > 0) {
            totalNum = [NSString stringWithFormat:@"%.1f万题",(CGFloat)[heroModel.totalNum integerValue]/10000.0];
        } else {
            totalNum = [NSString stringWithFormat:@"%@题",heroModel.totalNum];
        }
        self.smallLabel.text = [NSString stringWithFormat:@"%@",totalNum];
    }
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier placeNum:(NSInteger)placeNum {
   self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.placeView = [[UIImageView alloc] init];
        self.placeLabel = [[UILabel alloc] init];
        self.placeLabel.textColor = [UIColor lightGrayColor];
        self.placeLabel.textAlignment = NSTextAlignmentCenter;
        [self.placeView addSubview:self.placeLabel];
        [self.contentView addSubview:self.placeView];
        
        self.iconView = [[UIImageView alloc] init];
        self.iconView.layer.cornerRadius = 25;
        self.iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconView];
        
        self.bigLabel = [[UILabel alloc] init];
        self.bigLabel.font = [UIFont systemFontOfSize:18];
        self.bigLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.bigLabel];
        self.smallLabel = [[UILabel alloc] init];
        self.smallLabel.textColor = [UIColor lightGrayColor];
        self.smallLabel.font = [UIFont systemFontOfSize:15];
        self.smallLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.smallLabel];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.nameLabel];
        self.placeNum = placeNum;
    }
    return self;
}
- (void)awakeFromNib {
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeView.frame = CGRectMake(10, 0, 24, 24);
     self.placeView.centerY = self.contentView.hei*0.5;
    self.placeLabel.frame = CGRectMake(0, 0, 24, 20);
    self.iconView.frame = CGRectMake(CGRectGetMaxX(self.placeView.frame)+8, (CGRectGetHeight(self.contentView.frame)-50)*0.5, 50, 50);
    self.bigLabel.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)-10-80,8, 80, (CGRectGetHeight(self.contentView.frame)-16)/1.5);
    self.smallLabel.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)-10-80,CGRectGetMaxY(self.bigLabel.frame), 80, CGRectGetHeight(self.bigLabel.frame)*0.5);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame) +8, 0, self.bigLabel.x - (CGRectGetMaxX(self.iconView.frame) +8), CGRectGetHeight(self.contentView.frame));
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -代理方法||数据源方法

#pragma mark -私有方法

#pragma  mark -懒加载


@end
