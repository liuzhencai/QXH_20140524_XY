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
    [self.view addSubview:endActivityTable];
    
    UITableView *inActivityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT  - segment.height) style:UITableViewStylePlain];
    inActivityTable.tag = IN_THE_ACTIVITY_TAG;
    inActivityTable.delegate = self;
    inActivityTable.dataSource = self;
    [self.view addSubview:inActivityTable];
    
    //获取活动列表
//    {
//    opercode:"0125",
//    userid:"1234565",		//用户唯一标识
//    token:"ab123456789"		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
//    start:"10",			//起始消息的artid，不填写该字段读取最新消息n个
//    direction:"before",		//方向 before获取start消息之前的n条,after获取start消息之后的n调
//    count:"20",			//获取消息数量
//    actname:"活动名称",		//活动名称
//    tags:"标签，标签"，		//不同标签之间用逗号隔开
//    district:"130400",		//地域信息
//    canjoin:"0"			//0为全部活动，1为可加入报名的活动,2为已参加的活动
//    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:nil];
    [HttpRequest requestWithParams:params andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"返回值:%@",dict);
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IN_THE_ACTIVITY_TAG) {
        return 230;
    }
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    if(tableView.tag == END_ACTIVITY_TAG){
        static NSString *addrIdentifier = @"activeEndIdentifier";
        ActivityCell *activeEndCell = nil;
        activeEndCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!activeEndCell) {
            activeEndCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
        }
        activeEndCell.statusLabel.text = @"已结束";
        
        cell = activeEndCell;
    }else if (tableView.tag == IN_THE_ACTIVITY_TAG) {
        static NSString *myMsgIdentifier = @"activingIdentifier";
        InActivityCell *activityingCell = nil;
        activityingCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!activityingCell) {
            activityingCell = [[InActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
//            activityingCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
        }
        activityingCell.statusLabel.text = @"进行中";
        cell = activityingCell;
    }
    return cell;
    
    //    ActivityCell *cell;
    //    static NSString *cellIdentifier = @"activityIdentifier";
    //    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //    if (!cell) {
    //        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
    //    }
    //
    //    return cell;
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
        [self.navigationController pushViewController:filterTime animated:YES];
    }
}

@end
