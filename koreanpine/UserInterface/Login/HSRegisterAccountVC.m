//
//  HSRegisterAccountVC.m
//  koreanpine
//
//  Created by Victor on 15/9/29.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSRegisterAccountVC.h"
#import "UIButton+WTXMHighlighted.h"
#import "HSConfigurationAccountController.h"
#import "HSLoginMgr.h"
#import "HSBaseVC.h"
#import "HSLoginVC.h"
#import "AppDelegate.h"
#import "HSAgreementVC.h"
#import "HSRootVC.h"

@interface HSRegisterAccountVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmRead;
@property (weak, nonatomic) IBOutlet UIButton *koreanpineAgreement;

@end

@implementation HSRegisterAccountVC



#pragma mark -共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.confirmRead.highlightEnabled = NO;
    [self.confirmRead setImage:[UIImage imageNamed:@"box02_f"] forState:UIControlStateSelected];
    self.phoneNum.text = self.phoneNumber;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"验证手机号";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -代理方法||数据源方法

#pragma mark -私有方法
- (BOOL)validateNickNameAndPassword
{
    UITextField *firstResponseTF = nil;
    NSString *alertMsg = nil;
    BOOL validatePass = YES;
    if ( self.phoneNum.text.length == 0) {
        
            firstResponseTF = self.phoneNum;
            alertMsg = @"请输入手机号码";
            validatePass = NO;
    } else if (self.phoneNum.text.length != 11) {
        firstResponseTF = self.phoneNum;
        alertMsg = @"手机号码长度不是11位";
        validatePass = NO;
    } else {
        //NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        BOOL isValid = [predicate evaluateWithObject:email];
        NSString *regex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        validatePass = [predicate evaluateWithObject:self.phoneNum.text];
        if (!validatePass) {
            alertMsg = @"号码格式不正确，请查证";
        }
    }

    if (!validatePass) {
        
        [[Hud defaultInstance] showMessage:alertMsg];
    }
    
    return validatePass;
}

- (IBAction)nextBtnTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self validateNickNameAndPassword]) {
        return;
    }
    [self showWaitAlert];
    //验证手机号是否已经被注册
    [[HSLoginMgr loginMgr] verifyPhoneNumberIsExistOrNotWithPhoneNumber:self.phoneNum.text SucceededBlock:^(NSDictionary *info) {
        [self hideWaitAlert];
        //未被注册则跳到注册页面
        HSConfigurationAccountController *configuration = [[HSConfigurationAccountController alloc] initWithNibName:@"HSConfigurationAccountController" bundle:nil];
        configuration.phoneNum = self.phoneNum.text;
        [self.navigationController pushViewController:configuration animated:YES];
    } FailedBlock:^(NSError *error) {
        [self hideWaitAlert];
        [[Hud defaultInstance] showMessage:error.localizedDescription];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            UIWindow *window = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
//            HSRootVC *rootVC = [HSRootVC new];
//            window.rootViewController =rootVC;
//            [rootVC showLoginVC];
//            rootVC.loginVC.phoneNumber = self.phoneNumber;
            
//        });
        
    }];
    
}
- (IBAction)confirmReadBtnTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = [UIColor whiteColor];

    }else {
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    
}
- (IBAction)koreanpineAgreement:(UIButton *)sender {
    self.navigationItem.title = nil;
    HSAgreementVC *agreement = [[HSAgreementVC alloc] initWithNibName:@"HSAgreementVC" bundle:nil];
    
    [self.navigationController pushViewController:agreement animated:YES];
}

#pragma  mark -懒加载


@end
