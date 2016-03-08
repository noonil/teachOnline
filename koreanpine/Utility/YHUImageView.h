//
//  YHUImageView.h
//  YOHOBuy
//
//  Created by Caoliu on 14/12/17.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  图片加载时使用的动画，因为不重用与可重用时动画体验不一致，所以使用不同的动画感觉
 */
typedef NS_ENUM(NSUInteger, YHUImageAnimationType){
    /**
     *  正常情况为不重用的方式，如果直接从本地快速下载图片，直接使用淡入的效果
     */
    YHUImageAnimationTypeNormal = 0,
    /**
     *  重用时不管从网络还是从本地重新加载都需要一种交互的体验
     */
    YHUImageAnimationTypeReuseable
};

@interface YHUImageView : UIImageView

@property (strong,nonatomic) UIImageView *placeholderImageView;
@property (strong,nonatomic) UIImage   *placeHolderImage;
@property (assign,nonatomic) YHUImageAnimationType imageAnimationType;

- (void)updateViewWithImageAtURLNormal:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock LoadAnimation:(BOOL)loadAnimation ;
- (void)updateViewWithImageAtURLNormal:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock LoadAnimation:(BOOL)loadAnimation  placeholderImage:(UIImage*)placeholderImage;
@end
