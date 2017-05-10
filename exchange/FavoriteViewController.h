//
//  FavoriteViewController.h
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "ViewController.h"

@interface FavoriteViewController : ViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
