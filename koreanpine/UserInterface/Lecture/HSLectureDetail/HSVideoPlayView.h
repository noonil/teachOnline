//
//  YH_AView.h
//  YH_BubbleViewTest
//
//  Created by Christ on 15/8/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HSVideoPlayView : UIView

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@property (strong, nonatomic) UISlider *timeLine;

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

- (void)btnTapped:(UIButton *)btn;

- (BOOL)isPaused;

- (void)playVideo;

- (void)pausePlayVideo;

- (void)stopPlayVideo;

@end
