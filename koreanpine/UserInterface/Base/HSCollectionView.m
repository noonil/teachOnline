//
//  YH_CollectionView.m
//  YH_Mall
//
//  Created by Cloud on 15/4/24.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import "HSCollectionView.h"
@implementation HSCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {

    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark -
- (void)addRefreshActionHandler:(void(^)())block
{
    [self addGifHeaderWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    [self customRefreshHeaderView];
}

- (void)addRefresTarget:(id)target action:(SEL)refreshAction
{
    [self addGifHeaderWithRefreshingTarget:target refreshingAction:refreshAction];
    [self customRefreshHeaderView];
}

- (void)addLoadMoreActionHandler:(void(^)())block
{
    [self addLegendFooterWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    self.footer.hidden = YES;
}

- (void)addLoadMoreTarget:(id)target action:(SEL)loadAction
{
    [self addLegendFooterWithRefreshingTarget:target refreshingAction:loadAction];
    self.footer.hidden = YES;
}

- (void)setRefreshHeaderImage
{
    // 设置普通状态的动画图片
    NSString *idleImageName = [NSString stringWithFormat:@"refresh_000"];
    UIImage *idleImage = [UIImage imageNamed:idleImageName];//[[YH_ThemeManager shareInstance] getThemeImage:idleImageName];
    [self.gifHeader setImages:@[idleImage] forState:MJRefreshHeaderStateIdle];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 12; i++) {
        NSString *imageName = [NSString stringWithFormat:@"refresh_%03zd",i];
        UIImage *image = [UIImage imageNamed:imageName];//[[YH_ThemeManager shareInstance] getThemeImage:imageName];
        [refreshingImages addObject:image];
    }
    [self.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
}

- (void)customRefreshHeaderView
{
    return;
    // 隐藏时间
//    self.header.updatedTimeHidden = YES;
    // 隐藏状态
//    self.header.stateHidden = YES;
    
//    [self setRefreshHeaderImage];
}

- (void)customLoadMoreFooterView
{
    
}
@end
