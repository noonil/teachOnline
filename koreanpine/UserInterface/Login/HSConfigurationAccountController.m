//
//  HSConfigurationAccountController.m
//  koreanpine
//
//  Created by Victor on 15/9/29.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSConfigurationAccountController.h"
#import "HSLoginMgr.h"
#import "AppDelegate.h"
#import "HSLoginVC.h"
#import "HSRootVC.h"

@interface HSConfigurationAccountController ()
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *showPWDBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (nonatomic,strong) HSCompanyModel *companyModel;
@end

@implementation HSConfigurationAccountController


#pragma mark -共有方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"注册";
        
    }
    return self;
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
    [self setPromptLabelString];
    [self getVerifyCode];
    [self.pwdTF addTarget:self action:@selector(matchCharacter) forControlEvents:UIControlEventEditingChanged];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -代理方法||数据源方法

#pragma mark -私有方法
/**
 *  获取验证码按钮点击
 *
 */
- (IBAction)sendVerifyCodeBtnTapped:(UIButton *)sender {
    [self getVerifyCode];
  
}
/**
 *  显示密码按钮点击
 *
 */
- (IBAction)showPWDBtnTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdTF.secureTextEntry = NO;
    }else {
        self.pwdTF.secureTextEntry = YES;
    }
}
/**
 *  注册按钮点击
 *
 */
- (IBAction)signUpBtnTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self examinePasswordsFormat]) {
        return;
    }
    [self showWaitAlert];
    [[HSLoginMgr loginMgr] registerNewUserAccountWithPhoneNum:self.phoneNum Password:self.pwdTF.text VerifyCode:self.verifyCodeTF.text SucceededBlock:^(NSDictionary *info) {
        [self hideWaitAlert];
//        UIWindow *window = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
//        HSLoginVC *login = [HSLoginVC new];
//        login.phoneNumber = self.phoneNum;
//        window.rootViewController = login;
//        NSLog(@"%@",self.pwdTF.text);
        [[HSLoginMgr loginMgr] loginWithUserName:self.phoneNum passWord:self.pwdTF.text companyModel:self.companyModel finish:^(NSDictionary *tokenInfo) {
            [[HSRootVC rootVC] finishShowLoginVC];
            [self hideWaitAlert];
        } failedBlock:^(NSError *error) {
            [self hideWaitAlert];
            [[Hud defaultInstance] showMessage:error.localizedDescription];
        }];
    } FailedBlock:^(NSError *error) {
        [self hideWaitAlert];
       [[Hud defaultInstance] showMessage:error.localizedDescription];
    }];
}
/**
 *  设置提示栏文字
 */
- (void) setPromptLabelString {
    NSString *suffix = [self.phoneNum substringWithRange:NSMakeRange(0, 3)];
    NSString *preffix = [self.phoneNum substringWithRange:NSMakeRange(7, 4)];
    //我们已经给您的手机号码150****1234发送了一条验证短信
    NSString *prompt = [NSString stringWithFormat:@"我们已经给您的手机号码%@****%@发送了一条验证短信",suffix, preffix];
    self.promptLabel.text = prompt;
}
/**
 *  获取验证码
 */
- (void) getVerifyCode {
    //网络请求获取验证码
    [[HSLoginMgr loginMgr] getVerifyCodeWithPhoneNumber:self.phoneNum SucceededBlock:^(NSDictionary *info) {
//        NSLog(@"chenggong");
    } FailedBlock:^(NSError *error) {
//        NSLog(@"失败");
    }];
//    按钮显示60秒倒计时
    __block int timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout<=0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendVerifyCodeBtn.enabled = YES;
                [self.sendVerifyCodeBtn setBackgroundColor:RGBCOLOR(84, 190, 105)];
            });
        }else {
            NSString *time = [NSString stringWithFormat:@"%ds",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendVerifyCodeBtn.titleLabel.text = time;
                [self.sendVerifyCodeBtn setTitle:time forState:UIControlStateDisabled];
                [self.sendVerifyCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
                self.sendVerifyCodeBtn.enabled = NO;
                
            });
            timeout--;
        }
        
    });
    dispatch_resume(timer);
}
/**
 *  检查验证码和密码输入是否符合要求
 */
- (BOOL) examinePasswordsFormat {
    
    NSString *alertMsg = nil;
    BOOL validatePass = YES;
    if (self.verifyCodeTF.text.length*self.pwdTF.text.length == 0) {
        if (!self.pwdTF.text.length) {
            alertMsg = @"请输入密码";
        }else {
            alertMsg = @"请输入验证码";
        }
        validatePass = NO;
    } else if (self.pwdTF.text.length < 6) {
        alertMsg = @"密码长度小于6位";
        validatePass = NO;
    } else if (self.pwdTF.text.length > 16) {
        alertMsg = @"密码长度大于16位";
        validatePass = NO;
    }else if(self.verifyCodeTF.text.length < 6){
        alertMsg = @"验证码长度小于6位";
    }
    if (!validatePass) {
       [[Hud defaultInstance] showMessage:alertMsg];
    }
    return validatePass;
}
/**
 *  匹配密码格式
 */
- (void) matchCharacter {
    NSString *regex = @"^[A-Za-z0-9_]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (self.pwdTF.text.length&&![predicate evaluateWithObject:self.pwdTF.text]) {
        NSMutableString *string = self.pwdTF.text.mutableCopy;
        [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)];
        NSString *str = string;//此处需要强转一下，不然重新编辑，删除字符会崩
        self.pwdTF.text = str;
        [self.view endEditing:YES];
        [[Hud defaultInstance] showMessage:@"密码格式错误"];
    }
}
#pragma  mark -懒加载
- (HSCompanyModel *)companyModel {
    if (!_companyModel) {
        _companyModel = [[HSCompanyModel alloc] init];
        _companyModel.companyID = @"100709";
        _companyModel.companyName = @"南京红松信息技术有限公司";
        _companyModel.companyUUID = @"6B9B086751F0492BAEDDF84E707F7F6B";
    }
    return _companyModel;
}


@end
