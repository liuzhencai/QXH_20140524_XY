//
//  PersonalInfoController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "PersonalInfoController.h"
#import "MyCardController.h"
#import "MyActivityController.h"
#import "MyTribeController.h"
#import "PersonalCollectionController.h"
#import "MemberRuleController.h"
#import "SettingViewController.h"
#import "MyVisitorController.h"

@interface PersonalInfoController ()
{
    NSDictionary *userinfo;
}

@end

@implementation PersonalInfoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [DataInterface getUserInfo:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary *dict) {
        userinfo = dict;
        [_meTable reloadData];
    }];
}

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
    self.title = @"我";
     self.hidesBottomBarWhenPushed = NO;
    titleArray = @[@"我的分享",@"我的收藏",@"我的活动", @"我的部落", @"我的访客", @"会员章程",@"设置"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    if (indexPath.row == 0) {
        rowHeight = 80;
    }else if(indexPath.row == 1){
        rowHeight = 20;
    }else{
        rowHeight = 44;
    }
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *firstCell = @"firstCell";
        cell = [tableView dequeueReusableCellWithIdentifier:firstCell];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCell];
            
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 48, 48)];
            iconImage.tag = 1000;
            [cell.contentView addSubview:iconImage];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 100, 21)];
            nameLabel.tag = 1001;
            [cell.contentView addSubview:nameLabel];
            
            UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 180, 21)];
            positionLabel.tag = 1002;
            [cell.contentView addSubview:positionLabel];
        }
        UIImageView *iconImage_ = (UIImageView *)[cell.contentView viewWithTag:1000];
        [iconImage_ circular];
        [iconImage_ setImageWithURL:IMGURL([userinfo objectForKey:@"photo"]) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];

        UILabel *nameLabel_ = (UILabel *)[cell.contentView viewWithTag:1001];
        nameLabel_.text = [userinfo objectForKey:@"displayname"];
        UILabel *positionLabel_ = (UILabel *)[cell.contentView viewWithTag:1002];
        positionLabel_.text = [userinfo objectForKey:@"title"];
    }else if(indexPath.row == 1){
        static NSString *secondCell = @"secondCell";
        cell = [tableView dequeueReusableCellWithIdentifier:secondCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            topLabel.backgroundColor = RGBCOLOR(193, 214, 177);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            label.backgroundColor = RGBCOLOR(236, 245, 229);
            UILabel *bottomLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 19, 320, 1)];
            bottomLabel.backgroundColor = RGBCOLOR(193, 214, 177);
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:topLabel];
            [cell.contentView addSubview:bottomLabel];
        }
    }
    else{
        static NSString *otherCell = @"otherCell";
        cell = [tableView dequeueReusableCellWithIdentifier:otherCell];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCell];
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 7.5, 12.5)];
            arrowImage.image = [UIImage imageNamed:@"list_arrow_right_green"];
            [cell.contentView addSubview:arrowImage];
        }
        cell.textLabel.text = titleArray[indexPath.row-1];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            MyCardController *controller = [[MyCardController alloc] initWithNibName:@"MyCardController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            PersonalCollectionController *controller = [[PersonalCollectionController alloc] initWithNibName:@"PersonalCollectionController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
            MyActivityController *controller = [[MyActivityController alloc] initWithNibName:@"MyActivityController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 4:
        {
            MyTribeController *controller = [[MyTribeController alloc] initWithNibName:@"MyTribeController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:
        {
            MyVisitorController *controller = [[MyVisitorController alloc] initWithNibName:@"MyVisitorController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 6:
        {
            MemberRuleController *controller = [[MemberRuleController alloc] initWithNibName:@"MemberRuleController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 7:
        {
            SettingViewController *controller = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
