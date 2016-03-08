//
//  YH_BannerScrollView.m
//  YH_Mall
//
//  Created by Cloud on 15/2/3.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import "HSBannerScrollView.h"
#import "YH_ImageView.h"
#import "SMPageControl.h"

static CGFloat const kPageControlHeightDefaultValue = 15.0f;
static CGFloat const kAutoScrollIntervalDefaultValue = 3.0f;
static NSInteger const kFristIndex = 1;
static NSInteger const kExtraBannerCount = 2; //滚动多加的试图

@interface HSBannerScrollView ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSTimer *autoScrollTimer;

@property (strong, nonatomic) NSMutableArray *bannerDataList;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) SMPageControl *mainPageControl;

@property (assign, nonatomic) NSInteger currentIndex;

@property (assign, nonatomic) CGFloat lastOffsetX;

@property (assign, nonatomic) BOOL isScrolling;

@end

@implementation HSBannerScrollView

#pragma mark - Init
- (NSMutableArray *)bannerDataList
{
    if (!_bannerDataList) {
        _bannerDataList = [NSMutableArray array];
    }
    return _bannerDataList;
}
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_mainScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.decelerationRate = 0.1f;
        _mainScrollView.scrollsToTop = NO;
        [self addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (SMPageControl *)mainPageControl
{
    if(!_mainPageControl){
        _mainPageControl = [[SMPageControl alloc] init];
//        _mainPageControl.backgroundColor = [UIColor colorWithHexString:@"808080"];        _mainPageControl.currentPage = 0;
//        _mainPageControl.alpha = 0.5;
//        _mainPageControl.imageNormal = [UIImage imageNamed:@"currentPageDot"];
//        _mainPageControl.imageSelected = [UIImage imageNamed:@"pageDot"];
        _mainPageControl.indicatorMargin = 5.0f;
        _mainPageControl.indicatorDiameter = 5.0f;
        _mainPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _mainPageControl.pageIndicatorTintColor = [UIColor grayColor];
        _mainPageControl.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainPageControl];
    }
    return _mainPageControl;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _autoScrollInterval = 0.0f;
        _enableAutoScroll = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _autoScrollInterval = 0.0f;
        _enableAutoScroll = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame isEnableAutoScroll:(BOOL)autoScroll
{
    self = [super initWithFrame:frame];
    if (self) {
        _autoScrollInterval = 0.0f;
        _enableAutoScroll = autoScroll;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat scrollWidth = CGRectGetWidth(self.mainScrollView.bounds);
    CGFloat scrollHeight = CGRectGetHeight(self.mainScrollView.bounds);
    for (NSInteger row = 0;row<self.mainScrollView.subviews.count ; row++) {
        YH_ImageView *imageView = self.mainScrollView.subviews[row];
        [imageView setFrame:CGRectMake(row*CGRectGetWidth(self.mainScrollView.frame), 0, scrollWidth, scrollHeight)];
    }
    
    self.mainScrollView.contentSize = CGSizeMake([self.bannerDataList count] * scrollWidth, CGRectGetHeight(self.bounds));
    [self.mainScrollView setContentOffset:CGPointMake(scrollWidth, 0)];
    self.lastOffsetX = scrollWidth;
    
    //setup pagecontroll
    self.mainPageControl.frame = CGRectMake(0, scrollHeight-kPageControlHeightDefaultValue, scrollWidth, kPageControlHeightDefaultValue);
}

- (void)setPageControlHidden:(BOOL)isHidden
{
    self.mainPageControl.hidden = isHidden;
}
#pragma mark - Set
- (void)setEnableAutoScroll:(BOOL)enableAutoScroll
{
    _enableAutoScroll = enableAutoScroll;
}

- (void)setAutoScrollInterval:(NSTimeInterval)autoScrollInterval
{
    _autoScrollInterval = autoScrollInterval;
}

#pragma mark - Get

- (NSInteger)allBannerCount
{
    return [self.bannerDataSource numberOfBannersInBannerScrollView:self];
}

- (void)recombineData
{
    [self.bannerDataList removeAllObjects];
    for (NSInteger i = 0; i < [self allBannerCount]; i++) {
        [self.bannerDataList addObject:[self.bannerDataSource bannerScrollView:self bannerImageURLAtIndex:i]];
    }
    [self.bannerDataList insertObject:[self.bannerDataSource bannerScrollView:self bannerImageURLAtIndex:[self allBannerCount]-1] atIndex:0];
    [self.bannerDataList addObject:[self.bannerDataSource bannerScrollView:self bannerImageURLAtIndex:0]];
    self.isScrolling = NO;
    self.currentIndex = kFristIndex;
}


- (void)reloadBannerView
{
//    [self.mainScrollView removeAllSubviews];
    if ([self allBannerCount] == 0){
        return;
    }
    [self recombineData];
    
//    NSString *width = [NSString stringWithFormat:@"%.0f",CGRectGetWidth(self.bounds)];
//    NSString *heigth = [NSString stringWithFormat:@"%.0f",CGRectGetHeight(self.bounds)];
    CGFloat scrollWidth = CGRectGetWidth(self.mainScrollView.bounds);
    CGFloat scrollHeight = CGRectGetHeight(self.mainScrollView.bounds);

    //add imageview
    NSInteger actualImageCount = [self.bannerDataList count];

    for(NSInteger i = 0; i < actualImageCount; i++){
        YH_ImageView *bannerImageView = [[YH_ImageView alloc] initWithFrame:CGRectMake(scrollWidth*i, 0, scrollWidth, scrollHeight)];
        bannerImageView.userInteractionEnabled = YES;
        __weak typeof(self) weakSelf = self;
        bannerImageView.imageBlock = ^{
            if (!weakSelf.isScrolling) {
                [weakSelf selectBannerAtIndex:weakSelf.mainPageControl.currentPage];
            }
        };
        NSString *urlString = [self.bannerDataList objectAtIndex:i];
        UIImage *placeHolderImage = nil;
        if ([self.bannerDataSource respondsToSelector:@selector(bannerScrollView:customPlaceHolderImageAtIndex:)]) {
//            NSUInteger imageIndex = i;
//            if (i==0) {
//                imageIndex = [self allBannerCount] -1;
//            }
//            if (i == ([self.bannerDataList count] - kFristIndex)) {
//                imageIndex = 0;
//            }
            placeHolderImage = [self.bannerDataSource bannerScrollView:self customPlaceHolderImageAtIndex:i];
        }
        if (!placeHolderImage) {
            placeHolderImage = [UIImage imageNamed:@"homeTop_banner"];
        }
    
        [bannerImageView setImageUrl:urlString placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if ([self.bannerDelegate respondsToSelector:@selector(bannerScrollView:didLoadImage:atIndex:)]) {
                [self.bannerDelegate bannerScrollView:self didLoadImage:image atIndex:i];
            }
        }];
        bannerImageView.contentMode = UIViewContentModeScaleToFill;
        [self.mainScrollView addSubview:bannerImageView];
        
    }
    self.mainScrollView.scrollEnabled = self.bannerDataList.count > kExtraBannerCount+1;
    self.mainScrollView.contentSize = CGSizeMake([self.bannerDataList count] * scrollWidth, CGRectGetHeight(self.bounds));
    [self.mainScrollView setContentOffset:CGPointMake(scrollWidth, 0)];
    self.lastOffsetX = scrollWidth;
    
    //setup pagecontroll
    self.mainPageControl.frame = CGRectMake(0, scrollHeight-kPageControlHeightDefaultValue, scrollWidth, kPageControlHeightDefaultValue);
    self.mainPageControl.numberOfPages = actualImageCount - kExtraBannerCount;
    self.mainPageControl.currentPage = 0;
    
    _autoScrollInterval = (0 == _autoScrollInterval)? kAutoScrollIntervalDefaultValue:_autoScrollInterval;
    if (_enableAutoScroll && self.bannerDataList.count > 1) {
        [self startAutoScroll];
    }

}

- (void)selectBannerAtIndex:(NSInteger)index
{
    if ([self.bannerDelegate respondsToSelector:@selector(bannerScrollView:didSelectBannerAtIndex:)]) {
        [self.bannerDelegate bannerScrollView:self didSelectBannerAtIndex:index];
    }
}

- (NSInteger)calculateCurrentIndex
{
    NSInteger page;
    CGFloat pageWith = CGRectGetWidth(self.mainScrollView.frame);
    if (self.mainScrollView.contentOffset.x>self.lastOffsetX){
        page = floor((self.mainScrollView.contentOffset.x - pageWith) / pageWith)+1;
    }else{
        page = ceil((self.mainScrollView.contentOffset.x + pageWith) / pageWith)-1;
    }
    return page;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    NSInteger page = [self calculateCurrentIndex];
    
    self.currentIndex = page;
    //currentPage 超过范围保存上一次的值
    self.mainPageControl.currentPage = (page - 1);
    CGFloat width = CGRectGetWidth(self.mainScrollView.bounds);
    
    if (self.currentIndex==0) {
        [self.mainScrollView setContentOffset:CGPointMake([self allBannerCount]*width, 0)];
        self.mainPageControl.currentPage = [self allBannerCount] -1;
    }
    if (self.currentIndex == ([self.bannerDataList count] - kFristIndex)) {
        [self.mainScrollView setContentOffset:CGPointMake(width, 0)];
        self.mainPageControl.currentPage = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (self.currentIndex==0) {
        [_scrollView setContentOffset:CGPointMake([self allBannerCount]*CGRectGetWidth(self.mainScrollView.bounds), 0)];
    }
    if (self.currentIndex == ([self.bannerDataList count]- kFristIndex)) {
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.mainScrollView.bounds), 0)];
    }
    self.lastOffsetX = self.mainScrollView.contentOffset.x;
    self.isScrolling = NO;
    [self startAutoScroll];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.lastOffsetX = self.mainScrollView.contentOffset.x;
}

//拖动触发，自动滚动不触发
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isScrolling = YES;
    [self stopAutoScroll];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.isScrolling = YES;
    [self stopAutoScroll];
}


- (void)startAutoScroll
{
    if (!self.enableAutoScroll && self.bannerDataList.count > 0) {
        return;
    }
    if (_autoScrollTimer == nil) {
        _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:kAutoScrollIntervalDefaultValue target:self selector:@selector(scrollBanner) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSDefaultRunLoopMode];
    }
    
    self.isStoped = NO;
}

-(void)stopAutoScroll
{
    [_autoScrollTimer invalidate];
    _autoScrollTimer = nil;
    self.isStoped = YES;
}

-(void)scrollBanner
{
    CGPoint point = self.mainScrollView.contentOffset;
    self.lastOffsetX = self.mainScrollView.contentOffset.x;
    CGFloat width = CGRectGetWidth(self.mainScrollView.bounds);
    NSInteger num = point.x/width;

    if (self.currentIndex == 0) {
        [self.mainScrollView setContentOffset:CGPointMake(([self allBannerCount])*width, 0) animated:YES];
    }else if (self.currentIndex == ([self.bannerDataList count] - kFristIndex)) {
        [self.mainScrollView setContentOffset:CGPointMake(width, 0) animated:YES];
    }else{
        [self.mainScrollView setContentOffset:CGPointMake((num + 1) * width, 0) animated:YES];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        self.mainScrollView.delegate = nil;
        [self stopAutoScroll];
    }
}

- (void)dealloc
{
    self.mainScrollView.delegate = nil;
    [self stopAutoScroll];
}

@end
