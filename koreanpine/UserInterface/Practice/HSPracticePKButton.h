//
//  HSPracticePKButton.h
//  koreanpine
//
//  Created by Victor on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
@class HSPracticePKButton,HSUserHeroModel;
@protocol HSPracticePKButtonDelegate <NSObject>
@optional
- (void) practicePKBtnTapped:(HSPracticePKButton *)button;
@end

@interface HSPracticePKButton : UIButton
@property (nonatomic,strong) DACircularProgressView *progressView;
@property (nonatomic,weak) id<HSPracticePKButtonDelegate> delegate;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic,copy) NSString *sortType;
@property (nonatomic,strong) HSUserHeroModel *userHeroModel;
@property (nonatomic,assign,getter=isBig) BOOL big;
@end
