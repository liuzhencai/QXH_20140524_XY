//
//  NameCardViewController.m
//  QXH
//
//  Created by XueYong on 5/16/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "NameCardViewController.h"
#import "ChatViewController.h"
#import "NameCardTitleCell.h"

@interface NameCardViewController ()<UITableViewDataSource, UITableViewDelegate,NameCardTitleDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSDictionary *userDetailInfo;//用户详细信息
@end
#define WIDTH_TO_LEFT 15
#define HEIGHT_TO_TOP 15
#define HEIGHT_TITLE 120
@implementation NameCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _items = @[@"单位职务",@"所在城市",@"学位/职称",@"曾获荣誉",@"个人动态"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"个人名片";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    BOOL scrollEnable = YES;
    CGFloat tableHeight = UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT;
    if (tableHeight > 180 + 44 * 5 + 30) {
        tableHeight = 180 + 44 * 5 + 30;
        scrollEnable = NO;
    }
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, tableHeight) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.scrollEnabled = scrollEnable;
    [self.view addSubview:_mainTable];
    
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo{

    if (self.memberDict) {
        [DataInterface getUserInfo:[self.memberDict objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"获取用户信息返回值：%@",dict);
            self.userDetailInfo = dict;
            [_mainTable reloadData];
            [self showAlert:[dict objectForKey:@"info"]];
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return [_items count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
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
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifierTitle = @"identitierTitle";
        NameCardTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTitle];
        if (!cell) {
            cell = [[NameCardTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierTitle];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }

        if (self.userDetailInfo) {
            [cell resetCellParamDict:self.userDetailInfo];
        }
        return cell;
    }else{
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
                                               color:[UIColor blackColor]
                                                font:[UIFont systemFontOfSize:14]];
            value.tag = 201;
            [cell.contentView addSubview:value];
        }
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:200];
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:201];
        titleLabel.text = [_items objectAtIndex:indexPath.row];
        NSString *value = @"";
        switch (indexPath.row) {
            case 0://单位职务
                if (self.userDetailInfo) {
                    value = [self.userDetailInfo objectForKey:@"title"];
                }
//                value = @"北京市教育局局长";
                break;
            case 1://所在城市
//                value = @"北京";
                if (self.userDetailInfo) {
                    value = [self.userDetailInfo objectForKey:@"address"];
                }
                break;
            case 2://学校职务
//                value = @"教授";
                if (self.userDetailInfo) {
                    value = [self.userDetailInfo objectForKey:@"degree"];
                }
                break;
            case 3://曾获荣誉
//                value = @"国家级科技成就奖";
                if (self.userDetailInfo) {
                    value = [self.userDetailInfo objectForKey:@"honours"];
                }
                break;
            case 4://个人动态
//                value = @"不知道";
                if (self.userDetailInfo) {
                    value = [self.userDetailInfo objectForKey:@"signature"];
                }
                break;
                
            default:
                break;
        }
        valueLabel.text = value;
        return cell;
    }
}

#pragma mark - NameCardTitleDelegate
- (void)didSelectButtonWithIndex:(int)index{
    NSLog(@"选择： %d",index);
    if (index == 1) {
        /**
         *  加好友确认/修改备注
         *
         *  @param targetid 被处理的加入成员的userid
         *  @param type     0为同意并添加对方为好友(备注不为空添加备注)，1为同意但不添加对方为好友，2为拒绝，3为修改备注
         *  @param remark   备注
         *  @param callback 回调
         */

        
//        [DataInterface addFriendConfirm:@"100013" type:@"0" remark:@"照站" withCompletionHandler:^(NSMutableDictionary *dict){
//            NSLog(@"加为好友返回值：%@",dict);
//            [self showAlert:[dict objectForKey:@"info"]];
//        }];
        
        /**
         *  加好友请求
         *
         *  @param targetid 被处理的加入成员的userid
         *  @param mess     好友请求验证消息
         *  @param callback 回调
         */
        if (self.memberDict) {
            [DataInterface requestAddFriend:[self.memberDict objectForKey:@"userid"] mess:@"我是张三" withCompletionHandler:^(NSMutableDictionary *dict){
                NSLog(@"%@",dict);
                [self showAlert:[dict objectForKey:@"info"]];
            }];
        }
    }else{
        [self showAlert:@"转发名片"];
    }
    
}

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                         color:(UIColor *)color
                          font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = text;
    if (color) {
        label.textColor = color;
    }
    return label;
}

@end
