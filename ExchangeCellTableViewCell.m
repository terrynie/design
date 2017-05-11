//
//  ExchangeCellTableViewCell.m
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "ExchangeCellTableViewCell.h"


@implementation ExchangeCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithExchange:(Exchange *)exchange {
    _currency.text = exchange.currency;
    _remittanceBuyPrice.text = exchange.remittanceBuyPrice;
    _cashBuyPrice.text = exchange.cashBuyPrice;
    _sellPrice.text = exchange.sellPrice;
    _cenPrice.text = exchange.cenPrice;
    return self;
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}
@end
