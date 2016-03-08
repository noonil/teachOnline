//
//  HSMineDownloadActionView.h
//  koreanpine
//
//  Created by Christ on 15/8/23.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSMineDownloadActionView : UIView

@property (strong, nonatomic) UIButton *startBtn;

@property (strong, nonatomic) UIButton *pauseBtn;

@property (strong, nonatomic) UIButton *removeBtn;

@property (strong, nonatomic) UIButton *selectAllBtn;

- (void)updateActionHeaderView;

@end
