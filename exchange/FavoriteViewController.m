//
//  FavoriteViewController.m
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "FavoriteViewController.h"
#import "ExchangeCellTableViewCell.h"
#import "Reachable.h"

@interface FavoriteViewController ()
@property NSMutableArray *arr;
@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"username"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登录后才能查看哟！";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:1.5];
        
    } else {
        [self read];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(reload) userInfo:nil repeats:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"username"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登录后才能查看哟！";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:1.5];
        _arr = nil;
        [_tableView reloadData];
    } else {
        [self read];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identy = @"ExchangeCellTableViewCell";
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
    cell.currency.text = [[_arr objectAtIndex:indexPath.row] currency];
    cell.currency1.text = [[_arr objectAtIndex:indexPath.row] bank];
    cell.remittanceBuyPrice.text = [NSString stringWithFormat:@"%.4f",[[[_arr objectAtIndex:indexPath.row] remittanceBuyPrice] floatValue]];
    cell.cashBuyPrice.text = [NSString stringWithFormat:@"%.4f", [[[_arr objectAtIndex:indexPath.row] cashBuyPrice] floatValue]];
    cell.sellPrice.text = [NSString stringWithFormat:@"%.4f", [[[_arr objectAtIndex:indexPath.row] sellPrice] floatValue]];
    cell.cenPrice.text = [NSString stringWithFormat:@"%.4f", [[[_arr objectAtIndex:indexPath.row] cenPrice] floatValue]];
    cell.bounds = CGRectMake(0, indexPath.row * 90,self.view.bounds.size.width, 90);
    NSTimeInterval timeinterval = [[[_arr objectAtIndex:indexPath.row] time] doubleValue] - 28800;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: timeinterval];
    cell.time.text = [NSString stringWithFormat:@"%@ %@",@"更新时间：", [[date description] substringToIndex:19]];
    return cell;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) read {
    _arr = [[NSMutableArray alloc] init];
    //    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70)];
    _tableView.dataSource = self;
    _tableView.rowHeight = 90;
    _tableView.delegate = self;
    NSData *data = [[[NSUserDefaults standardUserDefaults] objectForKey:@"favorite"] dataUsingEncoding:NSUTF8StringEncoding];
    //    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"favorite"]);
    NSError *err;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    //    NSLog(@"%@", json);
    if (err) {
        NSLog(@"%@", err);
    } else {
        for (int i = 0; i < [json count]; i++) {
            Exchange *e = [[Exchange alloc] initWithObject:[json objectAtIndex:i]];
            [self.arr addObject:e];
        }
        NSLog(@"%@", self.arr);
    }

}

-(void) reload {
    [self.tableView reloadData];
}

@end
