//
//  InfluenceViewController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "InfluenceViewController.h"
#import "CustomSegmentControl.h"
#import "InActivityCell.h"
#import "InfluenceCell.h"
#import "NameCardViewController.h"
#import "MJRefresh.h"

@interface InfluenceViewController ()<UITableViewDataSource,UITableViewDelegate,CustomSegmentControlDelegate>
@property (nonatomic, strong) UITableView *fansTable;
@property (nonatomic, strong) UITableView *forwardOrReviewTable;//
@property (nonatomic, strong) NSMutableArray *fansList;//粉丝榜
@property (nonatomic, strong) NSMutableArray *forwardOrReviewList;//转评榜

@property (nonatomic, assign) NSInteger curIndex;//当前下标

@end
#define FANS_TAG 2330  //fans 粉丝榜
#define FORWARD_REVIEW_TAG 2331       //forwardOrReview 转评榜

#define TYPE_OF_FANS @"1"
#define TYPE_OF_fORWARD_REVIEW @"2"
@implementation InfluenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _fansList = [[NSMutableArray alloc] initWithCapacity:0];
        _forwardOrReviewList = [[NSMutableArray alloc] initWithCapacity:0];
        _curIndex = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:TYPE_LOOK_INFLUENCE];
    [MobClick beginEvent:TYPE_LOOK_INFLUENCE];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:TYPE_LOOK_INFLUENCE];
    [MobClick endEvent:TYPE_LOOK_INFLUENCE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"影响力";
    
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, MENU_HEIGHT) andTitles:@[@"粉丝榜",@"转评榜"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    UITableView *forwardOrReviewTable = [[UITableView alloc] initWithFrame:CGRectMake(0, segment.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    forwardOrReviewTable.tag = FORWARD_REVIEW_TAG;
    self.forwardOrReviewTable = forwardOrReviewTable;
    forwardOrReviewTable.delegate = self;
    forwardOrReviewTable.dataSource = self;
    forwardOrReviewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh:forwardOrReviewTable];
    [self.view addSubview:forwardOrReviewTable];
    
    UITableView *fansTable = [[UITableView alloc] initWithFrame:CGRectMake(0, segment.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT  - segment.height) style:UITableViewStylePlain];
    fansTable.tag = FANS_TAG;
    self.fansTable = fansTable;
    fansTable.delegate = self;
    fansTable.dataSource = self;
    fansTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh:fansTable];
    [self.view addSubview:fansTable];
    
    [self.fansTable headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getFansListWithType:(NSString *)type{
    NSLog(@"获取粉丝");
    /**
     *  获取影响力
     *
     *  @param type     1为粉丝榜，2为活跃榜
     *  @param callback 回调
     */
    [DataInterface getInfluence:type withCompletionHandler:^(NSMutableDictionary *dict){
        NSLog(@"粉丝返回值:%@",dict);
        if ([type isEqualToString:TYPE_OF_FANS]) {
            self.fansList = [dict objectForKey:@"list"];
            UITableView *table = (UITableView *)[self.view viewWithTag:FANS_TAG];
            [table reloadData];
        }else if([type isEqualToString:TYPE_OF_fORWARD_REVIEW]){
            self.forwardOrReviewList = [dict objectForKey:@"list"];
            UITableView *table = (UITableView *)[self.view viewWithTag:FORWARD_REVIEW_TAG];
            [table reloadData];
        }
        [self showAlert:[dict objectForKey:@"info"]];
    }];
}

#pragma mark - CustomSegmentControlDelegate
- (void)segmentClicked:(NSInteger)index{
    NSLog(@"segment index:%d",index);
    NSInteger tag = FANS_TAG + index;
    UITableView *table = (UITableView *)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:table];
    _curIndex = index;
    if (_curIndex == 0) {
        if ([self.fansList count] == 0) {
            [self.fansTable headerBeginRefreshing];
        }
    }else{
        if ([self.forwardOrReviewList count] == 0) {
            [self.forwardOrReviewTable headerBeginRefreshing];
        }
    }
}

- (void)requestInfoList:(NSString *)type withCompletionHandler:(ListCallback)callback{
    /**
     *  获取影响力
     *  @param type     1为粉丝榜，2为活跃榜
     *  @param callback 回调
     */
    [DataInterface getInfluence:type withCompletionHandler:^(NSMutableDictionary *dict){
        NSLog(@"粉丝返回值:%@",dict);
        
        NSMutableArray *list = (NSMutableArray *)[dict objectForKey:@"list"];
        callback(list);
//        if ([type isEqualToString:TYPE_OF_FANS]) {
//            self.fansList = [dict objectForKey:@"list"];
//            UITableView *table = (UITableView *)[self.view viewWithTag:FANS_TAG];
//            [table reloadData];
//        }else if([type isEqualToString:TYPE_OF_fORWARD_REVIEW]){
//            self.forwardOrReviewList = [dict objectForKey:@"list"];
//            UITableView *table = (UITableView *)[self.view viewWithTag:FORWARD_REVIEW_TAG];
//            [table reloadData];
//        }
//        [self showAlert:[dict objectForKey:@"info"]];
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
//    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    NSString *type = _curIndex == 0 ? @"1":@"2";
    [self requestInfoList:type withCompletionHandler:^(NSMutableArray *list) {
        // 1.添加数据
        if (_curIndex == 0) {
            [self.fansList removeAllObjects];
            [self.fansList addObjectsFromArray:list];
            [self.fansTable reloadData];
            [self.fansTable headerEndRefreshing];
        }else{
            [self.forwardOrReviewList removeAllObjects];
            [self.forwardOrReviewList addObjectsFromArray:list];
            [self.forwardOrReviewTable reloadData];
            [self.forwardOrReviewTable headerEndRefreshing];
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
    if (tableView.tag == FANS_TAG) {
        return [self.fansList count];
    }else{
        return [self.forwardOrReviewList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(tableView.tag == FORWARD_REVIEW_TAG){
        static NSString *addrIdentifier = @"activeEndIdentifier";
        InfluenceCell *activeEndCell = nil;
        activeEndCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!activeEndCell) {
            activeEndCell = [[InfluenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
            activeEndCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        activeEndCell.isFans = NO;
        if (self.forwardOrReviewList) {
            NSDictionary *activityDict = [self.forwardOrReviewList objectAtIndex:indexPath.row];
            [activeEndCell resetCellParamDict:activityDict];
        }
//        activeEndCell.statusLabel.text = @"已结束";
        cell = activeEndCell;
    }else if (tableView.tag == FANS_TAG) {
        static NSString *myMsgIdentifier = @"activingIdentifier";
        InfluenceCell *activityingCell = nil;
        activityingCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!activityingCell) {
            activityingCell = [[InfluenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            activityingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        activityingCell.isFans = YES;
        if (self.fansList) {
            NSDictionary *activityDict = [self.fansList objectAtIndex:indexPath.row];
            [activityingCell resetCellParamDict:activityDict];
        }
        
//        activityingCell.statusLabel.text = @"进行中";
        cell = activityingCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userInfo = nil;
    if (tableView.tag == FANS_TAG) {
        userInfo = [self.fansList objectAtIndex:indexPath.row];
    }else{
        userInfo = [self.forwardOrReviewList objectAtIndex:indexPath.row];
    }
    
    NameCardViewController *nameCard = [[NameCardViewController alloc] init];
    nameCard.isMyFriend = NO;
    nameCard.memberDict = userInfo;
    [self.navigationController pushViewController:nameCard animated:YES];
}

@end
