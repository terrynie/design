//
//  ExchangeListViewController.m
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//
#import "Exchange.h"
#import "ExchangeListViewController.h"
#import "ExchangeCellTableViewCell.h"
#import "PNChartViewController.h"
#import "ListViewController.h"
#import "Reachable.h"

@interface ExchangeListViewController ()
@property(nonatomic, retain) NSMutableArray *exchangeArray;
@property(nonatomic, retain) UITableView *tableView;
@end

@implementation ExchangeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _exchangeArray = [[NSMutableArray alloc] init];
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
                        _tableView.rowHeight = 90.0f;
                        _tableView.bounds = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
                        [self.view addSubview:_tableView];
                        _tableView.dataSource = self;
                        _tableView.delegate = self;
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"[%@]",[[_exchangeArray objectAtIndex:5] description]] forKey:@"favorite"];
                        
                    });
                }
            }
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
    static NSString *identy = @"CustomCell";
    UINib *nib = [UINib nibWithNibName:@"ExchangeCellTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identy];
    ExchangeCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (!cell) {
        cell = [[ExchangeCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
    }
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.currency.textColor = [UIColor whiteColor];
        cell.currency1.textColor = [UIColor whiteColor];
        cell.remittanceBuyPrice1.textColor = [UIColor whiteColor];
        cell.cashBuyPrice1.textColor = [UIColor whiteColor];
        cell.sellPrice1.textColor = [UIColor whiteColor];
        cell.cenPrice1.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.currency.textColor = [UIColor blackColor];
        cell.currency1.textColor = [UIColor blackColor];
        cell.remittanceBuyPrice1.textColor = [UIColor lightGrayColor];
        cell.cashBuyPrice1.textColor = [UIColor lightGrayColor];
        cell.sellPrice1.textColor = [UIColor lightGrayColor];
        cell.cenPrice1.textColor = [UIColor lightGrayColor];
    }
    cell.currency.text = [[_exchangeArray objectAtIndex:indexPath.row] currency];
    cell.remittanceBuyPrice.text = [NSString stringWithFormat:@"%.4f",[[[_exchangeArray objectAtIndex:indexPath.row] remittanceBuyPrice] floatValue]];
    cell.cashBuyPrice.text = [NSString stringWithFormat:@"%.4f", [[[_exchangeArray objectAtIndex:indexPath.row] cashBuyPrice] floatValue]];
    cell.sellPrice.text = [NSString stringWithFormat:@"%.4f", [[[_exchangeArray objectAtIndex:indexPath.row] sellPrice] floatValue]];
    cell.cenPrice.text = [NSString stringWithFormat:@"%.4f", [[[_exchangeArray objectAtIndex:indexPath.row] cenPrice] floatValue]];
    cell.bounds = CGRectMake(0, indexPath.row * 90,self.view.bounds.size.width, 90);
    NSTimeInterval timeinterval = [[[_exchangeArray objectAtIndex:indexPath.row] time] doubleValue] - 28800;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: timeinterval];
    cell.time.text = [NSString stringWithFormat:@"%@ %@",@"更新时间：", [[date description] substringToIndex:19]];
    
    [self registerForPreviewingWithDelegate:self sourceView:cell];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_exchangeArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identy = @"PNChartViewController";
//    UINib *nib = [UINib nibWithNibName:@"ExchangeCellTableViewCell" bundle:nil];
//    [tableView registerNib:nib forCellReuseIdentifier:identy];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        PNChartViewController *pnc = [[PNChartViewController alloc] init];
        pnc.bank = [[_exchangeArray objectAtIndex:indexPath.row] bank];
        pnc.currency = [[_exchangeArray objectAtIndex:indexPath.row] currency];
        [self.navigationController pushViewController:pnc animated:NO];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登录后才能查看哟！";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:1.5];
    }
}

-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
}

-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    return [[ListViewController alloc] init];
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"加入收藏" style:1 handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    return [NSArray arrayWithObjects:action1,nil];
}
@end
