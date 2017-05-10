//
//  CalculatorViewController.m
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "CalculatorViewController.h"
#import "Reachable.h"
#import "Exchange.h"

@interface CalculatorViewController ()
@property int begin;
@property int end;
@property NSMutableArray *exchangeArray;
@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _exchangeArray = [[NSMutableArray alloc] init];
    _beginBtn.titleLabel.frame = _beginBtn.bounds;
    _endBtn.titleLabel.frame = _endBtn.bounds;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
    if ([Reachable isConnectionAvailableInView:self.view]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *urlStr = [NSString stringWithFormat:@"https://exchange.terrynie.com/exchange/now"];
            NSString *encoding = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:encoding];
            NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
            NSLog(@"%@", data);
            NSError *err;
            if (err || !data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.removeFromSuperViewOnHide =YES;
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"哎哟，服务器开小差了！";
                    hud.minSize = CGSizeMake(132.f, 108.0f);
                    [hud hide:YES afterDelay:3];
                });
            } else {
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                if (err) {
                    NSLog(@"%@", err);
                } else {
                    for (int i = 0; i < [json count]; i++) {
                        Exchange *e = [[Exchange alloc] initWithObject:[json objectAtIndex:i]];
                        [self.exchangeArray addObject:e];
                    }
                    Exchange *temp = [[Exchange alloc] init];
                    temp.currency = @"人民币";
                    temp.remittanceBuyPrice = [NSNumber numberWithInt:100];
                    temp.cashBuyPrice = [NSNumber numberWithInt:100];
                    temp.sellPrice = [NSNumber numberWithInt:100];
                    temp.cenPrice = [NSNumber numberWithInt:100];
                    [self.exchangeArray addObject:temp];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        _beginLabel.text = [[_exchangeArray objectAtIndex:13] currency];
                        _endLabel.text = [[_exchangeArray objectAtIndex:[_exchangeArray count] - 1] currency];
                        _begin = 13;
                        _end = (int)[_exchangeArray count] - 1;
                        
                    });
                }
            }
        });
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender {
    
    
    
    //初始化提示框；
    /**
     preferredStyle参数：
     UIAlertControllerStyleActionSheet,
     UIAlertControllerStyleAlert
     
     *  如果要实现ActionSheet的效果，这里的preferredStyle应该设置为UIAlertControllerStyleActionSheet，而不是UIAlertControllerStyleAlert；
     */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择币种" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    
    /**
     *  style参数：
     UIAlertActionStyleDefault,
     UIAlertActionStyleCancel,
     UIAlertActionStyleDestructive（默认按钮文本是红色的）
     *
     */
    //分别按顺序放入每个按钮；
    for (int i = 0; i < [_exchangeArray count]; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[[_exchangeArray objectAtIndex:i] currency] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@, %d", sender.restorationIdentifier, i);
//            dispatch_sync(dispatch_get_main_queue(), ^{
                //点击按钮的响应事件；
                if ([sender.restorationIdentifier intValue] == 0) {
                    _begin = i;
                    _beginLabel.text = [[_exchangeArray objectAtIndex:i] currency];
                } else {
                    _end = i;
                    _endLabel.text = [[_exchangeArray objectAtIndex:i] currency];
                }
//            });
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"点击了取消");
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - 返回按钮的点击
- (IBAction)backPressed:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)textFieldChanged {
    if(_begin == _end){
        _output.text = _beginInput;
    } else {
        double middle = [_beginInput.text doubleValue] / 100 * [[[_exchangeArray objectAtIndex:_begin] sellPrice] doubleValue];
        double end = middle / [[[_exchangeArray objectAtIndex:_end] sellPrice] doubleValue] * 100;
        _output.text = [NSString stringWithFormat:@"%.4f",end];
    }
}

@end
