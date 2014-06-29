//
//  SettingViewController.m
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SettingViewController.h"
#import "MsgSettingController.h"

@interface SettingViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
                    cell.textLabel.text = @"客服热线:400-100-9737";
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
            static NSString *cellIdntifier = @"thirdSection";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdntifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdntifier];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(26.5, 1.75, 267, 40.5);
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_screening_normal"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_screening_highlight"] forState:UIControlStateHighlighted];
                [btn setTitle:@"注销" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"客服热线" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alert show];
                }
                    break;
                case 2:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关于" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alert show];
                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}

- (void)logout:(id)sender
{
    NSLog(@"注销");

    [DataInterface logoutWithCompletionHandler:^(NSMutableDictionary *dict) {
        if ([defaults objectForKey:@"userid"]) {
            [defaults removeObjectForKey:@"userid"];
        }
        if ([defaults objectForKey:@"token"]) {
            [defaults removeObjectForKey:@"token"];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}

@end
