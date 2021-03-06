//
//  MyTribeDetailViewController.m
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "MyTribeDetailViewController.h"
#import "AddressListViewController.h"
#import "YSKeyboardTableView.h"
#import "UIButton+WebCache.h"
#import "AddOrDeleteMemberViewController.h"

@interface MyTribeDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property (nonatomic, strong) YSKeyboardTableView *mainTable;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIImage *headImage;//头像
@property (nonatomic, strong) NSString *imagePath;//图像上传成功后路径

@property (nonatomic, strong) UITextField *name;//部落名称
@property (nonatomic, strong) UITextField *leader;//秘书长
@property (nonatomic, strong) UITextField *sign;//签名
@property (nonatomic, strong) UITextField *place;//部落地域
@property (nonatomic, strong) UITextField *count;//人数

@property (nonatomic, strong) UITextView *tribeDes;//介绍
@property (nonatomic, strong) UILabel *placeHolder;//介绍的placeHolder

@property (nonatomic, strong) UISwitch *newsSwitch;//新消息通知
@property (nonatomic, strong) UISwitch *topSwitch;//置顶聊天

@property (nonatomic, strong) NSDictionary *leaderDict;//秘书长信息

@property (nonatomic, strong) NSDictionary *tribeDetailDict;//部落详细信息

@property (nonatomic, assign) BOOL isCreater;//是否是秘书长或者是创建人
@end

@implementation MyTribeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.isCreater = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"部落档案";
    // Do any additional setup after loading the view.
    
//    self.items = @[@"部落名称",@"部落秘书长",@"头像",@"部落标签",@"部落地域",@"新消息通知",@"置顶聊天",@"介绍",@"",@"清空缓存"];
//    if (self.isCreatDetail) {
//        self.items = @[@"部落名称",@"部落秘书长",@"头像",@"部落标签",@"部落地域",@"新消息通知",@"置顶聊天",@"介绍",@"当前部落成员"];
//    }
    self.items = @[@"部落名称",@"部落秘书长",@"头像",@"部落标签",@"部落地域",@"介绍",@"清空缓存"];
    if (self.isCreatDetail) {
        self.items = @[@"部落名称",@"部落秘书长",@"头像",@"部落标签",@"部落地域",@"介绍",@"当前部落成员"];
    }
    
    _mainTable = [[YSKeyboardTableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - 70) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [_mainTable setup];
    _mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_mainTable];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainTable.bottom, UI_SCREEN_WIDTH, 70)];
    //添加阴影
    footerView.backgroundColor = [UIColor clearColor];
    CGPathRef path = [UIBezierPath bezierPathWithRect:footerView.bounds].CGPath;
    [footerView.layer setShadowPath:path];
    footerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    footerView.layer.shadowOffset = CGSizeMake(0, 1);
    footerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    footerView.layer.shadowOpacity = 0.5f;
    [self.view addSubview:footerView];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake((footerView.width - 267)/2.0, (footerView.height - 40)/2.0, 267, 40);
    if (self.isCreatDetail) {
        [nextBtn setTitle:@"创建部落" forState:UIControlStateNormal];
    }else{
        [nextBtn setTitle:@"退出部落" forState:UIControlStateNormal];
    }
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_normal"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_highlight"] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(exitTribe:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextBtn];
    
    if (!self.isCreatDetail) {
        [self getTribeDetailInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTribeDetailInfo{
    /**
     *  获取部落信息
     *  @param tribeid  部落id
     *  @param callback 回调
     */
    if (self.tribeDict || self.tribeId) {
        NSString *tribeid = self.tribeId;
        if (self.tribeDict) {
            tribeid = [self.tribeDict objectForKey:@"tribeid"];
        }
        [DataInterface getTribeInfo:tribeid withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"获取部落详情信息返回值：%@",dict);
            self.tribeDetailDict = dict;
            NSInteger createrId = [[dict objectForKey:@"creater"] integerValue];
//            NSInteger secretaryId = [[dict objectForKey:@"secretary"] integerValue];
            NSInteger userId = [[defaults objectForKey:@"userid"] integerValue];
//            if (createrId == userId || secretaryId == userId) {
            if (createrId == userId) {//只有创建者才可以
                self.items = @[@"部落名称",@"部落秘书长",@"头像",@"部落标签",@"部落地域",@"介绍",@"",@"清空缓存"];
                self.isCreater = YES;
            }
            [_mainTable reloadData];
        }];
    }
}

- (void)exitTribe:(UIButton *)sender{
    NSLog(@"exit tribe");
    if (self.isCreatDetail) {
        
        if ([self.name.text length] <= 0) {
            [self showAlert:@"请输入部落名称"];
            return;
        }
        
        if ([self.leader.text length] <= 0) {
            [self showAlert:@"请选择部落秘书长"];
            return;
        }
        
        if ([self.sign.text length] <= 0) {
            [self showAlert:@"请输入部落标签"];
            return;
        }
        
        if ([self.place.text length] <= 0) {
            [self showAlert:@"请输入部落地域"];
            return;
        }
        
        if ([self.count.text length] <= 0) {
            [self showAlert:@"请输入部落成员数量"];
            return;
        }
        
        if (self.headImage) {
            /**
             *  文件上传
             *  @param file     UIImage对象或文件URL
             *  @param type     1为图片，2为文档，3为音频
             *  @param callback 回调
             */
            [DataInterface fileUpload:self.headImage
                                 type:@"1"
                withCompletionHandler:^(NSMutableDictionary *dict){
                    NSLog(@"上传图片返回值%@",dict);
                    self.imagePath = [dict objectForKey:@"filename"];
                    [self submitIsHaveHeadImage:YES];
                }errorBlock:^(NSString *desc) {
                    NSLog(@"上传图片错误：%@",desc);
                    [self showAlert:desc];
                }];
        }else{
            [self submitIsHaveHeadImage:NO];
        }
    }else{//退出部落
        /**
         *  退出部落
         *  @param targetid 被处理的退出成员的userid(如果该字段与userid相同为主动退出，不相同，为管理者踢出部落)
         *  @param tribeid  部落唯一标示
         *  @param callback 回调
         */
        NSString *userId = [[defaults objectForKey:@"userid"] stringValue];
        NSString *tribeId = [[self.tribeDict objectForKey:@"tribeid"] stringValue];
        [DataInterface quitTribe:userId  //100013
                         tribeid:tribeId
           withCompletionHandler:^(NSMutableDictionary *dict){
               NSLog(@"退出部落返回值：%@",dict);
               [self showAlert:[dict objectForKey:@"info"]];
        }];
    }
}

- (void)submitIsHaveHeadImage:(BOOL)isImage{
    /**
     *  创建部落
     *
     *  @param tribename  部落名称
     *  @param tribestyle 部落类型
     *  @param userid     秘书长userid
     *  @param signature  部落签名
     *  @param desc       部落描述
     *  @param condition  加入条件
     *  @param purpose    宗旨
     *  @param rule       章程
     *  @param tags       不同标签之间用逗号隔开
     *  @param district   地域信息
     *  @param maxcount   最多人数
     *  @param members    部落成员，成员(userid)之间以逗号隔开
     *  @param callback   回调
     */
    
    NSString *leaderId = @"";
    if (self.leaderDict) {
        leaderId = [self.leaderDict objectForKey:@"userid"];
    }
    NSString *desStr = @"";
    if ([self.tribeDes.text length] > 0) {
        desStr = self.tribeDes.text;
    }
    
    NSString *membersString = @"";
    int memberCount = [self.membersArray count];
    for (int i = 0; i < memberCount; i ++) {
        NSDictionary *member = [self.membersArray objectAtIndex:i];
        id memberIdStrsss = [member objectForKey:@"userid"];
        NSString *memberIdStr = [NSString stringWithFormat:@"%@",memberIdStrsss];
        if (i != memberCount - 1) {
            memberIdStr = [NSString stringWithFormat:@"%@,",memberIdStr];
        }
        membersString = [membersString stringByAppendingString:memberIdStr];
    }
    /*还要添加秘书长进入部落成员中*/
    if (leaderId) {
        NSString* memstring  = [membersString stringByAppendingString:[NSString stringWithFormat:@"%@",leaderId]];
        if ([membersString length] > 0) {
            membersString = [membersString stringByAppendingString:[NSString stringWithFormat:@",%@",leaderId]];
        }else{
            membersString = memstring;
        }
    }
    NSString *imageUrl = @"";
    if (isImage) {
        imageUrl = self.imagePath;
    }
    [DataInterface createTribe:self.name.text
                    tribestyle:@""
                     secretary:leaderId  //userid
                     signature:self.sign.text
                          desc:desStr
                     condition:@""
                       purpose:@""
                          rule:@""
                          tags:@""
                      district:self.place.text
                         photo:imageUrl
                      maxcount:self.count.text
                       members:membersString
         withCompletionHandler:^(NSMutableDictionary *dict){
             NSLog(@"创建部落返回值：%@",dict);
             [self showAlert:[dict objectForKey:@"info"]];
             NSArray *controllers = self.navigationController.viewControllers;
             [self.navigationController popToViewController:[controllers objectAtIndex:[controllers count] - 3] animated:YES];
         }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    bgView.image = [UIImage imageNamed:@"bar_transition"];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 7) {
//        return 80;
//    }
    if (indexPath.row == 5) {
        return 80;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *title = [self addLabelWithFrame:CGRectMake(20, (cell.height - 30)/2.0, 280, 30)
                                            text:@""
                                           color:[UIColor blackColor]
                                            font:[UIFont systemFontOfSize:14]];
        title.tag = 200;
        [cell.contentView addSubview:title];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, UI_SCREEN_WIDTH, 0.5)];
        line.tag = 333;
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
    }
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:200];
    titleLabel.frame = CGRectMake(20, (cell.height - 30)/2.0, 100, 30);
    titleLabel.text = [_items objectAtIndex:indexPath.row];
    
    UIView *subView = [cell.contentView viewWithTag:201];
    [subView removeFromSuperview];
    switch (indexPath.row) {
        case 0:{//部落名称
            if (!_name) {
                _name = [self addTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 180, 30)
                                        placeHolder:@""];
                _name.tag = 201;
                _name.enabled = NO;
            }
            if (self.isCreatDetail) {
                _name.placeholder = @"输入部落名称";
                _name.enabled = YES;
            }else{
                if (self.tribeDetailDict) {
                    _name.text = [self.tribeDetailDict objectForKey:@"tribename"];
                }
            }
            [cell.contentView addSubview:_name];
        }
            break;
        case 1:{//选择秘书长
            if (!_leader) {
                _leader = [self addTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 180, 30)
                                          placeHolder:@""];
                _leader.tag = 201;
                _leader.enabled = NO;
            }
            
            if (self.isCreatDetail) {
                _leader.placeholder = @"选择部落秘书长";
                if (self.leaderDict) {
                    NSString *leaderName = [self.leaderDict objectForKey:@"displayname"];
                    if (leaderName.length <= 0) {
                        leaderName = @"姓名为空";
                    }
                    _leader.text = leaderName;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                if (self.tribeDetailDict) {
                    _leader.text = [self.tribeDetailDict objectForKey:@"secretaryname"];
                }
            }
            
            [cell.contentView addSubview:_leader];
        }
            break;
        case 2:{//头像
            UIButton *head = [UIButton buttonWithType:UIButtonTypeCustom];
            head.frame = CGRectMake(cell.contentView.width - 36 - 10, (cell.contentView.height - 36)/2.0, 36, 36);
            [head setBackgroundImage:[UIImage imageNamed:@"img_portrait72"] forState:UIControlStateNormal];
            [head setRound:YES];
            head.tag = 201;
            [head addTarget:self action:@selector(addHeadImage:) forControlEvents:UIControlEventTouchUpInside];
            head.enabled = NO;
            if (self.isCreatDetail) {
                head.enabled = YES;
                if (self.headImage) {
                   [head setBackgroundImage:self.headImage forState:UIControlStateNormal];
                }
            }else{
                if (self.tribeDetailDict) {
                    NSString *headImageUrlString = [self.tribeDetailDict objectForKey:@"photo"];
                    [head setImageWithURL:IMGURL(headImageUrlString) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_portrait72"]];
                }
            }
            [cell.contentView addSubview:head];
        }
            break;
        case 3:{//部落标签
            if (!_sign) {
                _sign = [self addTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 180, 30)
                                        placeHolder:@""];
                _sign.tag = 201;
                _sign.enabled = NO;
            }
            if (self.isCreatDetail) {
                _sign.placeholder = @"输入部落标签";
                _sign.enabled = YES;
            }else{
                if (self.tribeDetailDict) {
                    _sign.text = [self.tribeDetailDict objectForKey:@"tags"];
                }
            }
            [cell.contentView addSubview:_sign];
        }
            break;
        case 4:{//部落地域
            if (!_place) {
                _place = [self addTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 180, 30)
                                        placeHolder:@""];
                _place.tag = 201;
                _place.enabled = NO;
            }
            if (self.isCreatDetail) {
                _place.placeholder = @"输入部落地址";
                _place.enabled = YES;
            }else{
                _place.text = [self.tribeDetailDict objectForKey:@"districtname"];
            }
            [cell.contentView addSubview:_place];
        }
            break;
//        case 5:{//新消息通知
//            if (!_newsSwitch) {
//                _newsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.width - 50 - 10, (cell.contentView.height - 30)/2.0, 50, 30)];
//                _newsSwitch.tag = 201;
//                _newsSwitch.on = YES;
//                [_newsSwitch addTarget:self action:@selector(newsSwitchAction:) forControlEvents:UIControlEventValueChanged];
//            }
//            [cell.contentView addSubview:_newsSwitch];
//        }
//            break;
//        case 6:{//置顶聊天
//            if (!_topSwitch) {
//                _topSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.width - 50 - 10, (cell.contentView.height - 30)/2.0, 50, 30)];
//                _topSwitch.tag = 201;
//                _topSwitch.on = NO;
//                [_topSwitch addTarget:self action:@selector(topSwitchAction:) forControlEvents:UIControlEventValueChanged];
//            }
//            [cell.contentView addSubview:_topSwitch];
//        }
//            break;
        case 5:{//介绍
            titleLabel.frame = CGRectMake(20, (44 - 30)/2.0, 100, 30);
            UIView *line = (UIView *)[cell.contentView viewWithTag:333];
            CGRect lineFrame = line.frame;
            lineFrame.origin.y = 80 - 0.5;
            line.frame = lineFrame;
            if (!_tribeDes) {
                _tribeDes = [[UITextView alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 200, 80 - 14)];
                _tribeDes.tag = 201;
                _tribeDes.delegate = self;
                _tribeDes.editable = NO;
                _placeHolder = [self addLabelWithFrame:CGRectMake(0, 0, _tribeDes.width, 20)
                                                  text:@"部落介绍(少于140字)"
                                                 color:[UIColor lightGrayColor]
                                                  font:[UIFont systemFontOfSize:14.0]];
                _placeHolder.enabled = NO;
                _placeHolder.backgroundColor = [UIColor clearColor];
                [_tribeDes addSubview:_placeHolder];
            }
            if (self.isCreatDetail) {
                _tribeDes.editable = YES;
                
            }else{
                _placeHolder.text = @"";
                if (self.tribeDetailDict) {
                    _tribeDes.text = [self.tribeDetailDict objectForKey:@"desc"];
                }
            }
            [cell.contentView addSubview:_tribeDes];
        }
            break;
        case 6:{//当前成员数
            if (self.isCreatDetail) {
                if (!_count) {
                    _count = [self addTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 180, 30)
                                             placeHolder:@""];
                    _count.tag = 201;
                    _count.enabled = NO;
                }
                _count.text = [NSString stringWithFormat:@"%d",[self.membersArray count] + 1];
                [cell.contentView addSubview:_count];
            }else{
                if (self.isCreater) {//等于8本人是秘书长或者创建者，等于7时本人为成员
                    for (int i = 0; i < 2; i ++) {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(20 + (130 + 20) * i, 7, 130, 30);
                        [button addTarget:self action:@selector(addOrDeleteMembers:) forControlEvents:UIControlEventTouchUpInside];
                        
                        button.tag = 880 + i;
                        if (i == 0) {
                            [button setTitle:@"添加成员" forState:UIControlStateNormal];
                            [button setBackgroundImage:[self stretchiOS6:@"btn_enroll_highlight.png"] forState:UIControlStateNormal];
                            [button setBackgroundImage:[self stretchiOS6:@"btn_enroll_highlight.png"] forState:UIControlStateHighlighted];
                        }else{
                            [button setTitle:@"删除成员" forState:UIControlStateNormal];
                            [button setBackgroundImage:[self stretchiOS6:@"btn_share_normal.png"] forState:UIControlStateNormal];
                            [button setBackgroundImage:[self stretchiOS6:@"btn_share_highlight.png"] forState:UIControlStateHighlighted];
                        }
                        [cell.contentView addSubview:button];
                    }
                }else{
                    UIView *view1 = [cell.contentView viewWithTag:880];
                    [view1 removeFromSuperview];
                    UIView *view2 = [cell.contentView viewWithTag:881];
                    [view2 removeFromSuperview];
                }
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    if (self.isCreatDetail) {
        if (indexPath.row == 1) {
            AddressListViewController *addressList = [[AddressListViewController alloc] init];
            addressList.addressListBlock = ^(NSDictionary *dict){
                NSLog(@"通讯录列表返回值%@",dict);
                //从member列表里剔除秘书长
                [self membersListIsHaveUser:dict];
                
                self.leaderDict = dict;
                NSString *leaderName = [dict objectForKey:@"displayname"];
                if ([leaderName length] > 0) {
                    self.leader.text = leaderName;
                }else{
                    self.leader.text = @"";
                }
            };
            [self.navigationController pushViewController:addressList animated:YES];
        }
    }else{
        if (self.isCreater) {
            if (indexPath.row == 7) {
                [self showAlert:@"缓存已清空"];
            }
        }else{
            if (indexPath.row == 6) {
                [self showAlert:@"缓存已清空"];
            }
        }
    }
}

- (BOOL)membersListIsHaveUser:(NSDictionary *)userInfo{
    BOOL isHaveInMembers = NO;//是否存在
    int index = 0;
    NSInteger newUserId = [[userInfo objectForKey:@"userid"] integerValue];
    for (int i = 0; i < [self.membersArray count]; i ++) {
        NSDictionary *userInfo = [self.membersArray objectAtIndex:i];
        NSInteger userId = [[userInfo objectForKey:@"userid"] integerValue];
        if (newUserId == userId) {
            isHaveInMembers = YES;
            index = i;
            break;
        }
    }
    if (isHaveInMembers) {
        [self.membersArray removeObjectAtIndex:index];
        [self.mainTable reloadData];
    }
    return isHaveInMembers;
}

- (void)addOrDeleteMembers:(UIButton *)sender{
    NSLog(@"添加或删除成员");
    int index = sender.tag - 880;
    AddOrDeleteMemberViewController *addMemberCon = [[AddOrDeleteMemberViewController alloc] init];
    addMemberCon.tribeDict = self.tribeDict;
    if (index == 0) {//添加成员
        addMemberCon.type = addTribeMemberType;
        addMemberCon.title = @"添加成员";
    }else{//删除成员
        addMemberCon.type = deleteTribeMemberType;
        addMemberCon.title = @"删除成员";
    }
    [self.navigationController pushViewController:addMemberCon animated:YES];
}

- (void)newsSwitchAction:(UISwitch *)newsSwitch{
    NSLog(@"news:%d",newsSwitch.on);
}

- (void)topSwitchAction:(UISwitch *)topSwitch{
    NSLog(@"top:%d",topSwitch.on);
}

- (void)addHeadImage:(UIButton *)sender{
    NSLog(@"选择头像");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [alert show];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length >= 140) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHolder.text = @"部落介绍(少于140字)";
    }else{
        _placeHolder.text = @"";
    }
}

#pragma mark - UITextFieldDelegate
- (UITextField *)addTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    //    textField.textAlignment = NSTextAlignmentRight;
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    textField.placeholder = placeHolder;
    textField.returnKeyType = UIReturnKeyDone;
    //    textField.backgroundColor = [UIColor redColor];
    //    textField.textColor = UIColorFromRGB(0x000000);;
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    return textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    if ([mediaType isEqualToString:@"public.image"]){
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //图片压缩，因为原图都是很大的，不必要传原图
        NSLog(@"图片压缩前大小：%d",[UIImagePNGRepresentation(originImage) length]);
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];//[self scaleImage:originImage toScale:0.3];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        self.headImage = image;
        NSLog(@"图片压缩后大小：%d",[data length]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_mainTable reloadData];
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    switch (buttonIndex) {
        case 1:{//Take picture
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                NSLog(@"模拟器无法打开相机");
            }
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 2:{
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypePhotoLibrary]) {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

- (UIImage *) stretchiOS6:(NSString *)icon {
    UIImage *image = [UIImage imageNamed:icon];
    CGFloat normalLeftCap = image.size.width * 0.5f;
    CGFloat normalTopCap = image.size.height * 0.5f;
    // 13 * 34
    // 指定不需要拉伸的区域
    UIEdgeInsets insets = UIEdgeInsetsMake(normalTopCap, normalLeftCap, normalTopCap - 1, normalLeftCap - 1);
    
    // ios6.0的拉伸方式只不过比iOS5.0多了一个拉伸模式参数
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
}


@end
