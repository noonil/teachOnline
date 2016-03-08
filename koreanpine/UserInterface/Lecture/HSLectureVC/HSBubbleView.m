//
//  HSBubbleView.m
//  YH_BubbleViewTest
//
//  Created by Christ on 15/8/21.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBubbleView.h"
#import "UIImageView+WebCache.h"

@implementation HSBubbleView

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
    [self setClipsToBounds:YES];
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imageView];
}

- (void)updateImageWithUrl:(NSString *)imageUrl
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self updateImageView];
        [self startBubbleAnimation];
    }];
}

- (void)updateImageView
{
    if (self.imageView.image == nil) { return; }
    CGSize imageSize = self.imageView.image.size;
    CGFloat imageRatio = imageSize.width/imageSize.height;
    
    CGFloat viewRation = CGRectGetWidth(self.bounds)/CGRectGetHeight(self.bounds);

    if (imageRatio > viewRation) {
//      图片比视图扁,imageView与view高度一致
        CGFloat imageViewWidth = imageRatio*CGRectGetHeight(self.bounds);
        [self.imageView setFrame:CGRectMake(0, 0, imageViewWidth, CGRectGetHeight(self.bounds))];
        [self.imageView setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
    } else {
//      图片比视图窄,imageView与view宽度一致
        CGFloat imageViewHeight = CGRectGetWidth(self.bounds)/imageRatio;
        [self.imageView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), imageViewHeight)];
        [self.imageView setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
    }
}

- (void)startBubbleAnimation
{
    
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    pathAnimation.duration = 8.0;
    
    CGFloat velocity = 5.0f;
    CGFloat deltaX = (CGRectGetWidth(self.imageView.bounds)-CGRectGetWidth(self.bounds))/2.0f;
    CGFloat deltaY = (CGRectGetHeight(self.imageView.bounds)-CGRectGetHeight(self.bounds))/2.0f;
    CGFloat xTime = deltaX/velocity;
    CGFloat yTime = deltaY/velocity;
    CGFloat maxTime = MAX(xTime, yTime);
    maxTime = MAX(maxTime, 5.0f);
    pathAnimation.duration = maxTime;
    
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, CGRectGetMidX(self.imageView.frame), CGRectGetMidY(self.imageView.frame));
    CGPathAddLineToPoint(curvedPath, NULL, CGRectGetMidX(self.imageView.frame)-deltaX, CGRectGetMidY(self.imageView.frame)-deltaY);
    CGPathAddLineToPoint(curvedPath, NULL, CGRectGetMidX(self.imageView.frame)+deltaX, CGRectGetMidY(self.imageView.frame)+deltaY);
    CGPathCloseSubpath(curvedPath);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.imageView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
}

@end
