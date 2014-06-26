//
//  EditCardController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "EditCardController.h"
#import "SchoolInfoController.h"
#import "CityViewController.h"
#import "SelfIntroduceController.h"
#import "HobbyViewController.h"
#import "StudyExperienceController.h"
#import "PhoneViewController.h"
#import "EverGloryController.h"

@interface EditCardController ()
{
    NSArray *titleArr;
    NSDictionary *userinfo;
}
@end

@implementation EditCardController
@synthesize UserRegisterState;

@synthesize valueArr;

- (void)viewWillAppear:(BOOL)animated
{
    if(UserRegisterState)
    {
        
    }else{
        [DataInterface getUserInfo:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary *dict) {
            userinfo = dict;
            NSString *phone = [userinfo objectForKey:@"phone"];
            if ([phone isEqualToString:@""]) {
                phone = @"无手机号";
            }
            valueArr = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@ %@",[userinfo objectForKey:@"schoolname"],[userinfo objectForKey:@"title"]], [NSString stringWithFormat:@"%@",[userinfo objectForKey:@"domicile"]], [userinfo objectForKey:@"introduce"], [userinfo objectForKey:@"hobbies"], [userinfo objectForKey:@"educations"], phone, [userinfo objectForKey:@"honours"], nil];
            [_editTable reloadData];
        }];
    }

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
    if (!self.title) {
        self.title = @"编辑名片";
    }
    
    
    _editTable.tableHeaderView = _topView;
    
    titleArr = @[@"学校信息（必填）", @"城市（必填）", @"自我介绍", @"兴趣爱好", @"学习经历", @"手机号", @"曾获荣誉"];
    
//    valueArr = [[NSMutableArray alloc] initWithObjects:@"北京市智障二中 校长", @"北京", @"您的详细介绍", @"您的兴趣爱好", @"您的教育经历", @"您的手机号", @"曾经获得的社会荣誉", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArr count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    if (indexPath.row == 0) {
        rowHeight = 30;
    }else{
        rowHeight = 48;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"firstCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            label.backgroundColor = RGBCOLOR(236, 245, 229);
            label.text = @"详细个人信息";
            label.textColor = GREEN_FONT_COLOR;
            [cell.contentView addSubview:label];
        }
    }else{
        static NSString *cellIdentifier = @"otherCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 21)];
            titleLabel.tag = 1;
            
            UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 200, 21)];
            descLabel.font = [UIFont systemFontOfSize:14.f];
            descLabel.textColor = [UIColor grayColor];
            descLabel.tag = 2;
            
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 13.5, 100, 21)];
            statusLabel.textColor = [UIColor grayColor];
            statusLabel.tag = 3;
            
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 7.5, 12.5)];
            arrowImage.image = [UIImage imageNamed:@"list_arrow_right_green"];
            
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:descLabel];
            [cell.contentView addSubview:statusLabel];
            [cell.contentView addSubview:arrowImage];
        }
        
        UILabel *titleLabel_ = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *descLabel_ = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *statusLabel_ = (UILabel *)[cell.contentView viewWithTag:3];

        titleLabel_.text = [titleArr objectAtIndex:indexPath.row-1];
        descLabel_.text = [valueArr objectAtIndex:indexPath.row-1];
        statusLabel_.text = @"已填写";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 1:
        {
            SchoolInfoController *controller = [[SchoolInfoController alloc] initWithNibName:@"SchoolInfoController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            CityViewController *controller = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
            SelfIntroduceController *controller = [[SelfIntroduceController alloc]initWithNibName:@"SelfIntroduceController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 4:
        {
            HobbyViewController *controller = [[HobbyViewController alloc] initWithNibName:@"HobbyViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:
        {
            StudyExperienceController *controller = [[StudyExperienceController alloc] initWithNibName:@"StudyExperienceController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 6:
        {
            PhoneViewController *controller = [[PhoneViewController alloc] initWithNibName:@"PhoneViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 7:
        {
            EverGloryController *controller = [[EverGloryController alloc] initWithNibName:@"EverGloryController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (IBAction)click:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"拍照");
        }
            break;feg
        case 1:
        {
            NSLog(@"从相册选取");
        }
            break;
        default:
            break;
    }
}

@end
