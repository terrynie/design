//
//  Reachable.h
//  exchange
//
//  Created by Terry on 2017/5/8.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface Reachable : NSObject
+ (BOOL)isConnectionAvailableInView: (UIView *) view;
@end
