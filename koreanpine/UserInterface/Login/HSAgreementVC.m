//
//  HSAgreementVC.m
//  koreanpine
//
//  Created by Victor on 15/10/8.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSAgreementVC.h"

@interface HSAgreementVC ()
@property (weak, nonatomic) IBOutlet UIWebView *koreanpineAgreementView;

@end

@implementation HSAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.koreanpineAgreementView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.10.136:8088/HsMobile/public/html_app_reg_xieyi.html"]]];
     self.navigationItem.title = @"红松派注册协议";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
