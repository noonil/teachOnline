//
//  YH_ImageView.h
//  YH_Mall
//
//  Created by 葛祥通 on 14-9-26.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHUImageView.h"
#import "UIImageView+WebCache.h"

typedef void(^YH_ImageViewBlock)(void);

@interface YH_ImageView : YHUImageView


@property (nonatomic, copy)  YH_ImageViewBlock imageBlock;

@property (nonatomic, strong) NSString *placeHolderImageName;
@property (nonatomic, strong) UIImage *placeHolderImage;

- (void)setImageUrl:(NSString *)urlString;

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder;

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder animated:(BOOL)animated;

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;

- (void)setImageUrl:(NSString *)urlString completed:(SDWebImageCompletionBlock)completedBlock;

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;


//根据不同的模型获取url，默认不变
-(NSURL*)getImageURLWithMode:(NSString*)urlString;

@property (nonatomic, strong) NSString  *imageCachePath;

- (id)initWithFrame:(CGRect)frame placeHolderImageName:(NSString *)imageName;

+ (id)imageViewWithFrame:(CGRect)frame placeHolderImageName:(NSString *)imageName;

- (void)updateViewWithImage:(UIImage *)image;
- (void)updateViewWithImageAtURL:(NSString *)urlString;
- (void)updateViewWithImageAtURL:(NSString *)urlString LoadAnimation:(BOOL)loadAnimation;
- (void)updateViewWithImageAtURL:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock;
- (void)updateViewWithImageAtURL:(NSString *)urlString LoadAnimation:(BOOL)loadAnimation finishBlock:(dispatch_block_t)finishBlock;


@end
