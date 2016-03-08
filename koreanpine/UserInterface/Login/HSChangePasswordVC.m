//
//  HSChangePasswordVC.m
//  koreanpine
//
//  Created by Victor on 15/10/16.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSChangePasswordVC.h"
#import "HSLoginMgr.h"
#import "HSCompanyModel.h"
#import "HSRootVC.h"
#import "HSLoginVC.h"
#import "AppDelegate.h"
#import "HSRootVC.h"
@interface HSChangePasswordVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation HSChangePasswordVC



#pragma mark -共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.passwordTextField addTarget:self action:@selector(matchCharacter) forControlEvents:UIControlEventEditingChanged];
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
    self.navigationItem.title = @"设置新密码";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -代理方法||数据源方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
            if ([viewCtrl isKindOfClass:[HSLoginVC class]]) {
                HSLoginVC *login = (HSLoginVC *)viewCtrl;
                login.phoneNumber = self.phoneNum;
                [self.navigationController popToViewController:login animated:YES];
            }
        }
            
    }
}
#pragma mark -私有方法
/**
 *  检查验证码和密码输入是否符合要求
 */
- (BOOL) examinePasswordsFormat {
    
    NSString *alertMsg = nil;
    BOOL validatePass = YES;
    if (self.passwordTextField.text.length == 0) {
        if (!self.passwordTextField.text.length) {
            alertMsg = @"请输入密码";
        }
        validatePass = NO;
    } else if (self.passwordTextField.text.length < 6) {
        alertMsg = @"密码长度小于6位";
        validatePass = NO;
    } else if (self.passwordTextField.text.length > 16) {
        alertMsg = @"密码长度大于16位";
        validatePass = NO;
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
    if (self.passwordTextField.text.length&&![predicate evaluateWithObject:self.passwordTextField.text]) {
        NSMutableString *string = self.passwordTextField.text.mutableCopy;
        [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)];
        NSString *str = string;//此处需要强转一下，不然重新编辑，删除字符会崩
        self.passwordTextField.text = str;
        [self.view endEditing:YES];
        [[Hud defaultInstance] showMessage:@"密码格式错误"];
    }
}
- (IBAction)showPasswordBtnTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.passwordTextField.secureTextEntry = NO;
    }else {
        self.passwordTextField.secureTextEntry = YES;
    }

}
- (IBAction)enterBtnTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self examinePasswordsFormat]) {
        return;
    }
    [self showWaitAlert];
    NSData *lastCompanyArchiver = (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyLastSelectCompanyModel];
    HSCompanyModel *companyModel = (HSCompanyModel *)[NSKeyedUnarchiver unarchiveObjectWithData:lastCompanyArchiver];
    [[HSLoginMgr loginMgr] modifyPasswordWithPhoneNumber:self.phoneNum companyModel:companyModel password:self.passwordTextField.text SucceededBlock:^(NSDictionary *info) {
         [self hideWaitAlert];
//        NSLog(@"%@",info);
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:@"密码修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
        
        [alv show];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            //            [[HSLoginMgr loginMgr] loginWithUserName:self.phoneNum passWord:self.passwordTextField.text companyModel:self.companyModel finish:^(NSDictionary *tokenInfo) {
//                [[HSRootVC rootVC] finishShowLoginVC];
//                [self hideWaitAlert];
//            } failedBlock:^(NSError *error) {
//                [self hideWaitAlert];
//                [[Hud defaultInstance] showMessage:error.localizedDescription];
//            }];
//        });
    } FailedBlock:^(NSError *error) {
        
    }];
}

#pragma  mark -懒加载


@end
