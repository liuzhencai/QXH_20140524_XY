//
//  SettingViewController.m
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SettingViewController.h"

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
            rows = 2;
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
            switch (row) {
                case 0:
                {
                    cell.textLabel.text = @"消息设置";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"隐私";
                }
                    break;
                default:
                    break;
            }
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

- (void)logout:(id)sender
{
    NSLog(@"注销");
    [self showAlert:@"注销"];
}

@end
