//
//  HSTabbar.m
//  koreanpine
//
//  Created by Christ on 15/7/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSTabbar.h"
#import "HSTabbarBtn.h"

@interface HSTabbar ()

@property (strong, nonatomic) NSMutableArray *btnArr;

@end

@implementation HSTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArr = [NSMutableArray array];
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self setBackgroundColor:[UIColor blackColor]];
//    NSArray *tabbarImageNameArr = @[@"home_n",@"vocational_school_n",@"practice_n",@"my_n"];
//    NSArray *tabbarHighLightImageNameArr = @[@"home_p",@"vocational_school_p",@"practice_p",@"my_p"];
//    NSArray *tabbarTitleArr = @[@"首页",@"课程",@"练习",@"我的"];
    NSArray *tabbarImageNameArr = @[@"vocational_school_n",@"practice_n",@"my_n"];
    NSArray *tabbarHighLightImageNameArr = @[@"vocational_school_p",@"practice_p",@"my_p"];
    NSArray *tabbarTitleArr = @[@"课程",@"练习",@"我的"];
    
    CGFloat btnWidth = CGRectGetWidth(self.bounds)/tabbarImageNameArr.count;
    for (int row = 0; row < tabbarImageNameArr.count; row ++) {
        HSTabbarBtn *tabbarBtn = [[HSTabbarBtn alloc] initWithFrame:CGRectMake(btnWidth*row, 0, btnWidth, CGRectGetHeight(self.bounds))];
        [tabbarBtn addTarget:self action:@selector(tabbarBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarBtn.barImage setImage:[UIImage imageNamed:tabbarImageNameArr[row]]];
        [tabbarBtn.barImage setHighlightedImage:[UIImage imageNamed:tabbarHighLightImageNameArr[row]]];
        [tabbarBtn.barTitleLabel setText:tabbarTitleArr[row]];
        [self addSubview:tabbarBtn];
        [self.btnArr addObject:tabbarBtn];
    }
    
    [self setSelectedIndex:0 animated:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)tabbarBtnTapped:(UIButton *)btn
{
    NSUInteger btnIndex = [self.btnArr indexOfObject:btn];
    if ([self.delegate respondsToSelector:@selector(tabbar:didSelectedIndex:)]){
        [self.delegate tabbar:self didSelectedIndex:btnIndex];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:YES];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)self.btnArr[selectedIndex];
    for (HSTabbarBtn *tabbarBtn in self.btnArr) {
        [tabbarBtn setSelected:[btn isEqual:tabbarBtn] animated:animated];
    }
}


@end
