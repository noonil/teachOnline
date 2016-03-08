//
//  HSMainVC.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSMainVC.h"
#import "HSTabbar.h"

@interface HSMainVC ()
<HSTabbarDelegate,UITabBarControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) HSTabbar *aTabbar;

@end

@implementation HSMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self replaceTabbar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UITabBar *mainTabbar = (UITabBar *)[self.aTabbar superview];
    [mainTabbar bringSubviewToFront:self.aTabbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    [self setDelegate:self];
    
//    NSArray *mainClassNames = @[@"HSHomeVC",
//                                @"HSLectureVC",
//                                @"HSPracticeVC",
//                                @"HSMineVC"
//                                ];
    NSArray *mainClassNames = @[@"HSLectureVC",
                                @"HSPracticeVC",
                                @"HSMineVC"
                                ];
    
    for (int i = 0;i!=mainClassNames.count;i++) {
        NSString *className =[mainClassNames objectAtIndex:i];
        UIViewController *viewController = [[NSClassFromString(className) alloc] init];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navController.interactivePopGestureRecognizer.enabled = YES;
        navController.interactivePopGestureRecognizer.delegate = self;
        [self addChildViewController:navController];
        
    }
    NSDictionary *tabbarTitleAttr = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UITabBarItem appearance] setTitleTextAttributes:tabbarTitleAttr forState:UIControlStateSelected];
 
}

- (UITabBar *)tabBar
{
    return nil;
}

- (void)replaceTabbar
{
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UITabBar class]]) {
            self.aTabbar = [[HSTabbar alloc] initWithFrame:v.bounds];
            [self.aTabbar setDelegate:self];
            [self.aTabbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            [self.aTabbar setBackgroundColor:[UIColor whiteColor]];
            [v addSubview:self.aTabbar];
            break;
        }
    }
}

- (void)tabbar:(HSTabbar *)tabbar didSelectedIndex:(NSUInteger)selectIndex
{
    [self setSelectedIndex:selectIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    [self.aTabbar setSelectedIndex:selectedIndex];
}

#pragma mark - TabbarController Delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self.tabBar bringSubviewToFront:self.aTabbar];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
