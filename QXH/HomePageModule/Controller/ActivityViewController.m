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

@interface ActivityViewController ()<CustomSegmentControlDelegate>
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, strong) NSMutableArray *inActivitysList;//进行的活动
@property (nonatomic, strong) NSMutableArray *endActivitysList;//结束的活动
@end

#define IN_THE_ACTIVITY_TAG 2330
#define END_ACTIVITY_TAG 2331

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectIndex = 1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"活动";
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 20; i ++) {
        [tmpArr addObject:@{@"name":@"",@"des":@"",@"creater":@"",@"imgUrl":@""}];
    }
    self.inActivitysList = tmpArr;
    self.endActivitysList = tmpArr;
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,40, 30);
    [righttbuttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [righttbuttonItem setTitle:@"更多" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    //segment
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32) andTitles:@[@"进行的活动",@"结束的活动"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    UITableView *endActivityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    endActivityTable.tag = END_ACTIVITY_TAG;
    endActivityTable.delegate = self;
    endActivityTable.dataSource = self;
    endActivityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:endActivityTable];
    
    UITableView *inActivityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT  - segment.height) style:UITableViewStylePlain];
    inActivityTable.tag = IN_THE_ACTIVITY_TAG;
    inActivityTable.delegate = self;
    inActivityTable.dataSource = self;
    inActivityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:inActivityTable];
    
    //获取数据
    [self getActivityList];
}

- (void)getActivityList{
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
    
    [DataInterface getActList:@"0"
                        count:@"20"
                      actname:@""
                          tag:@""
                     district:@""
                      canjoin:@"0"
                     actstate:@"0"
                    begindate:@""
                      enddate:@""
        withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"活动列表返回数据:%@",dict);
            [self showAlert:[dict objectForKey:@"info"]];
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
}

- (void)more:(UIButton *)sender{
//    SelectTribeViewController *selectTribe = [[SelectTribeViewController alloc] init];
//    selectTribe.selectTribeCallBack = ^(NSDictionary *Dict){
//        NSLog(@"call back:%@",Dict);
//    };
//    [self.navigationController pushViewController:selectTribe animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"发布",@"筛选", nil];
    
    [alert show];
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
//    return 220;
    return 230;
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
        [activeEndCell resetCellParamDict:nil];
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
        [activityingCell resetCellParamDict:nil];
        activityingCell.statusLabel.text = @"进行中";
        cell = activityingCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == IN_THE_ACTIVITY_TAG) {
        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
        [self.navigationController pushViewController:activityDetail animated:YES];
    }else{
        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
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
        filterTime.filterTimeCallBack = ^(id object){
            NSArray *arr = (NSArray *)object;
            NSLog(@"筛选条件：%@",arr);
            //此处根据筛选条件请求数据
            if ([arr count]) {
                [self selectActivityWithconditions:arr];
            }
        };
        [self.navigationController pushViewController:filterTime animated:YES];
    }
}

- (void)selectActivityWithconditions:(NSArray *)conditions{
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
    
    [DataInterface getActList:@""
                        count:@"20"
                      actname:@""
                          tag:@""
                     district:@""
                      canjoin:@"0"  //0为全部活动
                     actstate:@"0"  //0为全部
                    begindate:@""
                      enddate:@""
        withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"活动列表筛选返回数据:%@",dict);
            [self showAlert:[dict objectForKey:@"info"]];
        }];

}

@end
