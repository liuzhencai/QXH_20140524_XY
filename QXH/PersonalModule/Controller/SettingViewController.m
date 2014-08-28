//
//  SettingViewController.m
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SettingViewController.h"
#import "MsgSettingController.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "HomePageController.h"
#import "AboutViewController.h"
#import "MessageBySend.h"
#import "UserInfoModelManger.h"
#import "MBProgressHUD.h"

@interface SettingViewController ()
{
    MBProgressHUD *progressHUD;
}

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    
    forceLogout = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 3;
            break;
        case 2:
            rows = 1;
            break;
        case 3:
            rows = 1;
            break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    switch (section) {
        case 0:
        {
            static NSString *cellIdntifier = @"firstSection";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdntifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdntifier];
            }
             cell.textLabel.text = @"消息设置";
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            static NSString *cellIdntifier = @"secondSection";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdntifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdntifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            switch (row) {
                case 0:
                {
                    cell.textLabel.text = @"检查新版本";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"客服热线:010-62952510";
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"关于";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            static NSString *cellIdntifier = @"secondSection";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdntifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdntifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = @"清空聊天记录";
        }
            break;
        case 3:
        {
            static NSString *cellIdntifier = @"thirdSection";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdntifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdntifier];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(26.5, 1.75, 267, 40.5);
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_screening_normal"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_screening_highlight"] forState:UIControlStateHighlighted];
                [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
            }
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 0;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            MsgSettingController *controller = [[MsgSettingController alloc] initWithNibName:@"MsgSettingController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检查新版本" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alert show];
                }
                    break;
                case 1:
                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"客服热线" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//                    [alert show];
                }
                    break;
                case 2:
                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关于" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//                    [alert show];
                    AboutViewController *controller = [[AboutViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清空聊天记录" message:@"确认清空聊天记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1112;
            [alert show];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    exit(0);
    NSLog(@"buttonIndex->>%d",buttonIndex);
    if (alertView.tag == 1112&&buttonIndex == 1) {
        if ([DBManager sharedManager]) {
            [[MessageBySend sharMessageBySend]cleanAllData];
            [self showAlert:@"聊天记录清除成功"];
            if([[DBManager sharedManager] clearAllUserData]){
//                [self showAlert:@"清除成功"];
            }
        }
    }else if(alertView.tag == 1113){
        [[UserInfoModelManger sharUserInfoModelManger]cleanUser];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *homeNav = [delegate.tabController.viewControllers objectAtIndex:0];
        HomePageController *controller = [homeNav.viewControllers objectAtIndex:0];
        [controller loadPage];
        [delegate.tabController selectTab:0];
    }
}

- (void)logoutAction
{
    [progressHUD hide:YES];
    if ([defaults objectForKey:USER_NAME]) {
        [defaults removeObjectForKey:USER_NAME];
    }
    if ([defaults objectForKey:PASSWORLD]) {
        [defaults removeObjectForKey:PASSWORLD];
    }
    if ([defaults objectForKey:@"userid"]) {
        [defaults removeObjectForKey:@"userid"];
    }
    if ([defaults objectForKey:@"token"]) {
        [defaults removeObjectForKey:@"token"];
    }
    [defaults synchronize];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"退出成功！"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.tag = 1113;
    [alert show];
}

- (void)timeoutForceLogout
{
    if (!forceLogout) {
        [self logoutAction];
    }
}

- (void)logout:(id)sender
{
    NSLog(@"注销");
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.animationType = MBProgressHUDAnimationFade;
    progressHUD.labelFont = [UIFont systemFontOfSize:13.f];
    progressHUD.labelText = @"加载中...";
    [self.view addSubview:progressHUD];
    [progressHUD show:YES];
    
    /*改为5秒吧，30秒太长了，用户等不了*/
    [self performSelector:@selector(timeoutForceLogout) withObject:nil afterDelay:5.f];
    [DataInterface logoutWithCompletionHandler:^(NSMutableDictionary *dict) {
        forceLogout = YES;
        [self logoutAction];
    }];
}

@end
