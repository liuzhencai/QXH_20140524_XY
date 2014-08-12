//
//  ActivityViewController.m
//  QXH
//
//  Created by XUE on 14-5-19.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityCell.h"
#import "ActivityDetailViewController.h"
#import "PromotionalActvityViewController.h"
#import "SelectTribeViewController.h"
#import "FilterTimeViewController.h"
#import "CustomSegmentControl.h"
#import "InActivityCell.h"
#import "MJRefresh.h"
#import "FilterActivityResultViewController.h"

@interface ActivityViewController ()<CustomSegmentControlDelegate>
@property (nonatomic, strong) UITableView *inActivityTable;
@property (nonatomic, strong) UITableView *endActivityTable;
@property (nonatomic, strong) NSMutableArray *inActivitysList;//进行的活动
@property (nonatomic, strong) NSMutableArray *endActivitysList;//结束的活动
@property (nonatomic, assign) BOOL isFilter;//是否是筛选

@property (nonatomic, assign) NSInteger curIndex;//当前下标

@end

#define IN_THE_ACTIVITY_TAG 2330
#define END_ACTIVITY_TAG 2331

#define ACTIVITY_STATUS_IN @"2" //正在进行的活动
#define ACTIVITY_STATUS_END @"3" //已经结束的活动

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _inActivitysList = [[NSMutableArray alloc] initWithCapacity:0];
        _endActivitysList = [[NSMutableArray alloc] initWithCapacity:0];
        _curIndex = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:TYPE_LOOK_ACTIVITY];
    [MobClick beginEvent:TYPE_LOOK_ACTIVITY];
    //获取数据
    if (!_isFilter) {
        if (_curIndex == 0) {
            [self.inActivityTable headerBeginRefreshing];
        }else{
            [self.endActivityTable headerBeginRefreshing];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:TYPE_LOOK_ACTIVITY];
    [MobClick endEvent:TYPE_LOOK_ACTIVITY];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"活动";
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,40, 30);
    [righttbuttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [righttbuttonItem setTitle:@"更多" forState:UIControlStateNormal];
    righttbuttonItem.titleLabel.font = [UIFont systemFontOfSize:17];
    [righttbuttonItem addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    //segment
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, MENU_HEIGHT) andTitles:@[@"进行的活动",@"结束的活动"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    UITableView *endActivityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, segment.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    endActivityTable.tag = END_ACTIVITY_TAG;
    self.endActivityTable = endActivityTable;
    endActivityTable.delegate = self;
    endActivityTable.dataSource = self;
    endActivityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh:endActivityTable];
    [self.view addSubview:endActivityTable];
    
    UITableView *inActivityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, segment.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT  - segment.height) style:UITableViewStylePlain];
    inActivityTable.tag = IN_THE_ACTIVITY_TAG;
    self.inActivityTable = inActivityTable;
    inActivityTable.delegate = self;
    inActivityTable.dataSource = self;
    inActivityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh:inActivityTable];
    [self.view addSubview:inActivityTable];
    
    //获取数据
//    [self.inActivityTable headerBeginRefreshing];
}

- (void)getFilterActivityListWithStatus:(NSString *)status{
    //获取筛选活动列表
    [DataInterface getActList:@"0"
                        count:@"100"
                      actname:@""
                contentlength:@"30"
                          tag:@""
                     district:@""
                      canjoin:@"0"
                     actstate:status
                       status:@"1"
                      tribeid:@"0"
                    begindate:@""
                      enddate:@""
        withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"活动列表返回数据:%@",dict);
            if (dict) {
                NSArray *list = [dict objectForKey:@"list"];
                if ([status isEqualToString:ACTIVITY_STATUS_IN]) {
                    self.inActivitysList = [NSMutableArray arrayWithArray:list];
                    UITableView *table = (UITableView *)[self.view viewWithTag:IN_THE_ACTIVITY_TAG];
                    [table reloadData];
                }else{
                    self.endActivitysList = [NSMutableArray arrayWithArray:list];
                    UITableView *table = (UITableView *)[self.view viewWithTag:END_ACTIVITY_TAG];
                    [table reloadData];
                }
            }
        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomSegmentControlDelegate
- (void)segmentClicked:(NSInteger)index{
    NSLog(@"segment index:%d",index);
    NSInteger tag = IN_THE_ACTIVITY_TAG + index;
    UITableView *table = (UITableView *)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:table];
    
    _curIndex = index;
    if (_curIndex == 0) {
        if ([self.inActivitysList count] == 0) {
            [self.inActivityTable headerBeginRefreshing];
        }
    }else{
        if ([self.endActivitysList count] == 0) {
            [self.endActivityTable headerBeginRefreshing];
        }
    }
}

- (void)more:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"发布",@"筛选", nil];
    
    [alert show];
}

- (void)requestInfoList:(NSString *)type start:(NSString *)start withCompletionHandler:(ListCallback)callback{
    //获取活动列表
    /**
     *  获取/搜索活动列表(列表按创建时间的逆序排列)
     *
     *  @param start     起始消息的artid，不填写该字段读取最新消息n个
     *  @param count     获取消息数量
     *  @param actname   活动名称
     *  @param tribeid   活动描述的长度
     *  @param tag       标签
     *  @param district  地域信息
     *  @param canjoin   0为全部活动，1为未参加的活动,2为已参加的活动,3为和我有关的活动（参加的，关注的）
     *  @param actstate  活动状态 0为全部，1为未开始的活动，2为正在进行的活动，3为已结束的活动
     *  @param status	 活动状态 0为全部，1为已审批的活动，2为审批中的活动，3为审批拒绝的活动
     *  @param tribeid   部落id，不为0时读取分享到该部落的活动
     *  @param begindate 活动起始时间
     *  @param enddate   活动结束时间
     *  @param callback  回调
     */
    
    [DataInterface getActList:start
                        count:@"20"
                      actname:@""
                contentlength:@"30"
                          tag:@""
                     district:@""
                      canjoin:@"0"
                     actstate:type
                       status:@"1"
                      tribeid:@"0"
                    begindate:@""
                      enddate:@""
        withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"活动列表返回数据:%@",dict);
            if (dict) {
                NSMutableArray *list = (NSMutableArray *)[dict objectForKey:@"list"];
                callback(list);
            }
        }];
    
}

#pragma mark - Refresh
/**
 *  集成刷新控件
 */
- (void)setupRefresh:(UITableView *)tableView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    NSString *type = _curIndex == 0 ? ACTIVITY_STATUS_IN:ACTIVITY_STATUS_END;
    [self requestInfoList:type start:@"0" withCompletionHandler:^(NSMutableArray *list) {
        // 1.添加数据
        if (_curIndex == 0) {
            [self.inActivitysList removeAllObjects];
            [self.inActivitysList addObjectsFromArray:list];
            [self.inActivityTable reloadData];
            [self.inActivityTable headerEndRefreshing];
        }else{
            [self.endActivitysList removeAllObjects];
            [self.endActivitysList addObjectsFromArray:list];
            [self.endActivityTable reloadData];
            [self.endActivityTable headerEndRefreshing];
        }
        
        // 2.2秒后刷新表格UI
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            // 刷新表格
        //            UITableView *tableView = [_tableArr objectAtIndex:_curIndex];
        //            [tableView reloadData];
        //            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        //            [tableView headerEndRefreshing];
        //        });
    }];
}

- (void)footerRereshing{
    NSString *type = _curIndex == 0 ? ACTIVITY_STATUS_IN:ACTIVITY_STATUS_END;
    NSString *startId = @"0";
    if (_curIndex == 0) {
        if ([self.inActivitysList count]) {
            NSDictionary *dict = [self.inActivitysList lastObject];
            startId = [[dict objectForKey:@"actid"] stringValue];
        }
    }else{
        if ([self.endActivitysList count]) {
            NSDictionary *dict = [self.endActivitysList lastObject];
            startId = [[dict objectForKey:@"actid"] stringValue];
        }
    }
    [self requestInfoList:type start:startId withCompletionHandler:^(NSMutableArray *list) {
        // 1.添加数据
        if (_curIndex == 0) {
            [self.inActivitysList addObjectsFromArray:list];
            [self.inActivityTable reloadData];
            [self.inActivityTable footerEndRefreshing];
        }else{
            [self.endActivitysList addObjectsFromArray:list];
            [self.endActivityTable reloadData];
            [self.endActivityTable footerEndRefreshing];
        }
        // 2.2秒后刷新表格UI
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            // 刷新表格
        //            UITableView *tableView = [_tableArr objectAtIndex:_curIndex];
        //            [tableView reloadData];
        //            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        //            [tableView headerEndRefreshing];
        //        });
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == IN_THE_ACTIVITY_TAG) {
        return [self.inActivitysList count];
    }else{
        return [self.endActivitysList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (IN_THE_ACTIVITY_TAG) {
//        return 230;
//    }
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(tableView.tag == END_ACTIVITY_TAG){
        static NSString *addrIdentifier = @"activeEndIdentifier";
        InActivityCell *activeEndCell = nil;
        activeEndCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!activeEndCell) {
            activeEndCell = [[InActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
            activeEndCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.endActivitysList) {
            NSDictionary *activityDict = [self.endActivitysList objectAtIndex:indexPath.row];
            [activeEndCell resetCellParamDict:activityDict];
        }
        activeEndCell.statusLabel.text = @"已结束";
        cell = activeEndCell;
    }else if (tableView.tag == IN_THE_ACTIVITY_TAG) {
        static NSString *myMsgIdentifier = @"activingIdentifier";
        InActivityCell *activityingCell = nil;
        activityingCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!activityingCell) {
            activityingCell = [[InActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            activityingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.inActivitysList) {
            NSDictionary *activityDict = [self.inActivitysList objectAtIndex:indexPath.row];
            [activityingCell resetCellParamDict:activityDict];
        }
        
        activityingCell.statusLabel.text = @"进行中";
        cell = activityingCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == IN_THE_ACTIVITY_TAG) {
        NSDictionary *inActivity = [self.inActivitysList objectAtIndex:indexPath.row];
        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
        activityDetail.activityId = [inActivity objectForKey:@"actid"];
        [self.navigationController pushViewController:activityDetail animated:YES];
    }else{
        NSDictionary *endActivity = [self.endActivitysList objectAtIndex:indexPath.row];
        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
        activityDetail.activityId = [endActivity objectForKey:@"actid"];
        activityDetail.isActivityEnd = YES;
        [self.navigationController pushViewController:activityDetail animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.firstOtherButtonIndex == buttonIndex) {//发起活动
        NSLog(@"发起活动");
        PromotionalActvityViewController *promotional = [[PromotionalActvityViewController alloc] init];
        [self.navigationController pushViewController:promotional animated:YES];
    }else if (2 == buttonIndex){//筛选
        NSLog(@"筛选");
        FilterTimeViewController *filterTime = [[FilterTimeViewController alloc] init];
        self.isFilter = YES;
        filterTime.filterTimeCallBack = ^(id object){
            [self.navigationController popViewControllerAnimated:NO];
//            self.isFilter = NO;
            NSString *dateString = (NSString *)object;
            NSLog(@"筛选条件：%@",dateString);
            //此处根据筛选条件请求数据
            if ([dateString length]) {
                [self selectActivityWithconditions:dateString];
            }
        };
        [self.navigationController pushViewController:filterTime animated:YES];
    }
}

- (void)selectActivityWithconditions:(NSString *)endDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *begigDate = [formater stringFromDate:date];
    [DataInterface getActList:@"0"
                        count:@"20"
                      actname:@""
                contentlength:@"30"
                          tag:@""
                     district:@""
                      canjoin:@"0"
                     actstate:@"0"
                       status:@"1"
                      tribeid:@""
                    begindate:begigDate
                      enddate:endDate
        withCompletionHandler:^(NSMutableDictionary *dict){
            self.isFilter = NO;
            NSLog(@"活动列表筛选返回数据:%@",dict);
            NSMutableArray *list = (NSMutableArray *)[dict objectForKey:@"list"];
            if ([list count]) {
                FilterActivityResultViewController *filterActivity = [[FilterActivityResultViewController alloc] init];
                filterActivity.activitysList = list;
                [self.navigationController pushViewController:filterActivity animated:YES];
            }else{
                [self showAlert:@"没有相关活动"];
            }
            
        }];
}

@end
