//
//  HSVerifyStatusVC.m
//  koreanpine
//
//  Created by Victor on 15/10/16.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSVerifyStatusVC.h"
#import "HSLoginMgr.h"
#import "HSCompanyModel.h"
#import "HSChangePasswordVC.h"
@interface HSVerifyStatusVC ()
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *setPassswordBtn;

@end

@implementation HSVerifyStatusVC



#pragma mark -共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    [self getVerifyCode];
    [self setPromptLabelString];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"验证身份";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark -代理方法||数据源方法

#pragma mark -私有方法
- (BOOL)validateVerifyCode
{
    UITextField *firstResponseTF = nil;
    NSString *alertMsg = nil;
    BOOL validatePass = YES;
    if ( self.verifyCodeTextField.text.length == 0) {
        
        firstResponseTF = self.verifyCodeTextField;
        alertMsg = @"请输入验证码";
        validatePass = NO;
    } else if (self. verifyCodeTextField.text.length != 6) {
        firstResponseTF = self.verifyCodeTextField;
        alertMsg = @"验证码长度不是6位";
        validatePass = NO;
//    } else {
        //NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        //        BOOL isValid = [predicate evaluateWithObject:email];
//        NSString *regex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        validatePass = [predicate evaluateWithObject:self.phoneNum.text];
//        if (!validatePass) {
//            alertMsg = @"号码格式不正确，请查证";
//        }
    }
    
    if (!validatePass) {
        
        [[Hud defaultInstance] showMessage:alertMsg];
    }
    
    return validatePass;
}

- (void) setPromptLabelString {
    NSString *suffix = [self.phoneNum substringWithRange:NSMakeRange(0, 3)];
    NSString *preffix = [self.phoneNum substringWithRange:NSMakeRange(7, 4)];
    //我们已经给您的手机号码150****1234发送了一条验证短信
    NSString *prompt = [NSString stringWithFormat:@"我们已经给您的手机号码%@****%@发送了一条验证短信",suffix, preffix];
    self.notificationLabel.text = prompt;
}
/**
 *  获取验证码
 */
- (void) getVerifyCode {
    NSData *lastCompanyArchiver = (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyLastSelectCompanyModel];
    HSCompanyModel *companyModel = (HSCompanyModel *)[NSKeyedUnarchiver unarchiveObjectWithData:lastCompanyArchiver];
    
    self.companyModel = companyModel;
    //网络请求获取验证码
    [[HSLoginMgr loginMgr] getVerifyCodeWithPhoneNumber:self.phoneNum companyModel:self.companyModel SucceededBlock:^(NSDictionary *info) {
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
                self.verifyCodeBtn.enabled = YES;
                [self.verifyCodeBtn setBackgroundColor:RGBCOLOR(84, 190, 105)];
            });
        }else {
            NSString *time = [NSString stringWithFormat:@"%ds",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.verifyCodeBtn.titleLabel.text = time;
                [self.verifyCodeBtn setTitle:time forState:UIControlStateDisabled];
                [self.verifyCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
                self.verifyCodeBtn.enabled = NO;
                
            });
            timeout--;
        }
        
    });
    dispatch_resume(timer);
}
- (IBAction)verifyCodeBtnTapped:(UIButton *)sender {
    [self getVerifyCode];
}
- (IBAction)setPasswordBtnTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self validateVerifyCode]) {
        return;
    }
    [self showWaitAlert];
    [[HSLoginMgr loginMgr] verifyCodeIsRightOrNotWithPhoneNumber:self.phoneNum companyModel:self.companyModel VerifyCode:self.verifyCodeTextField.text SucceededBlock:^(NSDictionary *info) {
        [self hideWaitAlert];
        
        NSDictionary *dict = info[@"data"];
        if ([dict[@"isRight"] integerValue] == 1) {
            //跳转到设置密码界面
            HSChangePasswordVC *nextVC = [[HSChangePasswordVC alloc] initWithNibName:@"HSChangePasswordVC" bundle:nil];
//            nextVC.companyModel = self.companyModel;
            nextVC.phoneNum = self.phoneNum;
            [self.navigationController pushViewController:nextVC animated:YES];
        }else {
            [self showFailed:@"验证码错误"];
        }
        
    } FailedBlock:^(NSError *error) {
        
    }];

    
}

#pragma  mark -懒加载


@end
