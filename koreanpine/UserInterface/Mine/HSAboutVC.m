//
//  HSAboutVC.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSAboutVC.h"

@interface HSAboutVC ()
@property (weak, nonatomic) IBOutlet UIImageView *loginLogo;
@property (weak, nonatomic) IBOutlet UILabel *appEdition;
@property (nonatomic,assign) NSInteger appType;
@end

@implementation HSAboutVC



#pragma mark -共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    if (self.appType == HSAppTypeHongSongPai) {
        self.loginLogo.image = [UIImage imageNamed:@"icon"];
    }
    NSString *bundleName = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
    NSString *shortVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *appEdition = [NSString stringWithFormat:@"%@ v%@",bundleName, shortVersion];
    self.appEdition.text = appEdition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -代理方法||数据源方法

#pragma mark -私有方法

#pragma  mark -懒加载
- (NSInteger)appType {
    if (!_appType) {
        _appType = kHSAPPTYPE;

    }
    return _appType;
}

@end
