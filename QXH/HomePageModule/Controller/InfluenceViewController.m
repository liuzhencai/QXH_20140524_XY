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

@interface InfluenceViewController ()<UITableViewDataSource,UITableViewDelegate,CustomSegmentControlDelegate>
@property (nonatomic, strong) NSMutableArray *fansList;//粉丝榜
@property (nonatomic, strong) NSMutableArray *forwardOrReviewList;//转评榜

@end
#define IN_THE_ACTIVITY_TAG 2330
#define END_ACTIVITY_TAG 2331

#define TYPE_OF_FANS @"1"
#define TYPE_OF_fORWARD_REVIEW @"2"
@implementation InfluenceViewController

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
    self.title = @"影响力";
    
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32) andTitles:@[@"粉丝榜",@"转评榜"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    _fansList = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
    _forwardOrReviewList = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
    
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
    
    [self getFansListWithType:TYPE_OF_FANS];
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
//    + (void)getInfluence:(NSString *)type
//withCompletionHandler:(DictCallback)callback;
    [DataInterface getInfluence:type withCompletionHandler:^(NSMutableDictionary *dict){
        NSLog(@"粉丝返回值:%@",dict);
        if ([type isEqualToString:TYPE_OF_FANS]) {
            self.fansList = [dict objectForKey:@"list"];
        }else if([type isEqualToString:TYPE_OF_fORWARD_REVIEW]){
            self.forwardOrReviewList = [dict objectForKey:@"list"];
        }
        [self showAlert:[dict objectForKey:@"info"]];
    }];
}

#pragma mark - CustomSegmentControlDelegate
- (void)segmentClicked:(NSInteger)index{
    NSLog(@"segment index:%d",index);
    NSInteger tag = IN_THE_ACTIVITY_TAG + index;
    UITableView *table = (UITableView *)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:table];
    
    if (index == 1) {
        [self getFansListWithType:TYPE_OF_fORWARD_REVIEW];
    }
    [table reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == IN_THE_ACTIVITY_TAG) {
        return [self.fansList count];
    }else{
        return [self.forwardOrReviewList count];
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
        if (self.forwardOrReviewList) {
            NSDictionary *activityDict = [self.forwardOrReviewList objectAtIndex:indexPath.row];
//            [activeEndCell resetCellParamDict:activityDict];
        }
//        activeEndCell.statusLabel.text = @"已结束";
        cell = activeEndCell;
    }else if (tableView.tag == IN_THE_ACTIVITY_TAG) {
        static NSString *myMsgIdentifier = @"activingIdentifier";
        InActivityCell *activityingCell = nil;
        activityingCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!activityingCell) {
            activityingCell = [[InActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            activityingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.fansList) {
//            NSDictionary *activityDict = [self.fansList objectAtIndex:indexPath.row];
//            [activityingCell resetCellParamDict:activityDict];
        }
        
//        activityingCell.statusLabel.text = @"进行中";
        cell = activityingCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.tag == IN_THE_ACTIVITY_TAG) {
//        NSDictionary *inActivity = [self.inActivitysList objectAtIndex:indexPath.row];
//        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
//        activityDetail.activityId = [inActivity objectForKey:@"actid"];
//        [self.navigationController pushViewController:activityDetail animated:YES];
//    }else{
//        NSDictionary *endActivity = [self.endActivitysList objectAtIndex:indexPath.row];
//        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
//        activityDetail.activityId = [endActivity objectForKey:@"actid"];
//        activityDetail.isActivityEnd = YES;
//        [self.navigationController pushViewController:activityDetail animated:YES];
//    }
}

@end
