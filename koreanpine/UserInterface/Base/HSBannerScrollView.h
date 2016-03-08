//
//  YH_BannerScrollView.h
//  YH_Mall
//
//  Created by Cloud on 15/2/3.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPageControl.h"

@class HSBannerScrollView;

@protocol YH_BannerScrollViewDelegate <NSObject>

@optional
- (void)bannerScrollView:(HSBannerScrollView *)bannerScrollView didSelectBannerAtIndex:(NSInteger)index;

- (void)bannerScrollView:(HSBannerScrollView *)bannerScrollView didLoadImage:(UIImage *)image atIndex:(NSInteger)index;

@end


@protocol YH_BannerScrollViewDataSource <NSObject>

@required

- (NSInteger)numberOfBannersInBannerScrollView:(HSBannerScrollView *)bannerScrollView;

- (NSString *)bannerScrollView:(HSBannerScrollView *)bannerScrollView bannerImageURLAtIndex:(NSInteger)index;

@optional

- (UIImage *)bannerScrollView:(HSBannerScrollView *)bannerScrollView customPlaceHolderImageAtIndex:(NSInteger)index;

@end

#pragma mark - Interface
@interface HSBannerScrollView : UIView

@property (assign, nonatomic) BOOL enableAutoScroll;

@property (assign, nonatomic) BOOL isStoped;

@property (assign, nonatomic) NSTimeInterval autoScrollInterval;

@property (weak, nonatomic) id<YH_BannerScrollViewDelegate> bannerDelegate;

@property (weak, nonatomic) id<YH_BannerScrollViewDataSource> bannerDataSource;

- (instancetype)initWithFrame:(CGRect)frame isEnableAutoScroll:(BOOL)autoScroll;

- (void)setPageControlHidden:(BOOL)isHidden;

- (void)reloadBannerView;

- (void)startAutoScroll;

- (void)stopAutoScroll;

@end
