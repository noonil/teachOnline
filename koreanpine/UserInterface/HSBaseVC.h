//
//  HSBaseVC.h
//  koreanpine
//
//  Created by Christ on 15/8/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBaseVC : UIViewController
@property (strong, nonatomic) UIButton *backBtn;
-(void)backAction:(id)sender;
- (void)showWaitAlert;
- (void)showWaitAlert:(NSString*)alertString autoHide:(BOOL)autohide;
- (void)showWaitAlert:(NSString*)alertString;
- (void)showMsgAlert:(NSString*)alertString;
- (void)hideWaitAlert;
- (void) showSuccess:(NSString *)notify;
- (void) showFailed:(NSString *)notify;
@end

@interface UINavigationItem (Margin)
+ (UIBarButtonItem *)leftFixSpaceBarButtonItem;
+ (UIBarButtonItem *)rightFixSpaceBarButtonItem;
- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
//- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems;
- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
//- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems;

@end
