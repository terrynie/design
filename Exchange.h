//
//  Exchange.h
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exchange : NSObject
@property(nonatomic, retain) NSString *bank;
@property(nonatomic, retain) NSString *currency;
@property(nonatomic, retain) NSString *code;
@property(nonatomic, retain) NSNumber *cenPrice;
@property(nonatomic, retain) NSNumber *remittanceBuyPrice;
@property(nonatomic, retain) NSNumber *cashBuyPrice;
@property(nonatomic, retain) NSNumber *sellPrice;
@property(nonatomic, retain) NSNumber *time;

- (id)initWithObject: (NSObject *)obj;
@end
