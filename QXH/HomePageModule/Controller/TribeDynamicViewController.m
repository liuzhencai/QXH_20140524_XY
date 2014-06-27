//
//  TribeDynamicViewController.m
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "TribeDynamicViewController.h"
#import "CustomSegmentView.h"
#import "MyTribeDetailViewController.h"
#import "ActivityCell.h"
#import "PeocelCell.h"
#import "TribeQuestionCell.h"
#import "TribeConversationCell.h"
#import "CustomSegmentControl.h"
#import "InActivityCell.h"

#import "ActivityDetailViewController.h"
#import "NameCardViewController.h"

@interface TribeDynamicViewController ()<CustomSegmentControlDelegate>
//@property (nonatomic, strong) UITableView *conversationTable;//会话
//@property (nonatomic, strong) UITableView *activityTable;//活动
//@property (nonatomic, strong) UITableView *membersTable;//成员

@property (nonatomic, strong) NSMutableArray *activitysList;//活动列表
@property (nonatomic, strong) NSMutableArray *membersList;//成员列表


@end
#define CONVERSATION_TABLE_TAG 2330
#define ACTIVITY_TABLE_TAG 2331
#define NEMBERS_TABLE_TAG 2332

@implementation TribeDynamicViewController

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
    self.title = [self.tribeInfoDict objectForKey:@"tribename"];
    // Do any additional setup after loading the view.
    
    //测试数据
//    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < 20; i ++) {
//        [tmpArr addObject:@{@"":@""}];
//    }
//    self.activitysList = [NSArray arrayWithArray:tmpArr];
//    self.membersList = [NSArray arrayWithArray:tmpArr];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 40);
    [rightBtn setTitle:@"部落档案" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32) andTitles:@[@"会话",@"活动",@"成员"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    CGRect tableFrame = CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height);
    UITableView *activityTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    activityTable.tag = ACTIVITY_TABLE_TAG;
    activityTable.delegate = self;
    activityTable.dataSource = self;
    [self.view addSubview:activityTable];
    
    UITableView *membersTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    membersTable.tag = NEMBERS_TABLE_TAG;
    membersTable.delegate = self;
    membersTable.dataSource = self;
    [self.view addSubview:membersTable];
    
    UITableView *conversationTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    conversationTable.tag = CONVERSATION_TABLE_TAG;
    conversationTable.delegate = self;
    conversationTable.dataSource = self;
    [self.view addSubview:conversationTable];
    //获取部落信息
    [self getTribeInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTribeInfo{
    /**
     *  获取部落信息
     *
     *  @param tribeid  部落id
     *  @param callback 回调
     */
    if (self.tribeInfoDict) {
        NSString *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
        [DataInterface getTribeInfo:tribeId withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"部落信息返回值：%@",dict);
            [self showAlert:[dict objectForKey:@"info"]];
        }];
    }
}

- (void)getActivityListInTribe{
    //获取活动列表
    /**
     *  获取/搜索活动列表(列表按创建时间的逆序排列)
     *
     *  @param start     起始消息的artid，不填写该字段读取最新消息n个
     *  @param count     获取消息数量
     *  @param actname   活动名称
     *  @param tag       标签
     *  @param district  地域信息
     *  @param canjoin   0为全部活动，1为未参加的活动,2为已参加的活动
     *  @param actstate  活动状态 0为全部，1为未开始的活动，2为正在进行的活动，3为已结束的活动
     *  @param begindate 活动起始时间
     *  @param enddate   活动结束时间
     *  @param callback  回调
     */
    if (self.tribeInfoDict) {
        [DataInterface getActList:@"0"
                            count:@"20"
                          actname:@""
                    contentlength:@"30"
                              tag:@""
                         district:@""
                          canjoin:@"0"
                         actstate:@"0"
                          tribeid:[self.tribeInfoDict objectForKey:@"tribeid"]
                        begindate:@""
                          enddate:@""
            withCompletionHandler:^(NSMutableDictionary *dict){
                NSLog(@"活动列表返回数据:%@",dict);
                NSArray *list = [dict objectForKey:@"list"];
                self.activitysList = [NSMutableArray arrayWithArray:list];
                UITableView *table = (UITableView *)[self.view viewWithTag:ACTIVITY_TABLE_TAG];
                [table reloadData];
                [self showAlert:[dict objectForKey:@"info"]];
            }];
    }
}

- (void)detail:(UIButton *)sender{
    NSLog(@"详细资料");
    MyTribeDetailViewController *myTribeDetail = [[MyTribeDetailViewController alloc] init];
    myTribeDetail.tribeDict = self.tribeInfoDict;
    [self.navigationController pushViewController:myTribeDetail animated:YES];
}

#pragma mark - CustomSegmentControlDelegate
- (void)segmentClicked:(NSInteger)index{
    NSLog(@"segment clicked:%d",index);
    if (index == 1) {
        [self getActivityListInTribe];
    }else if (index == 2) {
        if (self.tribeInfoDict) {
            /**
             *  获取部落成员列表
             *
             *  @param tribeid  部落id
             *  @param callback 回调
             */
            NSString *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
            [DataInterface getTribeMembers:tribeId withCompletionHandler:^(NSMutableDictionary *dict){
                NSLog(@"获取部落成员列表返回值:%@",dict);
                NSArray *memberList = [dict objectForKey:@"list"];
                self.membersList = [NSMutableArray arrayWithArray:memberList];
                UITableView *table = (UITableView *)[self.view viewWithTag:NEMBERS_TABLE_TAG];
                [table reloadData];
                [self showAlert:[dict objectForKey:@"info"]];
            }];
        }
    }
    NSInteger tag = CONVERSATION_TABLE_TAG + index;
    UIView* table = (UIView*)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:table];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == ACTIVITY_TABLE_TAG) {//活动列表
        return [self.activitysList count];
    }else if (tableView.tag == NEMBERS_TABLE_TAG){//成员列表
        return [self.membersList count];
    }else{//会话
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    bgView.image = [UIImage imageNamed:@"bar_transition"];
    
    if (tableView.tag == CONVERSATION_TABLE_TAG) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd/HH:mm";
        NSString *dateString = [dateFormatter stringFromDate:date];
        UILabel *title = [self addLabelWithFrame:bgView.frame
                                            text:dateString
                                           color:[UIColor blackColor]
                                            font:[UIFont systemFontOfSize:12]];
        title.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:title];
    }
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == NEMBERS_TABLE_TAG) {
        return 70;
    }else if(tableView.tag == ACTIVITY_TABLE_TAG){
        return 210;
    }else{
        if (indexPath.row == 0) {
            return 140;
        }
        return 110;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == ACTIVITY_TABLE_TAG) {
        static NSString *addrIdentifier = @"activeEndIdentifier";
//        ActivityCell *activeEndCell = nil;
//        activeEndCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
//        if (!activeEndCell) {
//            activeEndCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
//            activeEndCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        activeEndCell.statusLabel.text = @"已结束";
        
        InActivityCell *activityingCell = nil;
        activityingCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!activityingCell) {
            activityingCell = [[InActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
            activityingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.activitysList) {
            NSDictionary *activity = [self.activitysList objectAtIndex:indexPath.row];
            [activityingCell resetCellParamDict:activity];
        }
        activityingCell.statusLabel.text = @"进行中";
        
        return activityingCell;
    }else if(tableView.tag == NEMBERS_TABLE_TAG){
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
        PeocelCell *myMsgCell = nil;
        myMsgCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!myMsgCell) {
            myMsgCell = [[PeocelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            myMsgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.membersList) {
            NSDictionary *member = [self.membersList objectAtIndex:indexPath.row];
            [myMsgCell resetCellParamDict:member];
        }
        return myMsgCell;
    }else{
        if (indexPath.row == 0) {
            static NSString *identifierQuestion = @"identifierQuestion";
            TribeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierQuestion];
            if (!cell) {
                cell = [[TribeQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierQuestion];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell resetCellParamDict:nil];
            return cell;
            
        }else{
            static NSString *identifier = @"identifier";
            TribeConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[TribeConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell resetCellParamDict:nil];
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
//    if (self.selectTribeCallBack) {
//        NSDictionary *dict = @{@"key":@"isBack",@"value":@"YES"};
//        self.selectTribeCallBack(dict);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    if (tableView.tag == ACTIVITY_TABLE_TAG) {//活动
        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
        [self.navigationController pushViewController:activityDetail animated:YES];
    }else if(tableView.tag == NEMBERS_TABLE_TAG){//成员
        NameCardViewController *nameCard = [[NameCardViewController alloc] init];
        [self.navigationController pushViewController:nameCard animated:YES];
    }
    
}


@end
