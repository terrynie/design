//
//  ChangePasswordViewController.h
//  exchange
//
//  Created by Terry on 2017/5/9.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPass;
@property (weak, nonatomic) IBOutlet UITextField *neuPass;
@property (weak, nonatomic) IBOutlet UITextField *neuPass2;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end
