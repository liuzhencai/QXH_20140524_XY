//
//  MyCardController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "MyCardController.h"
#import "EditCardController.h"
#import "SelectTribeController.h"

@interface MyCardController ()
{
    NSArray *items;
    NSDictionary *userinfo;
}

@end

@implementation MyCardController

- (void)viewWillAppear:(BOOL)animated
{
    [DataInterface getUserInfo:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary *dict) {
        userinfo = dict;
        [self configureTopView];
        [_cardTable reloadData];
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

- (void)configureTopView
{
    [_portraitView circular];
    [_portraitView setImageWithURL:IMGURL([userinfo objectForKey:@"photo"]) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    _nameLabel.text = [userinfo objectForKey:@"displayname"];
    _titleLabel.text = [userinfo objectForKey:@"title"];
    if ([[userinfo objectForKey:@"phone"] isEqualToString:@""]) {
        _phoneLabel.text = @"无电话";
    }else{
        _phoneLabel.text = [userinfo objectForKey:@"phone"];
    }
    _emailLabel.text = [userinfo objectForKey:@"email"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人名片";
    items = @[@"单位职务",@"所在城市",@"曾获荣誉", @"工作单位",@"兴趣爱好",@"毕业学校", @"手机号码", @"个性签名"];
    _cardTable.tableHeaderView = _topView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"点击了编辑资料");
            EditCardController *controller = [[EditCardController alloc] initWithNibName:@"EditCardController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"点击了转发名片");

//            [self showAlert:@"点击了转发名片"];
            SelectTribeController *controller = [[SelectTribeController alloc] initWithNibName:@"SelectTribeController" bundle:nil];
            controller.parentController = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        bgImgView.image = [UIImage imageNamed:@"bar_transition"];
        
        //59,140,77//3,93,0
        UILabel *title = [self addLabelWithFrame:CGRectMake(20, 0, 200, 30)
                                            text:@"详细个人信息"
                                           color:COLOR_WITH_ARGB(3, 93, 0, 1.0)
                                            font:[UIFont systemFontOfSize:14]];
        title.backgroundColor = [UIColor clearColor];
        [bgImgView addSubview:title];
        return bgImgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *title = [self addLabelWithFrame:CGRectMake(20, (cell.height - 30)/2.0, 80, 30)
                                            text:@""
                                           color:[UIColor blackColor]
                                            font:[UIFont systemFontOfSize:14]];
        title.tag = 200;
        [cell.contentView addSubview:title];
        
        UILabel *value = [self addLabelWithFrame:CGRectMake(title.right, (cell.height - 30)/2.0, 180, 30)
                                            text:@""
                                           color:[UIColor lightGrayColor]
                                            font:[UIFont systemFontOfSize:14]];
        value.tag = 201;
        [cell.contentView addSubview:value];
    }
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:200];
    UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:201];
    titleLabel.text = [items objectAtIndex:indexPath.row];
    NSString *value = @"";
    switch (indexPath.row) {
        case 0:
            value = [userinfo objectForKey:@"title"];
            break;
        case 1:
            value = [self cityNameWithCode:[userinfo objectForKey:@"domicile"]];
            break;
        case 2:
            value = [userinfo objectForKey:@"honours"];
            break;
        case 3:
            value = [userinfo objectForKey:@"comname"];
            break;
        case 4:
            value = [userinfo objectForKey:@"hobbies"];
            break;
        case 5:
            value = [userinfo objectForKey:@"educations"];
            break;
        case 6:
            value = [userinfo objectForKey:@"phone"];
            break;
        case 7:
            value = [userinfo objectForKey:@"signature"];
            break;
        default:
            break;
    }
    valueLabel.text = value;
    return cell;
}

- (void)transmitNameCard:(NSString *)tribeid
{
        [DataInterface shareContent:[defaults objectForKey:@"userid"] sourcetype:@"4" sharetype:@"2" targetid:tribeid withCompletionHandler:^(NSMutableDictionary *dict) {
            [self showAlert:[dict objectForKey:@"info"]];
        }];
}

@end
