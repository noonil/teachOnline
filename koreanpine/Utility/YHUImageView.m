//
//  YHUImageView.m
//  YOHOBuy
//
//  Created by Caoliu on 14/12/17.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import "YHUImageView.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"


@implementation YHUImageView
- (void)updateViewWithImageAtURLNormal:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock LoadAnimation:(BOOL)loadAnimation
{
    [self updateViewWithImageAtURLAtNormal:urlString finishBlock:finishBlock LoadAnimation:loadAnimation];
}
- (void)updateViewWithImageAtURLNormal:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock LoadAnimation:(BOOL)loadAnimation  placeholderImage:(UIImage*)placeholderImage
{
    [self updateViewWithImageAtURLAtNormal:urlString finishBlock:finishBlock LoadAnimation:loadAnimation  placeholderImage:placeholderImage] ;
}


- (void)updateViewWithImageAtURLAtNormal:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock LoadAnimation:(BOOL)loadAnimation
{
    [self updateViewWithImageAtURLAtNormal:urlString finishBlock:finishBlock LoadAnimation:loadAnimation placeholderImage:nil];
    
}
- (void)updateViewWithImageAtURLAtNormal:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock LoadAnimation:(BOOL)loadAnimation placeholderImage:(UIImage*)placeholderImage
{
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]
            placeholderImage: placeholderImage
                     options:(SDWebImageRetryFailed| SDWebImageLowPriority)
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       
                                              if ( cacheType != SDImageCacheTypeMemory) {
                       if (loadAnimation) { [weakSelf addImageAnimation]; }
                       
                                              }
                       if (finishBlock != nil) {
                           dispatch_async(dispatch_get_main_queue(), ^(void) {
                               finishBlock();
                           });
                       }
                       
                   }];
}


- (void)addImageAnimation
{
    self.alpha = 0.f;
    CABasicAnimation *animationOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationOpacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationOpacity.fromValue = @0.f;
    animationOpacity.toValue = @1.f;
    animationOpacity.duration = 0.6f;
    [self.layer addAnimation:animationOpacity forKey:@"OpacityAnimation"];
    self.alpha = 1.f;
}


@end
