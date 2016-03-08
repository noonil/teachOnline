//
//  HSMineDownloadActionView.m
//  koreanpine
//
//  Created by Christ on 15/8/23.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSMineDownloadActionView.h"

@interface HSMineDownloadActionView ()

@property (strong, nonatomic) NSArray *btnsArr;

@end

@implementation HSMineDownloadActionView

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
    self.backgroundColor = kActionBtnLightColor;
    [self setClipsToBounds:YES];
    
    self.startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70.0f, 35.0f)];
    [self.startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [self.startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.startBtn setBackgroundColor:[UIColor whiteColor]];
    [self.startBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.startBtn.layer setCornerRadius:3.0f];
    [self.startBtn.layer setMasksToBounds:YES];
    [self addSubview:self.startBtn];
    
    self.pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70.0f, 35.0f)];
    [self.pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [self.pauseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.pauseBtn setBackgroundColor:[UIColor whiteColor]];
    [self.pauseBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.pauseBtn.layer setCornerRadius:3.0f];
    [self.pauseBtn.layer setMasksToBounds:YES];
    [self addSubview:self.pauseBtn];
    
    self.removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70.0f, 35.0f)];
    [self.removeBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.removeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.removeBtn setBackgroundColor:[UIColor whiteColor]];
    [self.removeBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.removeBtn.layer setCornerRadius:3.0f];
    [self.removeBtn.layer setMasksToBounds:YES];
    [self addSubview:self.removeBtn];
    
    self.selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70.0f, 35.0f)];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn setTitle:@"取消" forState:UIControlStateSelected];
    [self.selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.selectAllBtn setBackgroundColor:[UIColor whiteColor]];
    [self.selectAllBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.selectAllBtn.layer setCornerRadius:3.0f];
    [self.selectAllBtn.layer setMasksToBounds:YES];
    [self addSubview:self.selectAllBtn];
    
    self.btnsArr = @[self.startBtn,self.pauseBtn,self.removeBtn,self.selectAllBtn];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateActionHeaderView];
}

- (void)updateActionHeaderView
{
   
    CGFloat spacing = 15;
    CGFloat margin = 20;
    CGFloat btnY = (CGRectGetHeight(self.frame)-35)*0.5;
     CGFloat pointGap = (CGRectGetWidth(self.bounds)- 2*margin-(self.btnsArr.count-1)*spacing)/(self.btnsArr.count);
    for (int row = 0; row < self.btnsArr.count; row++) {
        UIButton *btn = (UIButton *)self.btnsArr[row];
        [btn setFrame:CGRectMake(margin+row*(pointGap+spacing), btnY, pointGap, 35)];
//        [btn setCenter:CGPointMake(50+(pointGap)*row, CGRectGetMidY(self.bounds))];
    }
}

@end
