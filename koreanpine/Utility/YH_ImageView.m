//
//  YH_ImageView.m
//  YH_Mall
//
//  Created by 葛祥通 on 14-9-26.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import "YH_ImageView.h"

@implementation NSString (ImageURL)

@end

@implementation YH_ImageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
        
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beenTapped:)];
        gr.cancelsTouchesInView = NO;
        [self addGestureRecognizer:gr];
    }
    return self;
}

//响应点击事件
- (void)beenTapped:(UIGestureRecognizer *)gesture
{
    if (self.imageBlock) {
        self.imageBlock();
    }
    
}

- (id)initWithFrame:(CGRect)frame placeHolderImageName:(NSString *)imageName
{
    self = [self initWithFrame:frame];
    if (self != nil) {
        self.exclusiveTouch = YES;
        self.placeHolderImageName = imageName;
        UIImage *image = [UIImage imageNamed:self.placeHolderImageName];
        self.image = image;
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beenTapped:)];
        gr.cancelsTouchesInView = NO;
        [self addGestureRecognizer:gr];
    }
    return self;
}


+ (id)imageViewWithFrame:(CGRect)frame placeHolderImageName:(NSString *)imageName
{
    return [[self alloc] initWithFrame:frame placeHolderImageName:imageName];
}

- (void)updateViewWithImageAtURL:(NSString *)urlString
{
    [self updateViewWithImageAtURL:urlString finishBlock:nil transPath:YES LoadAnimation:YES];
}

- (void)updateViewWithImageAtURL:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock
{
    [self updateViewWithImageAtURL:urlString finishBlock:finishBlock transPath:YES LoadAnimation:YES];
}


- (void)updateViewWithImageAtURL:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock transPath:(BOOL)transPath
{
    [self updateViewWithImageAtURL:urlString finishBlock:nil transPath:transPath LoadAnimation:YES];
}


- (void)updateViewWithImageAtURL:(NSString *)urlString LoadAnimation:(BOOL)loadAnimation
{
    [self updateViewWithImageAtURL:urlString LoadAnimation:loadAnimation  finishBlock:nil];
}


- (void)updateViewWithImageAtURL:(NSString *)urlString LoadAnimation:(BOOL)loadAnimation finishBlock:(dispatch_block_t)finishBlock
{
    [self updateViewWithImageAtURL:urlString finishBlock:finishBlock transPath:YES LoadAnimation:loadAnimation];
}

- (void)updateViewWithImageAtURL:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock transPath:(BOOL)transPath LoadAnimation:(BOOL)loadAnimation
{
    if ([urlString length] == 0) {
        [self updateViewWithImage:nil];
        return;
    }

    [super updateViewWithImageAtURLNormal:urlString finishBlock:finishBlock LoadAnimation:loadAnimation placeholderImage:nil];
    
}

- (void)updateViewWithImage:(UIImage *)image
{
    if (image == nil) {
        if ([self.placeHolderImageName length] > 0) {
            self.image = [UIImage imageNamed:self.placeHolderImageName];
        }
        else {
            self.image = self.placeHolderImage;
        }
        return;
    }
}
- (void)setImageUrl:(NSString *)urlString {
    
}

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder {
    
}

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder animated:(BOOL)animated {
    
}

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    
}

- (void)setImageUrl:(NSString *)urlString completed:(SDWebImageCompletionBlock)completedBlock {
    
}

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    
}

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    
}

- (void)setImageUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    
}
-(NSURL*)getImageURLWithMode:(NSString*)urlString {
    return [NSURL URLWithString:urlString];
}
@end
