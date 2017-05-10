//
//  LoginViewController.m
//  exchange
//
//  Created by Terry on 2017/5/8.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _signBtn.layer.cornerRadius = 8;
    _signBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 8;
    _loginBtn.layer.masksToBounds = YES;
    
    [_signBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signUp:(id)sender {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"username"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        SignUpViewController *sv = [[SignUpViewController alloc] init];
        [self.navigationController pushViewController:sv animated:YES];
    }
}

- (void)login: (id)sender {
    NSString *username = _username.text;
    // 使用base64进行编码
    NSString *password = [[_password.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    if ([username  isEqual: @""] || [[username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入用户！";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:3];
    } else if ([password  isEqual: @""] || [[password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入密码！";
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
        [[NSUserDefaults standardUserDefaults] setObject:@"terrynie" forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:@"slfhauywgh" forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:@"password"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"%@，欢迎您回来！", username];
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:3];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(back) userInfo:nil repeats:NO];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
