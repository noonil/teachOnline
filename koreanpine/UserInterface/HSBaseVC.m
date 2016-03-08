//
//  HSBaseVC.m
//  koreanpine
//
//  Created by Christ on 15/8/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
#import "YH_Tool.h"

@interface HSBaseVC ()

@end

@implementation HSBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
- (BOOL)shouldAutorotate
{
    return YES;
}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIButton *)backBtn{
    
    if (!_backBtn) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 44, 44);
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setExclusiveTouch:YES];
        [_backBtn setImage:[UIImage imageNamed:@"shared_back_icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark - button actions
-(void)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMsgAlert:(NSString*)alertString
{
    NSString *message = alertString;
    if (IsNilOrNull(alertString) || [alertString isEqualToString:@""]) {
        return;
    }
    [YH_Tool alert:message type:YHBAlertTypeMessage autoHide:YES inView:self.view];
}

- (void)showWaitAlert
{
    //    [YH_Tool alert:nil type:YHBAlertTypeWait autoHide:NO inView:self.view];
    
    [self showWaitAlert:nil];
}

- (void)showWaitAlert:(NSString*)alertString autoHide:(BOOL)autohide
{
    NSString *message = alertString;
    if (IsNilOrNull(alertString) || [alertString isEqualToString:@""]) {
        message =  NSLocalizedString(@"请稍等", nil);
    }
    [YH_Tool alert:message type:YHBAlertTypeWait autoHide:autohide inView:self.view];
}

- (void)showWaitAlert:(NSString*)alertString
{
    [self showWaitAlert:alertString autoHide:NO];
}

- (void)hideWaitAlert
{
    [YH_Tool hideAlertInView:self.view];
}
- (void)showSuccess:(NSString *)notify {
    [YH_Tool alertSuccess:notify];
}
- (void)showFailed:(NSString *)notify {
    [YH_Tool alertFail:notify];
}
@end

@implementation UINavigationItem (Margin)
+ (UIBarButtonItem *)leftFixSpaceBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -15;
    return spaceButtonItem;
}

+ (UIBarButtonItem *)rightFixSpaceBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -10;
    return spaceButtonItem;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if (leftBarButtonItem){
        [self setLeftBarButtonItems:@[[UINavigationItem leftFixSpaceBarButtonItem], leftBarButtonItem]];
    } else {
        [self setLeftBarButtonItems:nil];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if ([rightBarButtonItem customView] == nil) {
        [self setRightBarButtonItems:rightBarButtonItem?@[rightBarButtonItem]:nil];
        return;
    }
    
    if (rightBarButtonItem){
        [self setRightBarButtonItems:@[rightBarButtonItem,[UINavigationItem leftFixSpaceBarButtonItem]]];
    } else {
        [self setRightBarButtonItems:nil];
    }
}

@end
