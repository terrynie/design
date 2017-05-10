//
//  ExchangeListViewController.h
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "ViewController.h"

@interface ExchangeListViewController : ViewController <UITableViewDataSource, UITableViewDelegate,UIViewControllerPreviewingDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
