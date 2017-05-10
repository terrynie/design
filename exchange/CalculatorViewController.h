//
//  CalculatorViewController.h
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "ViewController.h"

@interface CalculatorViewController : ViewController
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UITextField *beginInput;
@property (weak, nonatomic) IBOutlet UITextField *output;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end
