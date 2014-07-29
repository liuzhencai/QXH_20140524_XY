//
//  NameCardViewController.m
//  QXH
//
//  Created by XueYong on 5/16/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "NameCardViewController.h"
#import "ChatController.h"
#import "NameCardTitleCell.h"
#import "AddFriendView.h"

@interface NameCardViewController ()<UITableViewDataSource, UITableViewDelegate,NameCardTitleDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *friendsList;//好友列表
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
        _items = @[@"工作单位",@"单位职务",@"所在城市",@"学位/职称",@"曾获荣誉",@"个人动态"];
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
    if (tableHeight > 180 + 44 * 6 + 30) {
        tableHeight = 180 + 44 * 6 + 30;
        scrollEnable = NO;
    }
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, tableHeight) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.scrollEnabled = scrollEnable;
    [self.view addSubview:_mainTable];
    
    [self getUserInfo];
    [self getAddressList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo{

    /*部落聊天中点击时，传入memberid
     部落成员列表中点击，传入memberDict
     */
    if (self.memberDict || self.memberId) {
        NSString *memberid = self.memberId;
        if (self.memberDict) {
            memberid = [self.memberDict objectForKey:@"userid"];
        }
        [DataInterface getUserInfo:memberid withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"获取用户信息返回值：%@",dict);
            self.userDetailInfo = dict;
            [_mainTable reloadData];
        }];
    }
}

- (void)getAddressList{
    /**
     *  获取好友(通讯录)/查找用户列表公用接口
     *
     *  @param type        1为获取好友列表，2为搜索
     *  @param address     籍贯编码
     *  @param domicile    居住地编码
     *  @param displayname 昵称
     *  @param usertype    用户类型,为空时不区分类型
     *  @param start       起始位置
     *  @param count       获取数量
     *  @param callback    回调
     */
    
    [DataInterface getFriendInfo:@"1"
                         address:@""
                        domicile:@""
                     displayname:@""
                        usertype:@""
                           start:@"0"
                           count:@"20"
           withCompletionHandler:^(NSMutableDictionary *dict){
               NSLog(@"通讯录列表返回数据：%@",dict);
               
               if (dict) {
                   NSArray *list = [dict objectForKey:@"lists"];
                   self.friendsList = list;
                   [self checkIsMyFriend];
                   [_mainTable reloadData];
               }
           }];
}
- (void)checkIsMyFriend{
    if (self.friendsList) {
        for (int i = 0; i < [self.friendsList count]; i ++) {
            NSDictionary *dict = [self.friendsList objectAtIndex:i];
            NSArray *list = [dict objectForKey:@"list"];
            for (int j = 0; j < [list count]; j ++) {
                NSDictionary *memberDict = [list objectAtIndex:j];
                NSString *friendId = [[memberDict objectForKey:@"userid"] stringValue];
                NSString *memberID = self.memberId;//[NSString stringWithFormat:@"%@",self.memberId];
                if (!memberID) {
                    memberID = [[self.memberDict objectForKey:@"userid"] stringValue];
                }
                if ([memberID isEqualToString:friendId]) {
                    self.isMyFriend = YES;
                    break;
                }
            }
        }
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
        if (self.isMyFriend) {
            cell.isMyFriend = self.isMyFriend;
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
            case 0://工作单位
                if (self.userDetailInfo) {
                    value = [self.userDetailInfo objectForKey:@"schoolname"];
                }
                break;
            case 1://单位职务
                if (self.userDetailInfo) {
                    value = [self.userDetailInfo objectForKey:@"title"];
                }
                break;
            case 2://所在城市
                if (self.userDetailInfo) {
//                    NSString *cityName = [self cityNameWithCode:[self.userDetailInfo objectForKey:@"domicile"]];
//                    value = cityName;
                    value = [self.userDetailInfo objectForKey:@"address"];
                }
                break;
            case 3://学校职务
                if (self.userDetailInfo) {
                    value = [self.userDetailInfo objectForKey:@"educations"];
                }
                break;
            case 4://曾获荣誉
                if (self.userDetailInfo) {
                    value = [self.userDetailInfo objectForKey:@"honours"];
                }
                break;
            case 5://个人动态
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
        if (self.isMyFriend) {
            NSLog(@"发起聊天");
            ChatController* chatview = [[ChatController alloc]init];
            chatview.otherDic = self.memberDict;
            [self.navigationController pushViewController:chatview animated:NO];
            
        }else{
            /**
             *  加好友请求
             *  @param targetid 被处理的加入成员的userid
             *  @param mess     好友请求验证消息
             *  @param callback 回调
             */
            if (self.memberDict || self.memberId) {
                NSString *memberid = self.memberId;
                if (self.memberDict) {
                    memberid = [self.memberDict objectForKey:@"userid"];
                }
                [DataInterface requestAddFriend:memberid mess:@"" withCompletionHandler:^(NSMutableDictionary *dict){
                    NSLog(@"%@",dict);
                    [self showAlert:[dict objectForKey:@"info"]];
                    [self getAddressList];
                }];
            }
        }
        
    }else{
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
