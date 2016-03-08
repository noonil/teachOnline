//
//  HSFindPwdVC.m
//  koreanpine
//
//  Created by Christ on 15/8/30.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSFindPwdVC.h"
#import "HSVerifyStatusVC.h"
#import "HSLoginMgr.h"
@interface HSFindPwdVC ()
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic,copy) NSString *verifyCode;
@property (strong, nonatomic) HSCompanyModel *companyModel;

@end

@implementation HSFindPwdVC





#pragma mark -共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.companyNameLabel.text = self.companyModel.companyName;
    self.phoneNumTextField.text = self.phoneNum;
//    [self getVerifyCodeImage];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [self getVerifyCodeImage];
    self.companyNameLabel.text = self.companyModel.companyName;
    self.navigationItem.title = @"验证身份";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -代理方法||数据源方法

#pragma mark -私有方法
- (BOOL)validatePhoneNumAndVerifyCode
{
    UITextField *firstResponseTF = nil;
    NSString *alertMsg = nil;
    BOOL validatePass = YES;
    if ( self.verifyCodeTextField.text.length * self.phoneNumTextField.text.length == 0) {
        if (!self.phoneNumTextField.text.length) {
            firstResponseTF = self.phoneNumTextField;
            alertMsg = @"请输入手机号码";
            validatePass = NO;
        }else {
            firstResponseTF = self.verifyCodeTextField;
            alertMsg = @"请输入验证码";
            validatePass = NO;
        }
        
    } else if (self.phoneNumTextField.text.length != 11) {
        firstResponseTF = self.phoneNumTextField;
        alertMsg = @"手机号码长度不是11位";
        validatePass = NO;
    }else if(self.verifyCodeTextField.text.length != 4) {
        firstResponseTF = self. verifyCodeTextField;
        alertMsg = @"验证码长度不是4位";
        validatePass = NO;
    }else if ([self.verifyCodeTextField.text compare:self.verifyCode options:NSCaseInsensitiveSearch] != NSOrderedSame) {
        firstResponseTF = self. verifyCodeTextField;
        alertMsg = @"验证码输入错误";
        validatePass = NO;
    }
    else {
        //NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        //        BOOL isValid = [predicate evaluateWithObject:email];
        NSString *regex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        validatePass = [predicate evaluateWithObject:self.phoneNumTextField.text];
        if (!validatePass) {
            alertMsg = @"号码格式不正确，请查证";
        }
    }
    
    if (!validatePass) {
        
        [[Hud defaultInstance] showMessage:alertMsg];
    }
    
    return validatePass;
}

- (void) getVerifyCodeImage {
  [[NetworkCenter shareCenter] getVerifyCodeImageWithSucceededBlock:^(NSDictionary *info) {
      [self.verifyBtn setBackgroundImage:info[@"image"] forState:UIControlStateNormal];
      self.verifyCode = info[@"verifyCode"];
  } FailedBlock:^(NSError *error) {
      
  }];
}
- (IBAction)nextbtnTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    if(![self validatePhoneNumAndVerifyCode]) {
        return;
    }
    HSVerifyStatusVC *nextVC = [[HSVerifyStatusVC alloc] initWithNibName:@"HSVerifyStatusVC" bundle:nil];
//    nextVC.companyModel = self.companyModel;
    if (self.phoneNumTextField.text) {
        nextVC.phoneNum = self.phoneNumTextField.text;
    }
//    self.navigationController popToViewController: animated:<#(BOOL)#>
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (IBAction)verifyBtnTapped:(UIButton *)sender {
    [self getVerifyCodeImage];
}
#pragma  mark -懒加载
- (HSCompanyModel *)companyModel {
    if (!_companyModel) {
        NSData *lastCompanyArchiver = (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyLastSelectCompanyModel];
        _companyModel = (HSCompanyModel *)[NSKeyedUnarchiver unarchiveObjectWithData:lastCompanyArchiver];
        
           }
   return _companyModel;
}
@end
