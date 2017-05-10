//
//  ChangePasswordViewController.m
//  exchange
//
//  Created by Terry on 2017/5/9.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "MBProgressHUD.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_changeBtn addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)changePassword {
    NSString *oldPass = _oldPass.text;
    NSString *neuPass = _neuPass.text;
    NSString *neuPass2 = _neuPass2.text;
    if (oldPass != [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码不正确！";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:1.5];
    } else {
        if (![neuPass isEqualToString:neuPass2]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"两次密码不一致！";
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hide:YES afterDelay:1.5];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"密码修改成功！";
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hide:YES afterDelay:3];
            [[NSUserDefaults standardUserDefaults] setObject:neuPass forKey:@"password"];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(back) userInfo:nil repeats:NO];
        }
    }
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
