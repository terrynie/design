//
//  Exchange.m
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "Exchange.h"
@interface Exchange()

@end

@implementation Exchange
-(id)initWithObject:(NSObject *)obj {
    _bank = [obj valueForKey:@"bank"];
    _currency = [obj valueForKey:@"currency"];
    _cenPrice = [obj valueForKey:@"cenPrice"];
    _remittanceBuyPrice = [obj valueForKey:@"remittanceBuyPrice"];
    _cashBuyPrice = [obj valueForKey:@"cashBuyPrice"];
    _sellPrice = [obj valueForKey:@"sellPrice"];
    _time = [obj valueForKey:@"timestamp"];
    
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"{\"bank\":\"%@\",\"currency\":\"%@\",\"cenPrice\":%@,\"remittanceBuyPrice\":%@,\"cashBuyPrice\":%@, \"sellPrice\":%@,\"timestamp\":%@}",self.bank,self.currency,self.cenPrice,self.remittanceBuyPrice, self.cashBuyPrice,self.sellPrice,self.time];
}
@end
