//
//  YH_AView.m
//  YH_BubbleViewTest
//
//  Created by Christ on 15/8/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSVideoPlayView.h"

@interface HSVideoPlayView ()



@end

@implementation HSVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)initView
{
//    NSString *movieFilePath =  [[ NSBundle mainBundle] pathForResource:@"Movie.m4v" ofType:nil];
//    NSURL *movieUrl = nil;
//   self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
//    self.moviePlayer.shouldAutoplay = NO;
//    [self.moviePlayer setControlStyle:MPMovieControlStyleDefault];
//    self.moviePlayer.scalingMode = MPMovieScalingModeNone;
//    self.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
//    self.moviePlayer.initialPlaybackTime = -1.0;
//    
//    [self.moviePlayer setFullscreen:YES animated:YES];
//    [self addSubview:self.moviePlayer.view];
//    [self.moviePlayer.view setFrame:self.bounds];
//    [self.moviePlayer.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
//    [self.moviePlayer prepareToPlay];
    
    //                [self presentMoviePlayerViewControllerAnimated:self.moviePlayer];
    [self addSubview:self.moviePlayer.view];
    [self.moviePlayer prepareToPlay];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.moviePlayer.view setFrame:self.bounds];
    [self bringSubviewToFront:self.actionBtn];
    [self btnTapped:self.actionBtn];
}

- (void)btnTapped:(UIButton *)btn
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [self.moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    } else {
        [self.moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    }
}

- (BOOL)isPaused
{
    BOOL isPaused = (self.moviePlayer.playbackState == MPMoviePlaybackStatePaused);
    return isPaused;
}

- (void)playVideo
{
    [self.actionBtn setHidden:YES];
    [self.moviePlayer play];
}

- (void)pausePlayVideo
{
    [self.actionBtn setHidden:YES];
    [self.moviePlayer pause];
}

- (void)stopPlayVideo
{
    [self.actionBtn setHidden:NO];
    [self.moviePlayer stop];
}
- (MPMoviePlayerController *)moviePlayer {
    if (!_moviePlayer) {
        NSURL *movieUrl = nil;
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
         _moviePlayer.shouldAutoplay = NO;
       _moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
//        _moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [_moviePlayer.view setFrame:self.bounds];
        _moviePlayer.initialPlaybackTime = -1.0;
        [_moviePlayer.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    return _moviePlayer;
}
@end
