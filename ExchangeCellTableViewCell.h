//
//  ExchangeCellTableViewCell.h
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exchange.h"
@interface ExchangeCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currency;
@property (weak, nonatomic) IBOutlet UILabel *cashBuyPrice;
@property (weak, nonatomic) IBOutlet UILabel *remittanceBuyPrice;
@property (weak, nonatomic) IBOutlet UILabel *sellPrice;
@property (weak, nonatomic) IBOutlet UILabel *cenPrice;
@property (weak, nonatomic) IBOutlet UILabel *currency1;
@property (weak, nonatomic) IBOutlet UILabel *cashBuyPrice1;
@property (weak, nonatomic) IBOutlet UILabel *remittanceBuyPrice1;
@property (weak, nonatomic) IBOutlet UILabel *sellPrice1;
@property (weak, nonatomic) IBOutlet UILabel *cenPrice1;
@property (weak, nonatomic) IBOutlet UILabel *time;
- (id)initWithExchange:(Exchange *)exchange;
@end
