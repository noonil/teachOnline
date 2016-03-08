//
//  ViewController.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSRootVC.h"
#import "HSLaunchGuideVC.h"
#import "HSLoginVC.h"
#import "HSMainVC.h"
#import "HSLoginMgr.h"
#import "AppDelegate.h"
#import "HSCompanyModel.h"

@interface HSRootVC ()

@property (strong, nonatomic) HSLaunchGuideVC *launchGuideVC;

@property (strong, nonatomic) UINavigationController *loginNav;



@property (strong, nonatomic) HSMainVC *mainVC;

@property (strong, nonatomic) UIImageView *waitLoginView;


@end

@implementation HSRootVC

+ (instancetype)rootVC
{
    static HSRootVC *rootVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rootVC = (HSRootVC *)[[UIApplication sharedApplication].delegate.window rootViewController];
        if (!rootVC) {
            rootVC = [[HSRootVC alloc] init];
        }
    });
    return rootVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initNotifi];
    [self initView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jumpView];
    });
    
}

- (void)jumpView
{
    BOOL hasShowLaunchGuide = [[NSUserDefaults standardUserDefaults] boolForKey:@"HSHasShowLaunchGuide"];
    if (!hasShowLaunchGuide) {
        [self showLaunchGuideVC];
    } else if ([HSLoginMgr loginMgr].hasLogin) {
        [self showMainVC];
    } else if([[HSLoginMgr loginMgr] shouldCheckLoginInfo]){
        [self.waitLoginView setHidden:NO];
        [[HSLoginMgr loginMgr] startCheckLocalLoginInfoWithFinishBlock:^(BOOL suc) {
            if (suc) {
                [self showMainVC];
            } else {
                [self showLoginVC];
            }
        }];
    } else {
        [self showLoginVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
    [[UINavigationBar appearance] setBarTintColor:RGBCOLOR(85, 125, 201)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    
    self.waitLoginView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    NSString *imageName = @"";
    if (CGRectGetHeight([UIScreen mainScreen].bounds)<500.0f) {
        imageName = @"启动页4";
    } else {
        imageName = @"启动页";
    }
    [self.waitLoginView setImage:[UIImage imageNamed:imageName]];
    [self.waitLoginView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.waitLoginView setHidden:YES];
    [self.view addSubview:self.waitLoginView];
}

- (void)initNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kUserDidLoginNotifi object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:kUserDidLogoutNotifi object:nil];
}

- (void)userDidLogin
{
    [self hideWaitAlert];
    [self.waitLoginView setHidden:YES];
    [self finishShowLoginVC];
}

- (void)userDidLogout
{
    [self showLoginVC];
}

- (void)showLoginVC
{
    
    self.loginVC = [[HSLoginVC alloc] initWithNibName:@"HSLoginVC" bundle:nil];
    self.loginVC.phoneNumber = self.phoneNum;
    self.loginVC.companyModel = self.companyModel;
    [self.loginVC.view setFrame:self.view.bounds];
    [self addChildViewController:self.loginVC];
    self.loginNav = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
    [self.view addSubview:self.loginNav.view];
}

- (void)finishShowLoginVC
{
    [self.loginVC.view removeFromSuperview];
    [self.loginVC removeFromParentViewController];
    [self showMainVC];
}

- (void)showLaunchGuideVC
{
    self.launchGuideVC = [[HSLaunchGuideVC alloc] init];
    [self addChildViewController:self.launchGuideVC];
    [self.view addSubview:self.launchGuideVC.view];
}

- (void)finishShowlaunchGuideVC
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HSHasShowLaunchGuide"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.launchGuideVC.view removeFromSuperview];
    [self.launchGuideVC removeFromParentViewController];
    self.launchGuideVC = nil;
    
    
    if ([HSLoginMgr loginMgr].hasLogin) {
        [self showMainVC];
    } else {
        [self showLoginVC];
    }
}

- (void)showMainVC
{
    self.mainVC = [[HSMainVC alloc] init];
    [self addChildViewController:self.mainVC];
    [self.view addSubview:self.mainVC.view];
}

@end
