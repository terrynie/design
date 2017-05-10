//
//  SignUpViewController.m
//  exchange
//
//  Created by Terry on 2017/5/8.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "SignUpViewController.h"
#import "MBProgressHUD.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _signBtn.layer.cornerRadius = 8;
    _signBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 8;
    _loginBtn.layer.masksToBounds = YES;
    _verifyBtn.layer.cornerRadius = 8;
    _verifyBtn.layer.masksToBounds = YES;
    
    [_verifyBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [_signBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getVerifyCode {
    NSString *phone = _phone.text;
    
    if ([phone  isEqual: @""] || [[phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入手机号！";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:3];
    } else {
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //            NSString *urlStr = [NSString stringWithFormat:@"https://exchange.terrynie.com/users/verifyCode?username=%@&password=%@", username, password];
        //            NSString *encoding = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //            NSURL *url = [NSURL URLWithString:encoding];
        //            NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
        //            NSError *err;
        //            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        //            if (err) {
        //                NSLog(@"%@", err);
        //            } else {
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    //回调或者说是通知主线程刷新，
        //
        //
        //                });
        //            }
        //        });
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"验证码发送成功，请查收！"];
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:3];
    }
}

- (void)signUp: (id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide =YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [NSString stringWithFormat:@"注册成功！请返回登录。"];
    hud.minSize = CGSizeMake(132.f, 108.0f);
    [hud hide:YES afterDelay:3];
}

@end
