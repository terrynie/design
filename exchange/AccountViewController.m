//
//  AccountViewController.m
//  exchange
//
//  Created by Terry on 2017/5/5.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "AccountViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "ChangePasswordViewController.h"

@interface AccountViewController ()
@property UITableView *personalTableView;
@property NSArray *dataSource;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _personalTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, self.view.bounds.size.width, self.view.bounds.size.height-20-44-49) style:UITableViewStyleGrouped];
    [self.view addSubview:_personalTableView];
    _personalTableView.delegate=self;
    _personalTableView.dataSource=self;
    _personalTableView.bounces=NO;
    _personalTableView.showsVerticalScrollIndicator = YES;//不显示右侧滑块
    _personalTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    _dataSource=@[@"修改密码",@"用户协议",@"关于"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        return 3;
    } else {
        return 2;
    }
}

//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
            return _dataSource.count;
        } else {
            return 1;
        }
    }else{
        return 1;
    }
}
//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 40;
    }
    return 20;
}
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    } else if(indexPath.section == 2) {
        return 60;
    }
    return 40;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"cell";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    if (indexPath.section==0) {
        cell=[[UITableViewCell alloc] init];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 80)];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
            nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        } else {
            nameLabel.text=@"未登录";
        }
        [cell.contentView addSubview:nameLabel];
    } else if (indexPath.section==1) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
            cell.textLabel.text=[_dataSource objectAtIndex:indexPath.row];
        } else {
            cell.textLabel.text = @"请登陆";
            cell.backgroundColor = [UIColor redColor];
            cell.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 60);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    } else {
        cell.textLabel.text = @"注销账户";
        cell.backgroundColor = [UIColor redColor];
        cell.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 60);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"username"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        LoginViewController *lc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:lc animated:YES];
    } else {
        if (indexPath.section == 2 && indexPath.row == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"成功注销账户！";
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hide:YES afterDelay:3];
            [_personalTableView reloadData];
        } else if(indexPath.section == 1 && indexPath.row == 0) {
            ChangePasswordViewController *cv = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:cv animated:YES];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [_personalTableView reloadData];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]);
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
}

@end
